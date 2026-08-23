import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plex/plex_theme.dart';
import 'package:plex/plex_widgets/plex_chart.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    theme: ThemeData(
      useMaterial3: true,
      extensions: <ThemeExtension<dynamic>>[PlexThemeData.fallback()],
    ),
    home: Scaffold(body: child),
  );
}

const _sampleSeries = [
  PlexChartSeries(name: 'Revenue', data: [12, 18, 9, 22]),
];

const _sampleLabels = ['Q1', 'Q2', 'Q3', 'Q4'];

void main() {
  testWidgets('bar chart builds with series and labels', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const PlexChart(
          type: PlexChartType.bar,
          series: _sampleSeries,
          labels: _sampleLabels,
        ),
      ),
    );

    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Text &&
            (widget.data == 'Revenue' ||
                widget.data == 'Q1' ||
                widget.data == 'Q2' ||
                widget.data == 'Q3' ||
                widget.data == 'Q4'),
      ),
      findsWidgets,
    );
  });

  testWidgets('line chart builds with sample data', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const PlexChart(
          type: PlexChartType.line,
          series: _sampleSeries,
          labels: _sampleLabels,
        ),
      ),
    );

    expect(find.byType(PlexChart), findsOneWidget);
  });

  testWidgets('pie chart builds with sample data', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const PlexChart(
          type: PlexChartType.pie,
          series: [
            PlexChartSeries(name: 'Alpha', data: [40]),
            PlexChartSeries(name: 'Beta', data: [35]),
            PlexChartSeries(name: 'Gamma', data: [25]),
          ],
        ),
      ),
    );

    expect(find.byType(PlexChart), findsOneWidget);
  });

  testWidgets('donut scatter combo heatmap build', (tester) async {
    for (final PlexChartType type in <PlexChartType>[
      PlexChartType.donut,
      PlexChartType.scatter,
      PlexChartType.combo,
      PlexChartType.heatmap,
    ]) {
      await tester.pumpWidget(
        _wrap(
          PlexChart(
            type: type,
            series: const [
              PlexChartSeries(name: 'A', data: [4, 8, 2]),
              PlexChartSeries(name: 'B', data: [1, 3, 5]),
            ],
            labels: const ['X', 'Y', 'Z'],
          ),
        ),
      );
      expect(find.byType(PlexChart), findsOneWidget);
    }
  });

  testWidgets('empty series builds without throwing', (tester) async {
    await tester.pumpWidget(
      _wrap(const PlexChart(series: [])),
    );

    expect(find.byType(PlexChart), findsOneWidget);
  });
}
