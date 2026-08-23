import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:plex/plex_theme.dart';

const double _kLabelWidth = 176;
const double _kHeaderHeight = 44;

/// Model representing a single task in the Gantt chart.
class GantTask {
  final String id;
  final String title;
  final DateTime start;
  final DateTime end;
  final Color color;
  final double? progress;
  final String? subtitle;
  final List<String>? dependsOn;

  GantTask({
    required this.id,
    required this.title,
    required this.start,
    required this.end,
    required this.color,
    this.progress,
    this.subtitle,
    this.dependsOn,
  }) : assert(start.isBefore(end), 'Start time must be before end time');
}

/// A reusable, time-based Gantt chart widget for Plex.
///
/// Example usage:
/// ```dart
/// PlexChartGant(
///   tasks: [
///     GantTask(
///       id: '1',
///       title: 'Design',
///       start: DateTime(2024, 6, 1, 9),
///       end: DateTime(2024, 6, 1, 12),
///       color: Colors.blue,
///     ),
///     GantTask(
///       id: '2',
///       title: 'Development',
///       start: DateTime(2024, 6, 1, 13),
///       end: DateTime(2024, 6, 1, 17),
///       color: Colors.green,
///       dependsOn: ['1'],
///     ),
///   ],
///   chartStart: DateTime(2024, 6, 1, 8),
///   chartEnd: DateTime(2024, 6, 1, 18),
/// )
/// ```
class PlexChartGant extends StatelessWidget {
  final List<GantTask> tasks;
  final DateTime chartStart;
  final DateTime chartEnd;
  final double pixelsPerHour;
  final double rowHeight;
  final double barHeight;
  final TextStyle? timeLabelStyle;
  final TextStyle? taskLabelStyle;
  final ValueChanged<GantTask>? onTaskTap;
  final bool showNowLine;
  final bool enablePanZoom;

  const PlexChartGant({
    Key? key,
    required this.tasks,
    required this.chartStart,
    required this.chartEnd,
    this.pixelsPerHour = 60,
    this.rowHeight = 48,
    this.barHeight = 32,
    this.timeLabelStyle,
    this.taskLabelStyle,
    this.onTaskTap,
    this.showNowLine = true,
    this.enablePanZoom = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = PlexThemeData.of(context).colors;
    return LayoutBuilder(
      builder: (context, constraints) {
        final geometry = _GanttGeometry(
          tasks: tasks,
          chartStart: chartStart,
          chartEnd: chartEnd,
          pixelsPerHour: pixelsPerHour,
          rowHeight: rowHeight,
          barHeight: barHeight,
        );
        final height = constraints.maxHeight.isFinite
            ? constraints.maxHeight
            : _kHeaderHeight + geometry.bodyHeight;
        final width = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : _kLabelWidth + geometry.canvasWidth;
        return SizedBox(
          width: width,
          height: height,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: colors.surfaceCard,
              border: Border.all(color: colors.borderDefault),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: _PlexGanttBoard(
                geometry: geometry,
                colors: colors,
                timeLabelStyle: timeLabelStyle,
                taskLabelStyle: taskLabelStyle,
                onTaskTap: onTaskTap,
                showNowLine: showNowLine,
                enablePanZoom: enablePanZoom,
              ),
            ),
          ),
        );
      },
    );
  }
}

typedef PlexGanttChart = PlexChartGant;

class _GanttGeometry {
  _GanttGeometry({
    required this.tasks,
    required this.chartStart,
    required this.chartEnd,
    required this.pixelsPerHour,
    required this.rowHeight,
    required this.barHeight,
  });

  final List<GantTask> tasks;
  final DateTime chartStart;
  final DateTime chartEnd;
  final double pixelsPerHour;
  final double rowHeight;
  final double barHeight;

  static const _monthShort = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  double get spanHours {
    final hours = chartEnd.difference(chartStart).inMinutes / 60.0;
    return math.max(hours, 0.01);
  }

  double get canvasWidth => spanHours * pixelsPerHour;

  double get bodyHeight => math.max(tasks.length, 1) * rowHeight;

  bool get useDayTicks => chartEnd.difference(chartStart).inHours > 48;

  double xFor(DateTime time) {
    return time.difference(chartStart).inMinutes / 60.0 * pixelsPerHour;
  }

  double barLeft(GantTask task) => xFor(task.start).clamp(0.0, canvasWidth);

  double barWidth(GantTask task) {
    final left = barLeft(task);
    final right = xFor(task.end).clamp(0.0, canvasWidth);
    return math.max(2.0, right - left);
  }

  double barTop() => (rowHeight - barHeight) / 2;

  double laneCenter(int index) => index * rowHeight + rowHeight / 2;

  bool nowInRange(DateTime now) {
    return !now.isBefore(chartStart) && !now.isAfter(chartEnd);
  }

  List<DateTime> ticks() {
    final out = <DateTime>[];
    if (useDayTicks) {
      var cursor = DateTime(chartStart.year, chartStart.month, chartStart.day);
      if (cursor.isBefore(chartStart)) {
        cursor = cursor.add(const Duration(days: 1));
      }
      while (cursor.isBefore(chartEnd)) {
        out.add(cursor);
        cursor = cursor.add(const Duration(days: 1));
      }
    } else {
      var cursor = DateTime(
        chartStart.year,
        chartStart.month,
        chartStart.day,
        chartStart.hour,
      );
      if (cursor.isBefore(chartStart)) {
        cursor = cursor.add(const Duration(hours: 1));
      }
      while (cursor.isBefore(chartEnd)) {
        out.add(cursor);
        cursor = cursor.add(const Duration(hours: 1));
      }
    }
    return out;
  }

  String tickLabel(DateTime time) {
    if (useDayTicks) {
      return '${_monthShort[time.month - 1]} ${time.day}';
    }
    return '${time.hour.toString().padLeft(2, '0')}:00';
  }

  List<_GanttDepLink> dependencyLinks() {
    final byId = <String, int>{};
    for (var i = 0; i < tasks.length; i++) {
      byId[tasks[i].id] = i;
    }
    final links = <_GanttDepLink>[];
    for (var i = 0; i < tasks.length; i++) {
      final task = tasks[i];
      final preds = task.dependsOn;
      if (preds == null) continue;
      for (final predId in preds) {
        final predIndex = byId[predId];
        if (predIndex == null || predIndex == i) continue;
        final pred = tasks[predIndex];
        final fromX = xFor(pred.end).clamp(0.0, canvasWidth);
        final toX = xFor(task.start).clamp(0.0, canvasWidth);
        links.add(
          _GanttDepLink(
            fromX: fromX,
            fromY: laneCenter(predIndex),
            toX: toX,
            toY: laneCenter(i),
          ),
        );
      }
    }
    return links;
  }
}

class _GanttDepLink {
  const _GanttDepLink({
    required this.fromX,
    required this.fromY,
    required this.toX,
    required this.toY,
  });

  final double fromX;
  final double fromY;
  final double toX;
  final double toY;
}

class _PlexGanttBoard extends StatefulWidget {
  const _PlexGanttBoard({
    required this.geometry,
    required this.colors,
    required this.timeLabelStyle,
    required this.taskLabelStyle,
    required this.onTaskTap,
    required this.showNowLine,
    required this.enablePanZoom,
  });

  final _GanttGeometry geometry;
  final PlexColorTokens colors;
  final TextStyle? timeLabelStyle;
  final TextStyle? taskLabelStyle;
  final ValueChanged<GantTask>? onTaskTap;
  final bool showNowLine;
  final bool enablePanZoom;

  @override
  State<_PlexGanttBoard> createState() => _PlexGanttBoardState();
}

class _PlexGanttBoardState extends State<_PlexGanttBoard> {
  final TransformationController _transform = TransformationController();

  @override
  void didUpdateWidget(covariant _PlexGanttBoard oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldGeo = oldWidget.geometry;
    final geo = widget.geometry;
    if (oldGeo.chartStart != geo.chartStart ||
        oldGeo.chartEnd != geo.chartEnd ||
        oldGeo.pixelsPerHour != geo.pixelsPerHour) {
      _transform.value = Matrix4.identity();
    }
  }

  @override
  void dispose() {
    _transform.dispose();
    super.dispose();
  }

  double get _scale => _transform.value.getMaxScaleOnAxis();

  double get _tx => _transform.value.storage[12];

  double get _ty => _transform.value.storage[13];

  Matrix4 get _headerMatrix {
    final m = Matrix4.identity();
    m.setEntry(0, 0, _scale);
    m[12] = _tx;
    return m;
  }

  Matrix4 get _labelMatrix {
    final m = Matrix4.identity();
    m.setEntry(1, 1, _scale);
    m[13] = _ty;
    return m;
  }

  @override
  Widget build(BuildContext context) {
    final geo = widget.geometry;
    final colors = widget.colors;
    final now = DateTime.now();
    final showNow = widget.showNowLine && geo.nowInRange(now);
    final nowX = showNow ? geo.xFor(now) : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: _kHeaderHeight,
          child: Row(
            children: [
              _GanttCorner(colors: colors),
              Expanded(
                child: ClipRect(
                  child: AnimatedBuilder(
                    animation: _transform,
                    builder: (context, child) {
                      return Transform(
                        alignment: Alignment.topLeft,
                        transform: _headerMatrix,
                        child: child,
                      );
                    },
                    child: _GanttTimeHeader(
                      geometry: geo,
                      colors: colors,
                      labelStyle: widget.timeLabelStyle,
                      nowX: nowX,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: _kLabelWidth,
                child: ClipRect(
                  child: AnimatedBuilder(
                    animation: _transform,
                    builder: (context, child) {
                      return Transform(
                        alignment: Alignment.topLeft,
                        transform: _labelMatrix,
                        child: child,
                      );
                    },
                    child: _GanttLabelColumn(
                      geometry: geo,
                      colors: colors,
                      labelStyle: widget.taskLabelStyle,
                      onTaskTap: widget.onTaskTap,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ClipRect(
                  child: InteractiveViewer(
                    transformationController: _transform,
                    constrained: false,
                    alignment: Alignment.topLeft,
                    minScale: widget.enablePanZoom ? 0.5 : 1.0,
                    maxScale: widget.enablePanZoom ? 2.5 : 1.0,
                    scaleEnabled: widget.enablePanZoom,
                    panEnabled: true,
                    boundaryMargin: const EdgeInsets.fromLTRB(0, 0, 72, 72),
                    clipBehavior: Clip.hardEdge,
                    child: _GanttTimeCanvas(
                      geometry: geo,
                      colors: colors,
                      onTaskTap: widget.onTaskTap,
                      nowX: nowX,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _GanttCorner extends StatelessWidget {
  const _GanttCorner({required this.colors});

  final PlexColorTokens colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _kLabelWidth,
      decoration: BoxDecoration(
        color: colors.surfaceSunken,
        border: Border(
          right: BorderSide(color: colors.borderDefault),
          bottom: BorderSide(color: colors.borderStrong),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      alignment: Alignment.centerLeft,
      child: Text(
        'TASK',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
          color: colors.textMuted,
        ),
      ),
    );
  }
}

class _GanttTimeHeader extends StatelessWidget {
  const _GanttTimeHeader({
    required this.geometry,
    required this.colors,
    required this.labelStyle,
    required this.nowX,
  });

  final _GanttGeometry geometry;
  final PlexColorTokens colors;
  final TextStyle? labelStyle;
  final double? nowX;

  @override
  Widget build(BuildContext context) {
    final ticks = geometry.ticks();
    final style = labelStyle ??
        TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: colors.textMuted,
        );
    return SizedBox(
      width: geometry.canvasWidth,
      height: _kHeaderHeight,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surfaceSunken,
          border: Border(
            bottom: BorderSide(color: colors.borderStrong),
          ),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            for (final tick in ticks)
              Positioned(
                left: geometry.xFor(tick),
                top: 0,
                bottom: 0,
                width: geometry.useDayTicks
                    ? geometry.pixelsPerHour * 24
                    : geometry.pixelsPerHour,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(color: colors.borderSubtle),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        geometry.tickLabel(tick),
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                        style: style,
                      ),
                    ),
                  ),
                ),
              ),
            if (nowX != null)
              Positioned(
                left: nowX! - 1,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 2,
                  color: colors.statusDanger,
                ),
              ),
            if (nowX != null)
              Positioned(
                left: nowX! + 4,
                top: 4,
                child: Text(
                  'NOW',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.7,
                    color: colors.statusDanger,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _GanttLabelColumn extends StatelessWidget {
  const _GanttLabelColumn({
    required this.geometry,
    required this.colors,
    required this.labelStyle,
    required this.onTaskTap,
  });

  final _GanttGeometry geometry;
  final PlexColorTokens colors;
  final TextStyle? labelStyle;
  final ValueChanged<GantTask>? onTaskTap;

  @override
  Widget build(BuildContext context) {
    final tasks = geometry.tasks;
    return SizedBox(
      width: _kLabelWidth,
      height: geometry.bodyHeight,
      child: Column(
        children: [
          for (var i = 0; i < math.max(tasks.length, 1); i++)
            _GanttTaskLabel(
              task: i < tasks.length ? tasks[i] : null,
              height: geometry.rowHeight,
              colors: colors,
              labelStyle: labelStyle,
              striped: i.isOdd,
              onTaskTap: onTaskTap,
            ),
        ],
      ),
    );
  }
}

class _GanttTaskLabel extends StatelessWidget {
  const _GanttTaskLabel({
    required this.task,
    required this.height,
    required this.colors,
    required this.labelStyle,
    required this.striped,
    required this.onTaskTap,
  });

  final GantTask? task;
  final double height;
  final PlexColorTokens colors;
  final TextStyle? labelStyle;
  final bool striped;
  final ValueChanged<GantTask>? onTaskTap;

  @override
  Widget build(BuildContext context) {
    final task = this.task;
    Widget child = Container(
      height: height,
      width: _kLabelWidth,
      decoration: BoxDecoration(
        color: striped ? colors.surfaceHover : colors.surfaceCard,
        border: Border(
          right: BorderSide(color: colors.borderDefault),
          bottom: BorderSide(color: colors.borderSubtle),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      alignment: Alignment.centerLeft,
      child: task == null
          ? null
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: labelStyle ??
                      TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: colors.textPrimary,
                      ),
                ),
                if (task.subtitle != null)
                  Text(
                    task.subtitle!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      color: colors.textMuted,
                    ),
                  ),
              ],
            ),
    );
    if (task != null && onTaskTap != null) {
      child = GestureDetector(
        onTap: () => onTaskTap!(task),
        child: child,
      );
    }
    return child;
  }
}

class _GanttTimeCanvas extends StatelessWidget {
  const _GanttTimeCanvas({
    required this.geometry,
    required this.colors,
    required this.onTaskTap,
    required this.nowX,
  });

  final _GanttGeometry geometry;
  final PlexColorTokens colors;
  final ValueChanged<GantTask>? onTaskTap;
  final double? nowX;

  @override
  Widget build(BuildContext context) {
    final geo = geometry;
    final tasks = geo.tasks;
    return SizedBox(
      width: geo.canvasWidth,
      height: geo.bodyHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: _GanttGridPainter(
                tickXs: geo.ticks().map(geo.xFor).toList(growable: false),
                rowCount: math.max(tasks.length, 1),
                rowHeight: geo.rowHeight,
                canvasWidth: geo.canvasWidth,
                laneEven: colors.surfaceCard,
                laneOdd: colors.surfaceHover,
                gridColor: colors.borderSubtle,
                laneBorder: colors.borderSubtle,
              ),
            ),
          ),
          for (var i = 0; i < tasks.length; i++)
            Positioned(
              left: geo.barLeft(tasks[i]),
              top: i * geo.rowHeight + geo.barTop(),
              child: _GanttTaskBar(
                task: tasks[i],
                width: geo.barWidth(tasks[i]),
                height: geo.barHeight,
                onTaskTap: onTaskTap,
              ),
            ),
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: _GanttDepPainter(
                  links: geo.dependencyLinks(),
                  color: colors.textMuted,
                ),
              ),
            ),
          ),
          if (nowX != null)
            Positioned(
              key: const Key('plex-gantt-now'),
              left: nowX! - 1,
              top: 0,
              bottom: 0,
              width: 2,
              child: IgnorePointer(
                child: ColoredBox(color: colors.statusDanger),
              ),
            ),
        ],
      ),
    );
  }
}

class _GanttTaskBar extends StatelessWidget {
  const _GanttTaskBar({
    required this.task,
    required this.width,
    required this.height,
    required this.onTaskTap,
  });

  final GantTask task;
  final double width;
  final double height;
  final ValueChanged<GantTask>? onTaskTap;

  @override
  Widget build(BuildContext context) {
    final progress = task.progress;
    final progressWidth =
        progress == null ? 0.0 : width * progress.clamp(0.0, 1.0);

    Widget bar = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: task.color,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: task.color.withValues(alpha: 0.22),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          if (progress != null)
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              width: progressWidth,
              child: ColoredBox(
                color: Color.alphaBlend(
                  Colors.black.withValues(alpha: 0.28),
                  task.color,
                ),
              ),
            ),
          if (progress != null && width >= 36)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${(progress.clamp(0.0, 1.0) * 100).round()}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
        ],
      ),
    );

    if (onTaskTap != null) {
      bar = GestureDetector(
        onTap: () => onTaskTap!(task),
        child: bar,
      );
    }
    return bar;
  }
}

class _GanttGridPainter extends CustomPainter {
  _GanttGridPainter({
    required this.tickXs,
    required this.rowCount,
    required this.rowHeight,
    required this.canvasWidth,
    required this.laneEven,
    required this.laneOdd,
    required this.gridColor,
    required this.laneBorder,
  });

  final List<double> tickXs;
  final int rowCount;
  final double rowHeight;
  final double canvasWidth;
  final Color laneEven;
  final Color laneOdd;
  final Color gridColor;
  final Color laneBorder;

  @override
  void paint(Canvas canvas, Size size) {
    final evenPaint = Paint()..color = laneEven;
    final oddPaint = Paint()..color = laneOdd;
    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 1;
    final lanePaint = Paint()
      ..color = laneBorder
      ..strokeWidth = 1;

    for (var i = 0; i < rowCount; i++) {
      final top = i * rowHeight;
      canvas.drawRect(
        Rect.fromLTWH(0, top, canvasWidth, rowHeight),
        i.isOdd ? oddPaint : evenPaint,
      );
      canvas.drawLine(
        Offset(0, top + rowHeight),
        Offset(canvasWidth, top + rowHeight),
        lanePaint,
      );
    }

    for (final x in tickXs) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _GanttGridPainter oldDelegate) {
    return oldDelegate.tickXs != tickXs ||
        oldDelegate.rowCount != rowCount ||
        oldDelegate.rowHeight != rowHeight ||
        oldDelegate.canvasWidth != canvasWidth ||
        oldDelegate.laneEven != laneEven ||
        oldDelegate.laneOdd != laneOdd ||
        oldDelegate.gridColor != gridColor ||
        oldDelegate.laneBorder != laneBorder;
  }
}

class _GanttDepPainter extends CustomPainter {
  _GanttDepPainter({
    required this.links,
    required this.color,
  });

  final List<_GanttDepLink> links;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (links.isEmpty) return;
    final stroke = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round;
    final fill = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    for (final link in links) {
      final midX = math.max(link.fromX + 10, link.toX - 12);
      final path = Path()
        ..moveTo(link.fromX, link.fromY)
        ..lineTo(midX, link.fromY)
        ..lineTo(midX, link.toY)
        ..lineTo(link.toX, link.toY);
      canvas.drawPath(path, stroke);

      const arrow = 5.0;
      final pointingRight = link.toX >= midX;
      final tip = Offset(link.toX, link.toY);
      final arrowPath = Path();
      if (pointingRight) {
        arrowPath
          ..moveTo(tip.dx, tip.dy)
          ..lineTo(tip.dx - arrow, tip.dy - arrow * 0.6)
          ..lineTo(tip.dx - arrow, tip.dy + arrow * 0.6)
          ..close();
      } else {
        arrowPath
          ..moveTo(tip.dx, tip.dy)
          ..lineTo(tip.dx + arrow, tip.dy - arrow * 0.6)
          ..lineTo(tip.dx + arrow, tip.dy + arrow * 0.6)
          ..close();
      }
      canvas.drawPath(arrowPath, fill);
    }
  }

  @override
  bool shouldRepaint(covariant _GanttDepPainter oldDelegate) {
    return oldDelegate.links != links || oldDelegate.color != color;
  }
}
