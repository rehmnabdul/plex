import 'package:flutter/material.dart';
import 'package:plex/plex_theme.dart';

/// Model representing a single task in the Gantt chart.
class GantTask {
  final String id;
  final String title;
  final DateTime start;
  final DateTime end;
  final Color color;
  final double? progress;
  final String? subtitle;

  GantTask({
    required this.id,
    required this.title,
    required this.start,
    required this.end,
    required this.color,
    this.progress,
    this.subtitle,
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
  final ValueChanged<GantTask>? onTaskTap;

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
    this.onTaskTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                onTaskTap: onTaskTap,
              )),
        ],
      ),
    );
  }
}

typedef PlexGanttChart = PlexChartGant;

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
    final colors = PlexThemeData.of(context).colors;
    return Row(
      children: List.generate(hours, (index) {
        final hourTime = start.add(Duration(hours: index));
        return Container(
          width: pixelsPerHour,
          decoration: BoxDecoration(
            border: Border(right: BorderSide(color: colors.borderSubtle)),
          ),
          alignment: Alignment.center,
          child: Text(
            '${hourTime.hour.toString().padLeft(2, '0')}:00',
            style:
                labelStyle ?? TextStyle(fontSize: 12, color: colors.textMuted),
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
  final ValueChanged<GantTask>? onTaskTap;

  const _GantChartTaskRow({
    required this.task,
    required this.chartStart,
    required this.chartEnd,
    required this.pixelsPerHour,
    required this.rowHeight,
    required this.barHeight,
    this.labelStyle,
    this.onTaskTap,
  });

  @override
  Widget build(BuildContext context) {
    final startOffset =
        task.start.difference(chartStart).inMinutes / 60 * pixelsPerHour;
    final duration =
        task.end.difference(task.start).inMinutes / 60 * pixelsPerHour;
    final totalHours = chartEnd.difference(chartStart).inHours;
    final totalWidth = totalHours * pixelsPerHour;
    final progress = task.progress;
    final progressWidth =
        progress == null ? 0.0 : duration * progress.clamp(0.0, 1.0);

    Widget bar = Container(
      width: duration,
      height: barHeight,
      decoration: BoxDecoration(
        color: task.color,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: task.color.withValues(alpha: 0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          if (progress != null)
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              width: progressWidth,
              child: ColoredBox(
                color: Color.alphaBlend(
                  Colors.black.withValues(alpha: 0.28),
                  task.color,
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: task.subtitle == null
                  ? Text(
                      task.title,
                      style: labelStyle ??
                          const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                      overflow: TextOverflow.ellipsis,
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title,
                          style: labelStyle ??
                              const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          task.subtitle!,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontSize: 10,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );

    if (onTaskTap != null) {
      bar = GestureDetector(
        onTap: () => onTaskTap!(task),
        child: bar,
      );
    }

    return SizedBox(
      height: rowHeight,
      width: totalWidth, // Ensure the Stack has a bounded width!
      child: Stack(
        children: [
          Positioned(
            left: startOffset,
            top: (rowHeight - barHeight) / 2,
            child: bar,
          ),
        ],
      ),
    );
  }
}
