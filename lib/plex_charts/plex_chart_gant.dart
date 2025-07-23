import 'package:flutter/material.dart';

/// Represents a task in the Gantt chart.
class GantTask {
  final String id;
  final String title;
  final DateTime start;
  final DateTime end;
  final Color color;

  GantTask({
    required this.id,
    required this.title,
    required this.start,
    required this.end,
    required this.color,
  }) : assert(start.isBefore(end), 'Start time must be before end time');
}

/// Displays a time-based Gantt chart for a list of tasks.
class PlexChartGant extends StatelessWidget {
  final List<GantTask> tasks;
  final DateTime chartStart;
  final DateTime chartEnd;
  final double pixelsPerHour;

  const PlexChartGant({
    super.key,
    required this.tasks,
    required this.chartStart,
    required this.chartEnd,
    this.pixelsPerHour = 50,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _GantChartGrid(
            start: chartStart,
            end: chartEnd,
            pixelsPerHour: pixelsPerHour,
          ),
          const SizedBox(height: 8),
          Column(
            children: tasks.map((task) {
              return SizedBox(
                height: 40,
                child: Stack(
                  children: [
                    _GantChartBar(
                      task: task,
                      chartStart: chartStart,
                      pixelsPerHour: pixelsPerHour,
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

/// Renders the horizontal time grid of the Gantt chart.
class _GantChartGrid extends StatelessWidget {
  final DateTime start;
  final DateTime end;
  final double pixelsPerHour;

  const _GantChartGrid({
    required this.start,
    required this.end,
    required this.pixelsPerHour,
  });

  @override
  Widget build(BuildContext context) {
    final hours = end.difference(start).inHours;
    return Row(
      children: List.generate(hours, (index) {
        final hourTime = start.add(Duration(hours: index));
        return Container(
          width: pixelsPerHour,
          decoration: BoxDecoration(
            border: Border(right: BorderSide(color: Colors.grey.shade300)),
          ),
          alignment: Alignment.topCenter,
          child: Text(
            '${hourTime.hour.toString().padLeft(2, '0')}:00',
            style: TextStyle(fontSize: 10, color: Colors.grey),
          ),
        );
      }),
    );
  }
}

/// Renders a single task as a colored horizontal bar on the Gantt chart.
class _GantChartBar extends StatelessWidget {
  final GantTask task;
  final DateTime chartStart;
  final double pixelsPerHour;

  const _GantChartBar({
    required this.task,
    required this.chartStart,
    required this.pixelsPerHour,
  });

  @override
  Widget build(BuildContext context) {
    final startOffset = task.start.difference(chartStart).inMinutes / 60 * pixelsPerHour;
    final duration = task.end.difference(task.start).inMinutes / 60 * pixelsPerHour;

    return Positioned(
      left: startOffset,
      top: 0,
      child: Container(
        width: duration,
        height: 30,
        decoration: BoxDecoration(
          color: task.color,
          borderRadius: BorderRadius.circular(4),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 4),
        alignment: Alignment.centerLeft,
        child: Text(
          task.title,
          style: const TextStyle(color: Colors.white, fontSize: 12),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
