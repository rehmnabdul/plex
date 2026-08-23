import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plex/plex_theme.dart';
import 'package:plex/plex_utils/plex_date_utils.dart';
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
  final DateTime sample = DateTime(2024, 1, 15, 14, 30);

  testWidgets('typeDate formats with toDateString', (tester) async {
    final PlexWidgetController<DateTime?> controller =
        PlexWidgetController<DateTime?>(data: sample);
    await tester.pumpWidget(
      _wrap(
        PlexFormFieldDate(
          type: PlexFormFieldDateType.typeDate,
          properties:
              const PlexFormFieldGeneric(title: 'Day', useMargin: false),
          selectionController: controller,
        ),
      ),
    );
    expect(find.text(sample.toDateString()), findsOneWidget);
    expect(find.text(sample.toTimeString()), findsNothing);
  });

  testWidgets('typeTime formats with toTimeString', (tester) async {
    final PlexWidgetController<DateTime?> controller =
        PlexWidgetController<DateTime?>(data: sample);
    await tester.pumpWidget(
      _wrap(
        PlexFormFieldDate(
          type: PlexFormFieldDateType.typeTime,
          properties:
              const PlexFormFieldGeneric(title: 'Time', useMargin: false),
          selectionController: controller,
        ),
      ),
    );
    expect(find.text(sample.toTimeString()), findsOneWidget);
    expect(find.text(sample.toDateString()), findsNothing);
  });

  testWidgets('typeDateTime formats with toDateTimeString', (tester) async {
    final PlexWidgetController<DateTime?> controller =
        PlexWidgetController<DateTime?>(data: sample);
    await tester.pumpWidget(
      _wrap(
        PlexFormFieldDate(
          type: PlexFormFieldDateType.typeDateTime,
          properties:
              const PlexFormFieldGeneric(title: 'When', useMargin: false),
          selectionController: controller,
        ),
      ),
    );
    expect(find.text(sample.toDateTimeString()), findsOneWidget);
  });

  testWidgets('cancellable clear sets selection to null', (tester) async {
    final PlexWidgetController<DateTime?> controller =
        PlexWidgetController<DateTime?>(data: sample);
    await tester.pumpWidget(
      _wrap(
        PlexFormFieldDate(
          type: PlexFormFieldDateType.typeDate,
          properties:
              const PlexFormFieldGeneric(title: 'Day', useMargin: false),
          selectionController: controller,
        ),
      ),
    );
    expect(find.byIcon(Icons.close), findsOneWidget);
    await tester.tap(find.byIcon(Icons.close));
    await tester.pump();
    expect(controller.data, isNull);
  });

  testWidgets('cancellable false hides the clear button', (tester) async {
    await tester.pumpWidget(
      _wrap(
        PlexFormFieldDate(
          type: PlexFormFieldDateType.typeDate,
          properties:
              const PlexFormFieldGeneric(title: 'Day', useMargin: false),
          cancellable: false,
        ),
      ),
    );
    expect(find.byIcon(Icons.close), findsNothing);
  });

  testWidgets('existing constructor still builds', (tester) async {
    await tester.pumpWidget(
      _wrap(
        PlexFormFieldDate(
          type: PlexFormFieldDateType.typeDate,
          properties: const PlexFormFieldGeneric.title('Date Picker'),
        ),
      ),
    );
    expect(find.byType(PlexFormFieldDate), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
  });
}
