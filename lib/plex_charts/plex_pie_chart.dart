import 'package:flutter/material.dart';
import 'package:plex/plex_theme.dart';
import 'package:plex/plex_utils/plex_dimensions.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

/// A segment for pie/donut chart.
class PlexPieSegment {
  const PlexPieSegment(this.label, this.value, {this.color});

  final String label;
  final double value;
  final Color? color;
}

/// A pie chart widget built on Syncfusion charts.
class PlexPieChart extends StatelessWidget {
  const PlexPieChart({
    super.key,
    this.title,
    required this.data,
    this.height = 300,
    this.showLegend = true,
    this.explodeIndex,
    this.onSegmentTap,
  });

  final String? title;
  final List<PlexPieSegment> data;
  final double height;
  final bool showLegend;
  final int? explodeIndex;
  final void Function(String label, double value)? onSegmentTap;

  @override
  Widget build(BuildContext context) {
    final theme = PlexTheme.getActiveTheme(context);
    final colors = [
      theme.colorScheme.primary,
      theme.colorScheme.secondary,
      theme.colorScheme.tertiary,
      theme.colorScheme.primary.withValues(alpha: 0.7),
      theme.colorScheme.secondary.withValues(alpha: 0.7),
    ];

    final dataSource = data
        .asMap()
        .entries
        .map((e) => _PiePoint(e.value.label, e.value.value,
            color: e.value.color ?? colors[e.key % colors.length]))
        .toList();

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
          child: SfCircularChart(
            legend: Legend(isVisible: showLegend),
            tooltipBehavior: TooltipBehavior(enable: true),
            series: <CircularSeries>[
              PieSeries<_PiePoint, String>(
                dataSource: dataSource,
                xValueMapper: (p, _) => p.label,
                yValueMapper: (p, _) => p.value,
                pointColorMapper: (p, _) => p.color,
                dataLabelSettings: const DataLabelSettings(isVisible: true),
                explodeIndex: explodeIndex,
                explodeOffset: '10%',
                onPointTap: onSegmentTap != null
                    ? (ChartPointDetails details) {
                        final idx = details.pointIndex ?? 0;
                        if (idx < data.length) {
                          final p = data[idx];
                          onSegmentTap!(p.label, p.value);
                        }
                      }
                    : null,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// A donut chart widget built on Syncfusion charts.
class PlexDonutChart extends StatelessWidget {
  const PlexDonutChart({
    super.key,
    this.title,
    required this.data,
    this.height = 300,
    this.showLegend = true,
    this.explodeIndex,
    this.onSegmentTap,
  });

  final String? title;
  final List<PlexPieSegment> data;
  final double height;
  final bool showLegend;
  final int? explodeIndex;
  final void Function(String label, double value)? onSegmentTap;

  @override
  Widget build(BuildContext context) {
    final theme = PlexTheme.getActiveTheme(context);
    final colors = [
      theme.colorScheme.primary,
      theme.colorScheme.secondary,
      theme.colorScheme.tertiary,
      theme.colorScheme.primary.withValues(alpha: 0.7),
      theme.colorScheme.secondary.withValues(alpha: 0.7),
    ];

    final dataSource = data
        .asMap()
        .entries
        .map((e) => _PiePoint(e.value.label, e.value.value,
            color: e.value.color ?? colors[e.key % colors.length]))
        .toList();

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
          child: SfCircularChart(
            legend: Legend(isVisible: showLegend),
            tooltipBehavior: TooltipBehavior(enable: true),
            series: <CircularSeries>[
              DoughnutSeries<_PiePoint, String>(
                dataSource: dataSource,
                xValueMapper: (p, _) => p.label,
                yValueMapper: (p, _) => p.value,
                pointColorMapper: (p, _) => p.color,
                dataLabelSettings: const DataLabelSettings(isVisible: true),
                explodeIndex: explodeIndex,
                explodeOffset: '10%',
                onPointTap: onSegmentTap != null
                    ? (ChartPointDetails details) {
                        final idx = details.pointIndex ?? 0;
                        if (idx < data.length) {
                          final p = data[idx];
                          onSegmentTap!(p.label, p.value);
                        }
                      }
                    : null,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PiePoint {
  _PiePoint(this.label, this.value, {required this.color});
  final String label;
  final double value;
  final Color color;
}
