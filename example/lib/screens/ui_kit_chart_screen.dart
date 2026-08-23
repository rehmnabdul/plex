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
              "Bar, line, and pie. CustomPaint — not a Gantt replacement.",
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
      ],
    );
  }
}
