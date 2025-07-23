import 'package:flutter/material.dart';

/// Model representing a single task in the Gantt chart.
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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final totalHours = chartEnd.difference(chartStart).inHours;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _GantChartTimeGrid(
            start: chartStart,
            end: chartEnd,
            pixelsPerHour: pixelsPerHour,
            labelStyle: timeLabelStyle,
          ),
          const SizedBox(height: 8),
          ...tasks.map((task) => _GantChartTaskRow(
                task: task,
                chartStart: chartStart,
                chartEnd: chartEnd,
                pixelsPerHour: pixelsPerHour,
                rowHeight: rowHeight,
                barHeight: barHeight,
                labelStyle: taskLabelStyle,
              )),
        ],
      ),
    );
  }
}

/// Renders the horizontal time grid of the Gantt chart.
class _GantChartTimeGrid extends StatelessWidget {
  final DateTime start;
  final DateTime end;
  final double pixelsPerHour;
  final TextStyle? labelStyle;

  const _GantChartTimeGrid({
    required this.start,
    required this.end,
    required this.pixelsPerHour,
    this.labelStyle,
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
          alignment: Alignment.center,
          child: Text(
            '${hourTime.hour.toString().padLeft(2, '0')}:00',
            style: labelStyle ?? const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        );
      }),
    );
  }
}

/// Renders a single task as a colored horizontal bar on the Gantt chart.
class _GantChartTaskRow extends StatelessWidget {
  final GantTask task;
  final DateTime chartStart;
  final DateTime chartEnd;
  final double pixelsPerHour;
  final double rowHeight;
  final double barHeight;
  final TextStyle? labelStyle;

  const _GantChartTaskRow({
    required this.task,
    required this.chartStart,
    required this.chartEnd,
    required this.pixelsPerHour,
    required this.rowHeight,
    required this.barHeight,
    this.labelStyle,
  });

  @override
  Widget build(BuildContext context) {
    final startOffset = task.start.difference(chartStart).inMinutes / 60 * pixelsPerHour;
    final duration = task.end.difference(task.start).inMinutes / 60 * pixelsPerHour;
    final totalHours = chartEnd.difference(chartStart).inHours;
    final totalWidth = totalHours * pixelsPerHour;

    return SizedBox(
      height: rowHeight,
      width: totalWidth, // Ensure the Stack has a bounded width!
      child: Stack(
        children: [
          Positioned(
            left: startOffset,
            top: (rowHeight - barHeight) / 2,
            child: Container(
              width: duration,
              height: barHeight,
              decoration: BoxDecoration(
                color: task.color,
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(
                    color: task.color.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              alignment: Alignment.centerLeft,
              child: Text(
                task.title,
                style: labelStyle ?? const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
