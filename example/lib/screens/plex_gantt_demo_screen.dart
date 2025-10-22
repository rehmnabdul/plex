import 'package:flutter/material.dart';
import 'package:plex/plex_charts/plex_chart_gant.dart';

class PlexGanttDemoScreen extends StatelessWidget {
  const PlexGanttDemoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final chartStart = DateTime(2024, 6, 1, 8);
    final chartEnd = DateTime(2024, 6, 1, 20);
    final tasks = [
      GantTask(
        id: '1',
        title: 'Design',
        start: DateTime(2024, 6, 1, 9),
        end: DateTime(2024, 6, 1, 12),
        color: Colors.blue,
      ),
      GantTask(
        id: '2',
        title: 'Development',
        start: DateTime(2024, 6, 1, 12),
        end: DateTime(2024, 6, 1, 16),
        color: Colors.green,
      ),
      GantTask(
        id: '3',
        title: 'Testing',
        start: DateTime(2024, 6, 1, 15),
        end: DateTime(2024, 6, 1, 18),
        color: Colors.orange,
      ),
      GantTask(
        id: '4',
        title: 'Deployment',
        start: DateTime(2024, 6, 1, 17),
        end: DateTime(2024, 6, 1, 19),
        color: Colors.purple,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Plex Gantt Chart Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Gantt Chart Demo',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'This page demonstrates the PlexChartGant widget, which displays tasks over time in a Gantt chart format.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
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
            ),
          ],
        ),
      ),
    );
  }
} 