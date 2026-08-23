import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:plex/plex_theme.dart';
import 'package:plex/plex_widgets/plex_info_sheet.dart';

Widget _app(Widget home) {
  return GetMaterialApp(
    theme: ThemeData(
      useMaterial3: true,
      extensions: <ThemeExtension<dynamic>>[PlexThemeData.fallback()],
    ),
    home: home,
  );
}

void main() {
  tearDown(Get.reset);

  testWidgets('default OK action closes the sheet', (tester) async {
    await tester.pumpWidget(
      _app(
        Builder(
          builder: (BuildContext context) {
            return Scaffold(
              body: ElevatedButton(
                onPressed: () {
                  PlexInfoSheet.show(
                    context: context,
                    title: 'Sheet title',
                    message: 'Sheet body',
                  );
                },
                child: const Text('Open'),
              ),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    expect(find.text('Sheet title'), findsOneWidget);

    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    expect(find.text('Sheet title'), findsNothing);
  });

  testWidgets('custom action returning true closes the sheet', (tester) async {
    await tester.pumpWidget(
      _app(
        Builder(
          builder: (BuildContext context) {
            return Scaffold(
              body: ElevatedButton(
                onPressed: () {
                  PlexInfoSheet.show(
                    context: context,
                    title: 'Custom sheet',
                    showOk: false,
                    actions: [
                      PlexInfoSheetAction(
                        label: 'Done',
                        onPressed: () async => true,
                      ),
                    ],
                  );
                },
                child: const Text('Open'),
              ),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    expect(find.text('Custom sheet'), findsOneWidget);

    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();
    expect(find.text('Custom sheet'), findsNothing);
  });
}
