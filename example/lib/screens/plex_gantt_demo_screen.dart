import 'package:flutter/material.dart';
import 'package:plex/plex_charts/plex_chart_gant.dart';
import 'package:plex/plex_theme.dart';
import 'package:plex/plex_utils/plex_dimensions.dart';
import 'package:plex/plex_widgets/plex_badge.dart';
import 'package:plex_app/screens/example_chrome.dart';

class PlexGanttDemoScreen extends StatelessWidget {
  const PlexGanttDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final chartStart = DateTime(2024, 6, 1, 8);
    final chartEnd = DateTime(2024, 6, 1, 20);
    final colors = PlexThemeData.of(context).colors;
    final tasks = [
      GantTask(
        id: '1',
        title: 'Design',
        start: DateTime(2024, 6, 1, 9),
        end: DateTime(2024, 6, 1, 12),
        color: colors.brandPrimary,
      ),
      GantTask(
        id: '2',
        title: 'Development',
        start: DateTime(2024, 6, 1, 12),
        end: DateTime(2024, 6, 1, 16),
        color: colors.statusInfo,
      ),
      GantTask(
        id: '3',
        title: 'Testing',
        start: DateTime(2024, 6, 1, 15),
        end: DateTime(2024, 6, 1, 18),
        color: colors.statusWarning,
      ),
      GantTask(
        id: '4',
        title: 'Deployment',
        start: DateTime(2024, 6, 1, 17),
        end: DateTime(2024, 6, 1, 19),
        color: colors.statusSuccess,
      ),
      GantTask(
        id: '5',
        title: 'Review',
        subtitle: 'QA checkpoint',
        start: DateTime(2024, 6, 1, 10),
        end: DateTime(2024, 6, 1, 14),
        color: colors.brandPrimaryHover,
        progress: 0.6,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.all(PlexDim.medium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ExampleCard(
            title: "PlexChartGant",
            subtitle: "Tasks plotted across a working day",
            actions: const PlexBadge(label: "Charts", tone: PlexBadgeTone.info),
            child: Text(
              "This page still demonstrates the Gantt widget. Chrome uses the same tokens as the rest of the example. The Review bar shows progress (0.6). Tap is wired if you add onTaskTap.",
              style: TextStyle(color: colors.textSecondary),
            ),
          ),
          const SizedBox(height: PlexDim.medium),
          Expanded(
            child: ExampleCard(
              title: "Schedule",
              flush: true,
              child: PlexChartGant(
                tasks: tasks,
                chartStart: chartStart,
                chartEnd: chartEnd,
                pixelsPerHour: 48,
                rowHeight: 44,
                barHeight: 28,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
