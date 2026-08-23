import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plex/plex_theme.dart';
import 'package:plex/plex_widgets/plex_form_field_widgets.dart';

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
  testWidgets('builds with title and helper text', (tester) async {
    await tester.pumpWidget(
      _wrap(
        PlexFormFieldSwitch(
          properties: const PlexFormFieldGeneric(
            title: 'Email notifications',
            helperText: 'Apply immediately',
            useMargin: false,
          ),
          value: true,
          onChanged: (_) {},
        ),
      ),
    );
    expect(find.byType(Switch), findsOneWidget);
    expect(find.text('Email notifications'), findsOneWidget);
    expect(find.text('Apply immediately'), findsOneWidget);
    expect(tester.widget<Switch>(find.byType(Switch)).value, isTrue);
  });

  testWidgets('tap notifies onChanged', (tester) async {
    bool? latest;
    await tester.pumpWidget(
      _wrap(
        PlexFormFieldSwitch(
          properties:
              const PlexFormFieldGeneric(title: 'Dark mode', useMargin: false),
          value: false,
          onChanged: (value) => latest = value,
        ),
      ),
    );
    await tester.tap(find.byType(Switch));
    expect(latest, isTrue);
  });

  testWidgets('disabled does not notify onChanged', (tester) async {
    var called = false;
    await tester.pumpWidget(
      _wrap(
        PlexFormFieldSwitch(
          properties: const PlexFormFieldGeneric(
            title: 'Dark mode',
            enabled: false,
            useMargin: false,
          ),
          value: false,
          onChanged: (_) => called = true,
        ),
      ),
    );
    final Switch toggle = tester.widget<Switch>(find.byType(Switch));
    expect(toggle.onChanged, isNull);
    await tester.tap(find.byType(Switch));
    expect(called, isFalse);
  });

  testWidgets('title-only constructor still builds', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const PlexFormFieldSwitch(
          properties: PlexFormFieldGeneric.title('Autosave'),
        ),
      ),
    );
    expect(find.byType(Switch), findsOneWidget);
    expect(find.text('Autosave'), findsOneWidget);
  });
}
