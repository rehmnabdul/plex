import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plex/plex_charts/plex_chart_gant.dart';
import 'package:plex/plex_theme.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    theme: ThemeData(
      useMaterial3: true,
      extensions: <ThemeExtension<dynamic>>[PlexThemeData.fallback()],
    ),
    home: Scaffold(body: child),
  );
}

void main() {
  testWidgets('PlexChartGant and PlexGanttChart typedef build', (tester) async {
    final GantTask task = GantTask(
      id: '1',
      title: 'Design',
      start: DateTime(2024, 6, 1, 9),
      end: DateTime(2024, 6, 1, 12),
      color: Colors.blue,
      progress: 0.5,
    );
    await tester.pumpWidget(
      _wrap(
        PlexGanttChart(
          tasks: [task],
          chartStart: DateTime(2024, 6, 1, 8),
          chartEnd: DateTime(2024, 6, 1, 18),
        ),
      ),
    );
    expect(find.byType(PlexChartGant), findsOneWidget);
    expect(find.text('Design'), findsOneWidget);
  });

  testWidgets('task with progress 0.5 builds', (tester) async {
    final DateTime now = DateTime.now();
    await tester.pumpWidget(
      _wrap(
        SizedBox(
          width: 800,
          height: 240,
          child: PlexChartGant(
            tasks: [
              GantTask(
                id: '2',
                title: 'Build',
                start: now.subtract(const Duration(hours: 1)),
                end: now.add(const Duration(hours: 1)),
                color: Colors.green,
                progress: 0.5,
              ),
            ],
            chartStart: now.subtract(const Duration(hours: 2)),
            chartEnd: now.add(const Duration(hours: 2)),
          ),
        ),
      ),
    );

    expect(find.byType(PlexChartGant), findsOneWidget);
    expect(find.text('Build'), findsOneWidget);
    expect(find.byKey(const Key('plex-gantt-now')), findsOneWidget);
  });
}
