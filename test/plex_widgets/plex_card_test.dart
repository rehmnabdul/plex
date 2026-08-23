import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plex/plex_theme.dart';
import 'package:plex/plex_widgets/plex_card.dart';

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
  testWidgets('child-only constructor still builds', (tester) async {
    await tester.pumpWidget(
      _wrap(const PlexCard(child: Text('Body'))),
    );
    expect(find.text('Body'), findsOneWidget);
    expect(find.byType(PlexCard), findsOneWidget);
    expect(find.byType(Card), findsOneWidget);
  });

  testWidgets('onTap still works', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      _wrap(
        PlexCard(
          onTap: () => tapped = true,
          child: const Text('Tap me'),
        ),
      ),
    );
    await tester.tap(find.text('Tap me'));
    await tester.pump();
    expect(tapped, isTrue);
  });

  testWidgets('optional header slots still wrap child', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const PlexCard(
          title: 'Title',
          subtitle: 'Subtitle',
          footer: Text('Footer'),
          child: Text('Body'),
        ),
      ),
    );
    expect(find.text('Title'), findsOneWidget);
    expect(find.text('Subtitle'), findsOneWidget);
    expect(find.text('Body'), findsOneWidget);
    expect(find.text('Footer'), findsOneWidget);
  });
}
