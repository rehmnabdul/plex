import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plex/plex_theme.dart';
import 'package:plex/plex_widgets/plex_tabs.dart';

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
  testWidgets('PlexTabs switches panels without requiring PlexScreen.getTabBar',
      (tester) async {
    await tester.pumpWidget(
      _wrap(
        const PlexTabs(
          tabs: <Tab>[
            Tab(text: 'One'),
            Tab(text: 'Two'),
          ],
          children: <Widget>[
            PlexTabPanel(child: Text('Panel One')),
            PlexTabPanel(child: Text('Panel Two')),
          ],
        ),
      ),
    );
    expect(find.text('One'), findsOneWidget);
    expect(find.text('Panel One'), findsOneWidget);
    await tester.tap(find.text('Two'));
    await tester.pumpAndSettle();
    expect(find.text('Panel Two'), findsOneWidget);
  });
}
