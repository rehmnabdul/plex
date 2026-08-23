import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plex/plex_theme.dart';
import 'package:plex/plex_widgets/plex_alert.dart';

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
  testWidgets('renders title and message', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const PlexAlert(
          title: 'Heads up',
          message: 'Something happened',
        ),
      ),
    );
    expect(find.text('Heads up'), findsOneWidget);
    expect(find.text('Something happened'), findsOneWidget);
  });

  testWidgets('dismiss hides the banner and calls onClose', (tester) async {
    var closed = false;
    await tester.pumpWidget(
      _wrap(
        PlexAlert(
          title: 'Dismiss me',
          message: 'Tap close',
          onClose: () => closed = true,
        ),
      ),
    );
    expect(find.text('Dismiss me'), findsOneWidget);

    await tester.tap(find.byTooltip('Dismiss'));
    await tester.pump();

    expect(closed, isTrue);
    expect(find.text('Dismiss me'), findsNothing);
  });

  testWidgets('each variant still builds', (tester) async {
    for (final PlexAlertVariant variant in PlexAlertVariant.values) {
      await tester.pumpWidget(
        _wrap(PlexAlert(title: variant.name, variant: variant)),
      );
      expect(find.text(variant.name), findsOneWidget);
    }
  });
}
