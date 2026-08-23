/// Cartesian and pie charts drawn with [CustomPaint].
/// Tokens from [PlexThemeData].
library;

import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:plex/plex_theme.dart';
import 'package:plex/plex_utils/plex_dimensions.dart';

/// Chart mark for [PlexChart].
enum PlexChartType {
  bar,
  line,
  pie,
  donut,
  scatter,
  combo,
  heatmap,
}

/// One plotted series.
class PlexChartSeries {
  const PlexChartSeries({
    required this.name,
    required this.data,
    this.color,
    this.mark,
  });

  final String name;
  final List<double> data;
  final Color? color;

  /// Per-series mark for [PlexChartType.combo] (`bar` or `line`).
  /// Null uses the combo default (first series bars, remaining series lines).
  final PlexChartType? mark;
}

const double _kPadL = 44;
const double _kPadR = 8;
const double _kPadT = 12;
const double _kPadB = 8;
const double _kBarRadius = 2;
const int _kTickCount = 4;

/// Analytics chart (bar / line / pie / donut / scatter / combo / heatmap)
/// in the enterprise-BI idiom: horizontal gridlines only, hairline weight,
/// near-square bars.
class PlexChart extends StatelessWidget {
  const PlexChart({
    super.key,
    this.type = PlexChartType.bar,
    required this.series,
    this.labels,
    this.height = 240,
  });

  final PlexChartType type;
  final List<PlexChartSeries> series;
  final List<String>? labels;
  final double height;

  static List<Color> _palette(PlexColorTokens colors) {
    return <Color>[
      colors.brandPrimary,
      colors.statusInfo,
      colors.statusSuccess,
      colors.statusWarning,
      colors.statusDanger,
    ];
  }

  bool get _isEmpty {
    if (series.isEmpty) return true;
    return series.every((PlexChartSeries s) => s.data.isEmpty);
  }

  /// Multiple one-value series → one slice each; otherwise first series values.
  bool get _pieFromSeries {
    return series.length > 1 &&
        series.every((PlexChartSeries s) => s.data.length <= 1);
  }

  Color _seriesColor(PlexColorTokens colors, int index) {
    final List<Color> palette = _palette(colors);
    return series[index].color ?? palette[index % palette.length];
  }

  @override
  Widget build(BuildContext context) {
    final PlexColorTokens colors = PlexThemeData.of(context).colors;
    final List<Color> palette = _palette(colors);
    final bool empty = _isEmpty;

    final List<Color> seriesColors = <Color>[
      for (int i = 0; i < series.length; i++) _seriesColor(colors, i),
    ];

    final CustomPainter painter;
    if (empty) {
      painter = _PlexEmptyChartPainter(grid: colors.borderSubtle);
    } else if (type == PlexChartType.pie || type == PlexChartType.donut) {
      painter = _PlexPiePainter(
        values: _pieValues(),
        sliceColors: _pieColors(palette, seriesColors),
        holeColor: type == PlexChartType.donut ? colors.surfaceCard : null,
      );
    } else if (type == PlexChartType.heatmap) {
      painter = _PlexHeatmapPainter(
        series: series,
        categoryCount: _categoryCount(series, labels),
        lo: colors.surfaceSunken,
        hi: colors.brandPrimary,
        tick: colors.textMuted,
      );
    } else {
      painter = _PlexCartesianPainter(
        marks: _plotMarks(),
        series: series,
        seriesColors: seriesColors,
        categoryCount: _categoryCount(series, labels),
        grid: colors.borderSubtle,
        axis: colors.borderDefault,
        zero: colors.borderStrong,
        tick: colors.textMuted,
        surface: colors.surfaceCard,
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: height,
          width: double.infinity,
          child: CustomPaint(
            painter: painter,
            child: empty
                ? Center(
                    child: Text(
                      'No data',
                      style: TextStyle(
                        color: colors.textMuted,
                        fontSize: PlexFontSize.small,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                : const SizedBox.expand(),
          ),
        ),
        if (!_isRadial && labels != null && labels!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(
              left: _kPadL,
              right: _kPadR,
              top: PlexDim.mini,
            ),
            child: Row(
              children: [
                for (final String label in labels!)
                  Expanded(
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: colors.textMuted,
                        fontSize: PlexFontSize.smallest,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        if (series.isNotEmpty || (labels != null && labels!.isNotEmpty)) ...[
          const SizedBox(height: PlexDim.small),
          _ChartLegend(
            colors: colors,
            items: _legendItems(palette, seriesColors),
          ),
        ],
      ],
    );
  }

  List<double> _pieValues() {
    if (_pieFromSeries) {
      return <double>[
        for (final PlexChartSeries s in series)
          s.data.isEmpty ? 0 : s.data.first,
      ];
    }
    if (series.isEmpty) return const <double>[];
    return series.first.data;
  }

  List<Color> _pieColors(List<Color> palette, List<Color> seriesColors) {
    final List<double> values = _pieValues();
    return <Color>[
      for (int i = 0; i < values.length; i++)
        _pieFromSeries && i < seriesColors.length
            ? seriesColors[i]
            : (i == 0 && series.isNotEmpty && series.first.color != null
                ? series.first.color!
                : palette[i % palette.length]),
    ];
  }

  List<({Color color, String name})> _legendItems(
    List<Color> palette,
    List<Color> seriesColors,
  ) {
    if (_isRadial) {
      if (_pieFromSeries || (labels == null || labels!.isEmpty)) {
        return <({Color color, String name})>[
          for (int i = 0; i < series.length; i++)
            (
              color: i < seriesColors.length
                  ? seriesColors[i]
                  : palette[i % palette.length],
              name: series[i].name,
            ),
        ];
      }
      final List<({Color color, String name})> items =
          <({Color color, String name})>[];
      if (series.isNotEmpty) {
        items.add((
          color: seriesColors.isNotEmpty ? seriesColors.first : palette.first,
          name: series.first.name,
        ));
      }
      for (int i = 0; i < labels!.length; i++) {
        final String label = labels![i];
        if (series.isNotEmpty && label == series.first.name) continue;
        items.add((
          color: palette[i % palette.length],
          name: label,
        ));
      }
      return items;
    }

    return <({Color color, String name})>[
      for (int i = 0; i < series.length; i++)
        (color: seriesColors[i], name: series[i].name),
    ];
  }

  bool get _isRadial =>
      type == PlexChartType.pie || type == PlexChartType.donut;

  List<_PlotMark> _plotMarks() {
    switch (type) {
      case PlexChartType.line:
        return List<_PlotMark>.filled(series.length, _PlotMark.line);
      case PlexChartType.scatter:
        return List<_PlotMark>.filled(series.length, _PlotMark.scatter);
      case PlexChartType.combo:
        final bool allNull =
            series.every((PlexChartSeries s) => s.mark == null);
        if (allNull) {
          return <_PlotMark>[
            for (int i = 0; i < series.length; i++)
              i == 0 ? _PlotMark.bar : _PlotMark.line,
          ];
        }
        return <_PlotMark>[
          for (final PlexChartSeries s in series)
            s.mark == PlexChartType.line ? _PlotMark.line : _PlotMark.bar,
        ];
      default:
        return List<_PlotMark>.filled(series.length, _PlotMark.bar);
    }
  }
}

enum _PlotMark { bar, line, scatter }

int _categoryCount(List<PlexChartSeries> series, List<String>? labels) {
  int n = labels?.length ?? 0;
  for (final PlexChartSeries s in series) {
    if (s.data.length > n) n = s.data.length;
  }
  return n;
}

class _ChartLegend extends StatelessWidget {
  const _ChartLegend({
    required this.colors,
    required this.items,
  });

  final PlexColorTokens colors;
  final List<({Color color, String name})> items;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: PlexDim.medium,
      runSpacing: PlexDim.small,
      children: [
        for (final ({Color color, String name}) item in items)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 9,
                height: 9,
                decoration: BoxDecoration(
                  color: item.color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: PlexDim.small),
              Text(
                item.name,
                style: TextStyle(
                  color: colors.textSecondary,
                  fontSize: PlexFontSize.small,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
      ],
    );
  }
}

class _PlexEmptyChartPainter extends CustomPainter {
  _PlexEmptyChartPainter({required this.grid});

  final Color grid;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    final Paint paint = Paint()
      ..color = grid
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    const int lines = 4;
    for (int i = 0; i <= lines; i++) {
      final double y = size.height * i / lines;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _PlexEmptyChartPainter oldDelegate) {
    return oldDelegate.grid != grid;
  }
}

class _PlexCartesianPainter extends CustomPainter {
  _PlexCartesianPainter({
    required this.marks,
    required this.series,
    required this.seriesColors,
    required this.categoryCount,
    required this.grid,
    required this.axis,
    required this.zero,
    required this.tick,
    required this.surface,
  });

  final List<_PlotMark> marks;
  final List<PlexChartSeries> series;
  final List<Color> seriesColors;
  final int categoryCount;
  final Color grid;
  final Color axis;
  final Color zero;
  final Color tick;
  final Color surface;

  double _yAt(double v, double plotH, double lo, double span) {
    return _kPadT + plotH - ((v - lo) / span) * plotH;
  }

  double _xAt(int i, double bandW) => _kPadL + bandW * (i + 0.5);

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty || categoryCount <= 0) return;

    double rawMax = 0;
    double rawMin = 0;
    for (final PlexChartSeries s in series) {
      for (final double v in s.data) {
        if (v > rawMax) rawMax = v;
        if (v < rawMin) rawMin = v;
      }
    }

    final ({double min, double max, List<double> ticks}) scale =
        _niceScale(rawMin, rawMax, _kTickCount);

    final double plotW = math.max(1, size.width - _kPadL - _kPadR);
    final double plotH = math.max(1, size.height - _kPadT - _kPadB);
    final double span = scale.max - scale.min == 0 ? 1 : scale.max - scale.min;

    final Paint gridPaint = Paint()
      ..color = grid
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    for (final double t in scale.ticks) {
      final double y = _yAt(t, plotH, scale.min, span);
      canvas.drawLine(
        Offset(_kPadL, y),
        Offset(_kPadL + plotW, y),
        gridPaint,
      );
    }

    if (scale.min < 0 && scale.max > 0) {
      final Paint zeroPaint = Paint()
        ..color = zero
        ..strokeWidth = 1
        ..style = PaintingStyle.stroke;
      final double y0 = _yAt(0, plotH, scale.min, span);
      canvas.drawLine(
        Offset(_kPadL, y0),
        Offset(_kPadL + plotW, y0),
        zeroPaint,
      );
    }

    final Paint axisPaint = Paint()
      ..color = axis
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
      Offset(_kPadL, _kPadT),
      Offset(_kPadL, _kPadT + plotH),
      axisPaint,
    );
    canvas.drawLine(
      Offset(_kPadL, _kPadT + plotH),
      Offset(_kPadL + plotW, _kPadT + plotH),
      axisPaint,
    );

    final TextStyle tickStyle = TextStyle(
      color: tick,
      fontSize: PlexFontSize.smallest,
      fontWeight: FontWeight.w600,
    );
    for (final double t in scale.ticks) {
      final TextPainter tp = TextPainter(
        text: TextSpan(text: _fmtTick(t), style: tickStyle),
        textDirection: ui.TextDirection.ltr,
        maxLines: 1,
      )..layout(maxWidth: _kPadL - 8);
      tp.paint(
        canvas,
        Offset(
          _kPadL - 6 - tp.width,
          _yAt(t, plotH, scale.min, span) - tp.height / 2,
        ),
      );
    }

    final double bandW = plotW / categoryCount;

    final int barCount =
        marks.where((_PlotMark m) => m == _PlotMark.bar).length;
    if (barCount > 0) {
      final int groupCount = math.max(1, barCount);
      final double barW = math.min(52, (bandW * 0.66) / groupCount);
      const double gap = 2;
      final double drawW = math.max(1, barW - gap);
      int barIndex = 0;
      for (int si = 0; si < series.length; si++) {
        if (si >= marks.length || marks[si] != _PlotMark.bar) continue;
        final Paint fill = Paint()
          ..color = seriesColors[si]
          ..style = PaintingStyle.fill;
        for (int i = 0; i < categoryCount; i++) {
          final double v = i < series[si].data.length ? series[si].data[i] : 0;
          final double y = _yAt(v, plotH, scale.min, span);
          final double y0 = _yAt(0, plotH, scale.min, span);
          final double top = math.min(y, y0);
          final double h = math.max(0, (y - y0).abs());
          final double x =
              _xAt(i, bandW) - (barW * groupCount) / 2 + barW * barIndex;
          final RRect rrect = RRect.fromRectAndRadius(
            Rect.fromLTWH(x, top, drawW, math.max(h, 0.5)),
            const Radius.circular(_kBarRadius),
          );
          canvas.drawRRect(rrect, fill);
        }
        barIndex++;
      }
    }

    for (int si = 0; si < series.length; si++) {
      final _PlotMark mark = si < marks.length ? marks[si] : _PlotMark.line;
      if (mark == _PlotMark.bar) continue;

      final List<Offset> pts = <Offset>[];
      for (int i = 0; i < categoryCount; i++) {
        final double v = i < series[si].data.length ? series[si].data[i] : 0;
        pts.add(Offset(_xAt(i, bandW), _yAt(v, plotH, scale.min, span)));
      }
      if (pts.isEmpty) continue;

      if (mark == _PlotMark.line && pts.length >= 2) {
        final Paint linePaint = Paint()
          ..color = seriesColors[si]
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round;
        final Path path = Path()..moveTo(pts.first.dx, pts.first.dy);
        for (int i = 1; i < pts.length; i++) {
          path.lineTo(pts[i].dx, pts[i].dy);
        }
        canvas.drawPath(path, linePaint);
      }

      final Paint fill = Paint()
        ..color = seriesColors[si]
        ..style = PaintingStyle.fill;
      final Paint ring = Paint()
        ..color = surface
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;
      for (final Offset p in pts) {
        canvas.drawCircle(p, 3.5, fill);
        canvas.drawCircle(p, 3.5, ring);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _PlexCartesianPainter oldDelegate) {
    return oldDelegate.marks != marks ||
        oldDelegate.series != series ||
        oldDelegate.seriesColors != seriesColors ||
        oldDelegate.categoryCount != categoryCount ||
        oldDelegate.grid != grid ||
        oldDelegate.axis != axis ||
        oldDelegate.zero != zero ||
        oldDelegate.tick != tick ||
        oldDelegate.surface != surface;
  }
}

class _PlexPiePainter extends CustomPainter {
  _PlexPiePainter({
    required this.values,
    required this.sliceColors,
    this.holeColor,
  });

  final List<double> values;
  final List<Color> sliceColors;
  final Color? holeColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty || values.isEmpty) return;

    double total = 0;
    for (final double v in values) {
      if (v > 0) total += v;
    }
    if (total <= 0) return;

    final double side = math.min(size.width, size.height);
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = side / 2 - 4;
    final Rect rect = Rect.fromCircle(center: center, radius: radius);

    double start = -math.pi / 2;
    for (int i = 0; i < values.length; i++) {
      final double v = values[i] < 0 ? 0 : values[i];
      if (v <= 0) continue;
      final double sweep = (v / total) * math.pi * 2;
      final Color color = sliceColors[i % sliceColors.length];
      final Paint fill = Paint()
        ..color = color
        ..style = PaintingStyle.fill;
      if (sweep >= math.pi * 2 - 0.0001) {
        canvas.drawCircle(center, radius, fill);
        _punchHole(canvas, center, radius);
        return;
      }
      canvas.drawArc(rect, start, sweep, true, fill);
      start += sweep;
    }
    _punchHole(canvas, center, radius);
  }

  void _punchHole(Canvas canvas, Offset center, double radius) {
    if (holeColor == null) return;
    canvas.drawCircle(
      center,
      radius * 0.55,
      Paint()
        ..color = holeColor!
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant _PlexPiePainter oldDelegate) {
    return oldDelegate.values != values ||
        oldDelegate.sliceColors != sliceColors ||
        oldDelegate.holeColor != holeColor;
  }
}

class _PlexHeatmapPainter extends CustomPainter {
  _PlexHeatmapPainter({
    required this.series,
    required this.categoryCount,
    required this.lo,
    required this.hi,
    required this.tick,
  });

  final List<PlexChartSeries> series;
  final int categoryCount;
  final Color lo;
  final Color hi;
  final Color tick;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty || series.isEmpty || categoryCount <= 0) return;

    double rawMin = double.infinity;
    double rawMax = double.negativeInfinity;
    for (final PlexChartSeries s in series) {
      for (final double v in s.data) {
        if (v < rawMin) rawMin = v;
        if (v > rawMax) rawMax = v;
      }
    }
    if (rawMin == double.infinity) {
      rawMin = 0;
      rawMax = 0;
    }

    final double plotW = math.max(1, size.width - _kPadL - _kPadR);
    final double plotH = math.max(1, size.height - _kPadT - _kPadB);
    final double cellW = plotW / categoryCount;
    final double cellH = plotH / series.length;
    const double gap = 3;
    final double span = rawMax - rawMin == 0 ? 1 : rawMax - rawMin;

    final TextStyle rowStyle = TextStyle(
      color: tick,
      fontSize: PlexFontSize.smallest,
      fontWeight: FontWeight.w600,
    );

    for (int r = 0; r < series.length; r++) {
      final TextPainter tp = TextPainter(
        text: TextSpan(text: series[r].name, style: rowStyle),
        textDirection: ui.TextDirection.ltr,
        maxLines: 1,
        ellipsis: '…',
      )..layout(maxWidth: _kPadL - 8);
      tp.paint(
        canvas,
        Offset(
          _kPadL - 6 - tp.width,
          _kPadT + cellH * (r + 0.5) - tp.height / 2,
        ),
      );

      for (int c = 0; c < categoryCount; c++) {
        final double v = c < series[r].data.length ? series[r].data[c] : 0;
        final double t = ((v - rawMin) / span).clamp(0.0, 1.0);
        final Color fillColor = Color.lerp(lo, hi, t) ?? hi;
        final Paint fill = Paint()
          ..color = fillColor
          ..style = PaintingStyle.fill;
        final double x = _kPadL + cellW * c + gap / 2;
        final double y = _kPadT + cellH * r + gap / 2;
        final RRect rrect = RRect.fromRectAndRadius(
          Rect.fromLTWH(
            x,
            y,
            math.max(1, cellW - gap),
            math.max(1, cellH - gap),
          ),
          const Radius.circular(_kBarRadius),
        );
        canvas.drawRRect(rrect, fill);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _PlexHeatmapPainter oldDelegate) {
    return oldDelegate.series != series ||
        oldDelegate.categoryCount != categoryCount ||
        oldDelegate.lo != lo ||
        oldDelegate.hi != hi ||
        oldDelegate.tick != tick;
  }
}

double _niceNum(double range, bool round) {
  final double abs = range.abs() == 0 ? 1 : range.abs();
  final int exp = (math.log(abs) / math.ln10).floor();
  final double f = abs / math.pow(10, exp);
  final double nf;
  if (round) {
    if (f < 1.5) {
      nf = 1;
    } else if (f < 3) {
      nf = 2;
    } else if (f < 7) {
      nf = 5;
    } else {
      nf = 10;
    }
  } else if (f <= 1) {
    nf = 1;
  } else if (f <= 2) {
    nf = 2;
  } else if (f <= 5) {
    nf = 5;
  } else {
    nf = 10;
  }
  return nf * math.pow(10, exp);
}

({double min, double max, List<double> ticks}) _niceScale(
  double min,
  double max, [
  int count = 4,
]) {
  double lo = min;
  double hi = max;
  if (lo == hi) {
    lo = math.min(0, lo);
    hi = hi == 0 ? 1 : hi;
  }
  final double step = _niceNum(_niceNum(hi - lo, false) / count, true);
  lo = (lo / step).floor() * step;
  hi = (hi / step).ceil() * step;
  final List<double> ticks = <double>[];
  for (double v = lo; v <= hi + step / 2; v += step) {
    ticks.add((v * 1e6).round() / 1e6);
  }
  return (min: lo, max: hi, ticks: ticks);
}

String _fmtTick(double v) {
  if (v == v.roundToDouble()) return v.round().toString();
  return v.toStringAsFixed(1);
}
