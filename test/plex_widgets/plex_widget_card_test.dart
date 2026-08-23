import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plex/plex_theme.dart';
import 'package:plex/plex_widgets/plex_widget_card.dart';

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
  testWidgets('builds with title and child', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const PlexWidgetCard(
          title: 'Open orders',
          child: Text('Body rows'),
        ),
      ),
    );
    expect(find.text('Open orders'), findsOneWidget);
    expect(find.text('Body rows'), findsOneWidget);
  });

  testWidgets('eyebrow is visible', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const PlexWidgetCard(
          eyebrow: 'Operations',
          title: 'Queue',
          child: Text('Child'),
        ),
      ),
    );
    expect(find.text('OPERATIONS'), findsOneWidget);
  });

  testWidgets('loading hides child', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const PlexWidgetCard(
          title: 'Loading card',
          loading: true,
          child: Text('Hidden body'),
        ),
      ),
    );
    expect(find.text('Hidden body'), findsNothing);
    expect(find.text('Loading card'), findsOneWidget);
  });

  testWidgets('empty hides child and shows emptyTitle', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const PlexWidgetCard(
          title: 'Empty card',
          empty: true,
          emptyTitle: 'No SKUs',
          child: Text('Hidden body'),
        ),
      ),
    );
    expect(find.text('Hidden body'), findsNothing);
    expect(find.text('No SKUs'), findsOneWidget);
  });

  testWidgets('onMenu tap fires', (tester) async {
    var opened = false;
    await tester.pumpWidget(
      _wrap(
        PlexWidgetCard(
          title: 'Menu card',
          onMenu: () => opened = true,
          child: const Text('Body'),
        ),
      ),
    );
    await tester.tap(find.byTooltip('Widget options'));
    await tester.pump();
    expect(opened, isTrue);
  });
}
