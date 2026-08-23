import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plex/plex_theme.dart';
import 'package:plex/plex_widgets/plex_tag.dart';

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
  testWidgets('PlexTag renders label', (tester) async {
    await tester.pumpWidget(_wrap(const PlexTag(label: 'rush')));
    expect(find.text('rush'), findsOneWidget);
  });

  testWidgets('PlexTagInput appends a tag', (tester) async {
    List<String> tags = <String>['cut'];
    await tester.pumpWidget(
      _wrap(
        StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return PlexTagInput(
              tags: tags,
              onChanged: (List<String> next) => setState(() => tags = next),
            );
          },
        ),
      ),
    );

    await tester.enterText(
      find.byKey(const Key('plex-tag-input-field')),
      'sew',
    );
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();

    expect(find.text('sew'), findsOneWidget);
    expect(tags, <String>['cut', 'sew']);
  });
}
