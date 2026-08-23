import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plex/plex_theme.dart';
import 'package:plex/plex_widgets/plex_progress_bar.dart';

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
  testWidgets('determinate value maps onto LinearProgressIndicator', (tester) async {
    await tester.pumpWidget(
      _wrap(const PlexProgressBar(value: 50, max: 100, showValue: true)),
    );
    final LinearProgressIndicator bar = tester.widget(
      find.byType(LinearProgressIndicator),
    );
    expect(bar.value, closeTo(0.5, 0.001));
    expect(find.text('50%'), findsOneWidget);
  });

  testWidgets('indeterminate has a null progress value', (tester) async {
    await tester.pumpWidget(
      _wrap(const PlexProgressBar(indeterminate: true, label: 'Loading')),
    );
    await tester.pump();
    final LinearProgressIndicator bar = tester.widget(
      find.byType(LinearProgressIndicator),
    );
    expect(bar.value, isNull);
    expect(find.text('Loading'), findsOneWidget);
  });

  testWidgets('zero value is determinate', (tester) async {
    await tester.pumpWidget(_wrap(const PlexProgressBar()));
    final LinearProgressIndicator bar = tester.widget(
      find.byType(LinearProgressIndicator),
    );
    expect(bar.value, 0);
  });
}
