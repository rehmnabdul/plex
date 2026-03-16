import 'package:flutter/material.dart';
import 'package:plex/plex_theme.dart';
import 'package:plex/plex_utils/plex_dimensions.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

/// Data point for bar chart: (xLabel, yValue).
typedef PlexBarDataPoint = (String x, double y);

/// A single series for [PlexBarChart].
class PlexBarSeries {
  const PlexBarSeries({
    required this.name,
    required this.data,
    this.color,
  });

  final String name;
  final List<PlexBarDataPoint> data;
  final Color? color;
}

/// Orientation for bar chart.
enum PlexBarOrientation {
  vertical,
  horizontal,
}

/// A bar chart widget built on Syncfusion charts.
class PlexBarChart extends StatelessWidget {
  const PlexBarChart({
    super.key,
    this.title,
    required this.series,
    this.orientation = PlexBarOrientation.vertical,
    this.stacked = false,
    this.height = 300,
    this.showLegend = true,
    this.onDataPointTap,
  });

  final String? title;
  final List<PlexBarSeries> series;
  final PlexBarOrientation orientation;
  final bool stacked;
  final double height;
  final bool showLegend;
  final void Function(String seriesName, String x, double y)? onDataPointTap;

  @override
  Widget build(BuildContext context) {
    final theme = PlexTheme.getActiveTheme(context);
    final colors = [
      theme.colorScheme.primary,
      theme.colorScheme.secondary,
      theme.colorScheme.tertiary,
    ];

    final chartSeries = <CartesianSeries<_BarPoint, String>>[];
    for (var i = 0; i < series.length; i++) {
      final s = series[i];
      final color = s.color ?? colors[i % colors.length];
      final dataSource = s.data.map((p) => _BarPoint(p.$1, p.$2)).toList();
      chartSeries.add(
        ColumnSeries<_BarPoint, String>(
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
            primaryXAxis: CategoryAxis(),
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

class _BarPoint {
  _BarPoint(this.x, this.y);
  final String x;
  final double y;
}
