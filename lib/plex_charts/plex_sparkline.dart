import 'package:flutter/material.dart';
import 'package:plex/plex_theme.dart';

/// A compact inline sparkline chart for dashboard KPI cards.
class PlexSparkline extends StatelessWidget {
  const PlexSparkline({
    super.key,
    required this.data,
    this.width = 80,
    this.height = 32,
    this.color,
    this.showArea = false,
  });

  final List<double> data;
  final double width;
  final double height;
  final Color? color;
  final bool showArea;

  @override
  Widget build(BuildContext context) {
    final theme = PlexTheme.getActiveTheme(context);
    final lineColor = color ?? theme.colorScheme.primary;

    if (data.isEmpty) {
      return SizedBox(width: width, height: height);
    }

    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: _SparklinePainter(
          data: data,
          color: lineColor,
          showArea: showArea,
        ),
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  _SparklinePainter({
    required this.data,
    required this.color,
    this.showArea = false,
  });

  final List<double> data;
  final Color color;
  final bool showArea;

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final minY = data.reduce((a, b) => a < b ? a : b);
    final maxY = data.reduce((a, b) => a > b ? a : b);
    final range = maxY - minY;
    final yRange = range > 0 ? range : 1.0;
    final padding = 2.0;
    final w = size.width - 2 * padding;
    final h = size.height - 2 * padding;

    final points = <Offset>[];
    for (var i = 0; i < data.length; i++) {
      final x = padding + (data.length > 1 ? (i / (data.length - 1)) * w : 0);
      final y = padding + h - ((data[i] - minY) / yRange) * h;
      points.add(Offset(x, y));
    }

    if (points.isEmpty) return;

    if (showArea && points.length > 1) {
      final path = Path()..moveTo(points[0].dx, size.height - padding);
      for (final p in points) {
        path.lineTo(p.dx, p.dy);
      }
      path.lineTo(points.last.dx, size.height - padding);
      path.close();
      canvas.drawPath(
        path,
        Paint()
          ..color = color.withValues(alpha: 0.2)
          ..style = PaintingStyle.fill,
      );
    }

    if (points.length > 1) {
      final linePath = Path()..moveTo(points[0].dx, points[0].dy);
      for (var i = 1; i < points.length; i++) {
        linePath.lineTo(points[i].dx, points[i].dy);
      }
      canvas.drawPath(
        linePath,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      );
    } else if (points.length == 1) {
      canvas.drawCircle(points[0], 2, Paint()..color = color);
    }
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter oldDelegate) {
    return oldDelegate.data != data ||
        oldDelegate.color != color ||
        oldDelegate.showArea != showArea;
  }
}
