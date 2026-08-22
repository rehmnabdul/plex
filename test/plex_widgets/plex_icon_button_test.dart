import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plex/plex_theme.dart';
import 'package:plex/plex_widgets/plex_form_field_widgets.dart';
import 'package:plex/plex_widgets/plex_icon_button.dart';

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
  testWidgets('each PlexIconButtonVariant builds', (tester) async {
    for (final PlexIconButtonVariant variant in PlexIconButtonVariant.values) {
      await tester.pumpWidget(
        _wrap(
          PlexIconButton(
            icon: const Icon(Icons.add),
            variant: variant,
            label: variant.name,
            onPressed: () {},
          ),
        ),
      );
      expect(find.byType(IconButton), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    }
  });

  testWidgets('disabled and null onPressed disable the button', (tester) async {
    await tester.pumpWidget(
      _wrap(
        PlexIconButton(
          icon: const Icon(Icons.close),
          enabled: false,
          onPressed: () {},
        ),
      ),
    );
    expect(
        tester.widget<IconButton>(find.byType(IconButton)).onPressed, isNull);

    await tester.pumpWidget(
      _wrap(
        const PlexIconButton(icon: Icon(Icons.close)),
      ),
    );
    expect(
        tester.widget<IconButton>(find.byType(IconButton)).onPressed, isNull);
  });

  testWidgets('label is exposed as a tooltip', (tester) async {
    await tester.pumpWidget(
      _wrap(
        PlexIconButton(
          icon: const Icon(Icons.more_vert),
          label: 'More actions',
          onPressed: () {},
        ),
      ),
    );
    expect(find.byTooltip('More actions'), findsOneWidget);
  });

  testWidgets('size variants still build', (tester) async {
    for (final PlexButtonSize size in PlexButtonSize.values) {
      await tester.pumpWidget(
        _wrap(
          PlexIconButton(
            icon: const Icon(Icons.search),
            size: size,
            onPressed: () {},
          ),
        ),
      );
      expect(find.byType(IconButton), findsOneWidget);
    }
  });
}
