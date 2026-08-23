import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plex/plex_theme.dart';
import 'package:plex/plex_utils/plex_dimensions.dart';
import 'package:plex/plex_widget.dart';
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
  testWidgets('existing constructor call site still builds', (tester) async {
    await tester.pumpWidget(
      _wrap(
        PlexFormFieldInput(
          properties: const PlexFormFieldGeneric.title('Name'),
          inputHint: 'Enter name',
        ),
      ),
    );
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Name'), findsWidgets);
  });

  testWidgets('hint is applied on InputDecoration', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const PlexFormFieldInput(
          properties: PlexFormFieldGeneric(title: 'Email', useMargin: false),
          inputHint: 'name@example.com',
        ),
      ),
    );
    final TextField field = tester.widget<TextField>(find.byType(TextField));
    expect(field.decoration?.hintText, 'name@example.com');
  });

  testWidgets('error text uses danger token', (tester) async {
    final PlexWidgetController errorController =
        PlexWidgetController(data: 'Required');
    final PlexColorTokens colors = PlexThemeData.fallback().colors;

    await tester.pumpWidget(
      _wrap(
        PlexFormFieldInput(
          properties:
              const PlexFormFieldGeneric(title: 'Email', useMargin: false),
          errorController: errorController,
        ),
      ),
    );
    final TextField field = tester.widget<TextField>(find.byType(TextField));
    expect(field.decoration?.errorText, 'Required');
    expect(field.decoration?.errorStyle?.color, colors.statusDanger);
    expect(field.decoration?.errorBorder, isA<OutlineInputBorder>());
    final OutlineInputBorder errorBorder =
        field.decoration!.errorBorder! as OutlineInputBorder;
    expect(errorBorder.borderSide.color, colors.statusDanger);
  });

  testWidgets('disabled input sets enabled false', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const PlexFormFieldInput(
          properties: PlexFormFieldGeneric(
            title: 'Locked',
            enabled: false,
            useMargin: false,
          ),
        ),
      ),
    );
    final TextField field = tester.widget<TextField>(find.byType(TextField));
    expect(field.enabled, isFalse);
    expect(field.decoration?.disabledBorder, isA<OutlineInputBorder>());
  });

  testWidgets('uses filled surface and md radius tokens', (tester) async {
    final PlexColorTokens colors = PlexThemeData.fallback().colors;
    await tester.pumpWidget(
      _wrap(
        const PlexFormFieldInput(
          properties: PlexFormFieldGeneric(title: 'City', useMargin: false),
        ),
      ),
    );
    final TextField field = tester.widget<TextField>(find.byType(TextField));
    expect(field.decoration?.filled, isTrue);
    expect(field.decoration?.fillColor, colors.surfaceSunken);
    final OutlineInputBorder focused =
        field.decoration!.focusedBorder! as OutlineInputBorder;
    expect(focused.borderRadius, BorderRadius.circular(PlexRadius.md));
    expect(focused.borderSide.color, colors.borderFocus);
    expect(focused.borderSide.width, 1.5);
  });
}
