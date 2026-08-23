import 'package:flutter/material.dart';
import 'package:plex/plex_theme.dart';
import 'package:plex/plex_utils/plex_dimensions.dart';
import 'package:plex/plex_widgets/plex_badge.dart';
import 'package:plex/plex_widgets/plex_chart.dart';
import 'package:plex_app/screens/example_chrome.dart';

class UiKitChartScreen extends StatelessWidget {
  const UiKitChartScreen({super.key});

  static const _labels = ["Mon", "Tue", "Wed", "Thu", "Fri"];
  static const _units =
      PlexChartSeries(name: "Units", data: [12, 18, 9, 22, 15]);
  static const _returns =
      PlexChartSeries(name: "Returns", data: [2, 1, 4, 3, 2]);

  @override
  Widget build(BuildContext context) {
    final colors = PlexThemeData.of(context).colors;

    return ExampleScrollPage(
      children: [
        ExampleCard(
          title: "PlexChart",
          subtitle:
              "Bar, line, pie, donut, scatter, combo, and heatmap. CustomPaint — not a Gantt replacement.",
          actions: const PlexBadge(label: "Phase 7", tone: PlexBadgeTone.info),
          child: Text(
            "Gantt stays under Charts at /gantt-demo. Tokens come from PlexThemeData.",
            style: TextStyle(color: colors.textSecondary),
          ),
        ),
        const SizedBox(height: PlexDim.large),
        const ExampleSectionTitle("Bar"),
        const ExampleCard(
          title: "Weekly throughput",
          child: PlexChart(
            type: PlexChartType.bar,
            series: [_units],
            labels: _labels,
            height: 240,
          ),
        ),
        const SizedBox(height: PlexDim.large),
        const ExampleSectionTitle("Line"),
        const ExampleCard(
          title: "Units vs returns",
          child: PlexChart(
            type: PlexChartType.line,
            series: [_units, _returns],
            labels: _labels,
            height: 240,
          ),
        ),
        const SizedBox(height: PlexDim.large),
        const ExampleSectionTitle("Pie"),
        const ExampleCard(
          title: "Mix by line",
          child: PlexChart(
            type: PlexChartType.pie,
            series: [
              PlexChartSeries(name: "Cut", data: [40]),
              PlexChartSeries(name: "Sew", data: [35]),
              PlexChartSeries(name: "Pack", data: [25]),
            ],
            height: 240,
          ),
        ),
        const SizedBox(height: PlexDim.large),
        const ExampleSectionTitle("Donut"),
        const ExampleCard(
          title: "Mix by line",
          child: PlexChart(
            type: PlexChartType.donut,
            series: [
              PlexChartSeries(name: "Cut", data: [40]),
              PlexChartSeries(name: "Sew", data: [35]),
              PlexChartSeries(name: "Pack", data: [25]),
            ],
            height: 240,
          ),
        ),
        const SizedBox(height: PlexDim.large),
        const ExampleSectionTitle("Scatter"),
        const ExampleCard(
          title: "Units vs returns",
          child: PlexChart(
            type: PlexChartType.scatter,
            series: [_units, _returns],
            labels: _labels,
            height: 240,
          ),
        ),
        const SizedBox(height: PlexDim.large),
        const ExampleSectionTitle("Combo"),
        const ExampleCard(
          title: "Units vs returns",
          child: PlexChart(
            type: PlexChartType.combo,
            series: [
              PlexChartSeries(
                name: "Units",
                data: [12, 18, 9, 22, 15],
                mark: PlexChartType.bar,
              ),
              PlexChartSeries(
                name: "Returns",
                data: [2, 1, 4, 3, 2],
                mark: PlexChartType.line,
              ),
            ],
            labels: _labels,
            height: 240,
          ),
        ),
        const SizedBox(height: PlexDim.large),
        const ExampleSectionTitle("Heatmap"),
        const ExampleCard(
          title: "Shift load",
          child: PlexChart(
            type: PlexChartType.heatmap,
            series: [
              PlexChartSeries(name: "Cut", data: [2, 5, 8, 3, 6]),
              PlexChartSeries(name: "Sew", data: [4, 7, 3, 9, 5]),
              PlexChartSeries(name: "Pack", data: [1, 3, 6, 4, 8]),
            ],
            labels: _labels,
            height: 180,
          ),
        ),
        const SizedBox(height: PlexDim.large),
        const ExampleSectionTitle("Trellis"),
        const ExampleCard(
          title: "Units by series",
          child: PlexChart(
            type: PlexChartType.trellis,
            series: [_units, _returns],
            labels: _labels,
            height: 200,
          ),
        ),
      ],
    );
  }
}
