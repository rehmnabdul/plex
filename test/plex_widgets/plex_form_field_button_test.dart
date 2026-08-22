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

Type _materialType(PlexButtonType type) {
  switch (type) {
    case PlexButtonType.elevated:
      return ElevatedButton;
    case PlexButtonType.text:
      return TextButton;
    case PlexButtonType.outlined:
      return OutlinedButton;
    case PlexButtonType.filled:
    case PlexButtonType.filledTonal:
    case PlexButtonType.ink:
    case PlexButtonType.danger:
      return FilledButton;
  }
}

VoidCallback? _onPressedOf(Widget button) {
  if (button is ElevatedButton) return button.onPressed;
  if (button is TextButton) return button.onPressed;
  if (button is OutlinedButton) return button.onPressed;
  if (button is FilledButton) return button.onPressed;
  fail('Unexpected button widget: ${button.runtimeType}');
}

const List<PlexButtonType> _existingTypes = <PlexButtonType>[
  PlexButtonType.elevated,
  PlexButtonType.text,
  PlexButtonType.outlined,
  PlexButtonType.filled,
  PlexButtonType.filledTonal,
];

void main() {
  testWidgets('each existing PlexButtonType still builds', (tester) async {
    for (final PlexButtonType type in _existingTypes) {
      await tester.pumpWidget(
        _wrap(
          PlexFormFieldButton(
            properties: PlexFormFieldGeneric(
              title: type.name,
              useMargin: false,
            ),
            buttonType: type,
            buttonClick: () {},
          ),
        ),
      );
      expect(find.byType(_materialType(type)), findsOneWidget);
      expect(find.text(type.name), findsOneWidget);
    }
  });

  testWidgets('ink and danger types build as filled buttons', (tester) async {
    for (final PlexButtonType type in <PlexButtonType>[
      PlexButtonType.ink,
      PlexButtonType.danger,
    ]) {
      await tester.pumpWidget(
        _wrap(
          PlexFormFieldButton(
            properties:
                PlexFormFieldGeneric(title: type.name, useMargin: false),
            buttonType: type,
            buttonClick: () {},
          ),
        ),
      );
      expect(find.byType(FilledButton), findsOneWidget);
      expect(find.text(type.name), findsOneWidget);
    }
  });

  testWidgets('disabled sets onPressed to null', (tester) async {
    await tester.pumpWidget(
      _wrap(
        PlexFormFieldButton(
          properties: const PlexFormFieldGeneric(
            title: 'Go',
            enabled: false,
            useMargin: false,
          ),
          buttonClick: () {},
        ),
      ),
    );
    final ElevatedButton button =
        tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.onPressed, isNull);
  });

  testWidgets('loading nulls onPressed and shows a spinner', (tester) async {
    await tester.pumpWidget(
      _wrap(
        PlexFormFieldButton(
          properties:
              const PlexFormFieldGeneric(title: 'Save', useMargin: false),
          loading: true,
          buttonClick: () {},
        ),
      ),
    );
    final ElevatedButton button =
        tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.onPressed, isNull);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('enabled idle button has a non-null onPressed', (tester) async {
    await tester.pumpWidget(
      _wrap(
        PlexFormFieldButton(
          properties: const PlexFormFieldGeneric(title: 'Go', useMargin: false),
          buttonClick: () {},
        ),
      ),
    );
    final ElevatedButton button =
        tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.onPressed, isNotNull);
  });

  testWidgets('existing constructor call site still compiles and taps',
      (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      _wrap(
        PlexFormFieldButton(
          properties: const PlexFormFieldGeneric.title('Submit'),
          buttonClick: () => tapped = true,
        ),
      ),
    );
    await tester.tap(find.text('Submit'));
    expect(tapped, isTrue);
  });

  testWidgets('each existing type is disabled when enabled is false',
      (tester) async {
    for (final PlexButtonType type in _existingTypes) {
      await tester.pumpWidget(
        _wrap(
          PlexFormFieldButton(
            properties: PlexFormFieldGeneric(
              title: 'Off',
              enabled: false,
              useMargin: false,
            ),
            buttonType: type,
            buttonClick: () {},
          ),
        ),
      );
      final Widget button = tester.widget(find.byType(_materialType(type)));
      expect(_onPressedOf(button), isNull, reason: type.name);
    }
  });
}
