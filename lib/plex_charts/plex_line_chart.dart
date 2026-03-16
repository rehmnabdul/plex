import 'package:flutter/material.dart';
import 'package:plex/plex_theme.dart';
import 'package:plex/plex_utils/plex_dimensions.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

/// Data point for line chart: (DateTime x, double y).
typedef PlexLineDataPoint = (DateTime x, double y);

/// A single series for [PlexLineChart].
class PlexLineSeries {
  const PlexLineSeries({
    required this.name,
    required this.data,
    this.color,
  });

  final String name;
  final List<PlexLineDataPoint> data;
  final Color? color;
}

/// A line chart widget built on Syncfusion charts.
class PlexLineChart extends StatelessWidget {
  const PlexLineChart({
    super.key,
    this.title,
    required this.series,
    this.showArea = false,
    this.height = 300,
    this.showLegend = true,
    this.onDataPointTap,
  });

  final String? title;
  final List<PlexLineSeries> series;
  final bool showArea;
  final double height;
  final bool showLegend;
  final void Function(String seriesName, DateTime x, double y)? onDataPointTap;

  @override
  Widget build(BuildContext context) {
    final theme = PlexTheme.getActiveTheme(context);
    final colors = [
      theme.colorScheme.primary,
      theme.colorScheme.secondary,
      theme.colorScheme.tertiary,
    ];

    final chartSeries = <CartesianSeries<dynamic, dynamic>>[];
    for (var i = 0; i < series.length; i++) {
      final s = series[i];
      final color = s.color ?? colors[i % colors.length];
      final dataSource = s.data.map((p) => _LinePoint(p.$1, p.$2)).toList();
      if (showArea) {
        chartSeries.add(
          SplineAreaSeries<_LinePoint, DateTime>(
            dataSource: dataSource,
            xValueMapper: (p, _) => p.x,
            yValueMapper: (p, _) => p.y,
            name: s.name,
            color: color,
            dataLabelSettings: const DataLabelSettings(isVisible: false),
            onPointTap: onDataPointTap != null
                ? (ChartPointDetails details) {
                    final idx = details.pointIndex ?? 0;
                    if (idx < s.data.length) {
                      final p = s.data[idx];
                      onDataPointTap!(s.name, p.$1, p.$2);
                    }
                  }
                : null,
          ),
        );
      } else {
        chartSeries.add(
          SplineSeries<_LinePoint, DateTime>(
            dataSource: dataSource,
            xValueMapper: (p, _) => p.x,
            yValueMapper: (p, _) => p.y,
            name: s.name,
            color: color,
            dataLabelSettings: const DataLabelSettings(isVisible: false),
            onPointTap: onDataPointTap != null
                ? (ChartPointDetails details) {
                    final idx = details.pointIndex ?? 0;
                    if (idx < s.data.length) {
                      final p = s.data[idx];
                      onDataPointTap!(s.name, p.$1, p.$2);
                    }
                  }
                : null,
          ),
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (title != null) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: PlexDim.small),
            child: Text(title!, style: theme.textTheme.titleMedium),
          ),
        ],
        SizedBox(
          height: height,
          child: SfCartesianChart(
            primaryXAxis: DateTimeAxis(),
            primaryYAxis: NumericAxis(),
            legend: Legend(isVisible: showLegend),
            tooltipBehavior: TooltipBehavior(enable: true),
            series: chartSeries,
          ),
        ),
      ],
    );
  }
}

class _LinePoint {
  _LinePoint(this.x, this.y);
  final DateTime x;
  final double y;
}
