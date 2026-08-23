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
        PlexFormFieldCheckbox(
          properties: const PlexFormFieldGeneric(
            title: 'Accept terms',
            helperText: 'Required',
            useMargin: false,
          ),
          value: false,
          onChanged: (_) {},
        ),
      ),
    );
    expect(find.byType(Checkbox), findsOneWidget);
    expect(find.text('Accept terms'), findsOneWidget);
    expect(find.text('Required'), findsOneWidget);
  });

  testWidgets('tap notifies onChanged', (tester) async {
    bool? latest;
    await tester.pumpWidget(
      _wrap(
        PlexFormFieldCheckbox(
          properties:
              const PlexFormFieldGeneric(title: 'Agree', useMargin: false),
          value: false,
          onChanged: (value) => latest = value,
        ),
      ),
    );
    await tester.tap(find.byType(Checkbox));
    expect(latest, isTrue);
  });

  testWidgets('disabled does not notify onChanged', (tester) async {
    var called = false;
    await tester.pumpWidget(
      _wrap(
        PlexFormFieldCheckbox(
          properties: const PlexFormFieldGeneric(
            title: 'Agree',
            enabled: false,
            useMargin: false,
          ),
          value: false,
          onChanged: (_) => called = true,
        ),
      ),
    );
    final Checkbox box = tester.widget<Checkbox>(find.byType(Checkbox));
    expect(box.onChanged, isNull);
    await tester.tap(find.byType(Checkbox));
    expect(called, isFalse);
  });

  testWidgets('title-only constructor still builds', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const PlexFormFieldCheckbox(
          properties: PlexFormFieldGeneric.title('Subscribe'),
        ),
      ),
    );
    expect(find.byType(Checkbox), findsOneWidget);
    expect(find.text('Subscribe'), findsOneWidget);
  });
}
