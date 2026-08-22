import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plex/plex_theme.dart';
import 'package:plex/plex_widgets/plex_avatar.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    theme: ThemeData(
      useMaterial3: true,
      extensions: <ThemeExtension<dynamic>>[PlexThemeData.fallback()],
    ),
    home: Scaffold(body: child),
  );
}

/// 1x1 transparent PNG.
final Uint8List _pixelPng = Uint8List.fromList(<int>[
  0x89,
  0x50,
  0x4E,
  0x47,
  0x0D,
  0x0A,
  0x1A,
  0x0A,
  0x00,
  0x00,
  0x00,
  0x0D,
  0x49,
  0x48,
  0x44,
  0x52,
  0x00,
  0x00,
  0x00,
  0x01,
  0x00,
  0x00,
  0x00,
  0x01,
  0x08,
  0x06,
  0x00,
  0x00,
  0x00,
  0x1F,
  0x15,
  0xC4,
  0x89,
  0x00,
  0x00,
  0x00,
  0x0A,
  0x49,
  0x44,
  0x41,
  0x54,
  0x78,
  0x9C,
  0x63,
  0x00,
  0x01,
  0x00,
  0x00,
  0x05,
  0x00,
  0x01,
  0x0D,
  0x0A,
  0x2D,
  0xB4,
  0x00,
  0x00,
  0x00,
  0x00,
  0x49,
  0x45,
  0x4E,
  0x44,
  0xAE,
  0x42,
  0x60,
  0x82,
]);

void main() {
  test('initialsFor uses first and last name letters', () {
    expect(PlexAvatar.initialsFor('Ada Lovelace'), 'AL');
    expect(PlexAvatar.initialsFor('Grace'), 'G');
    expect(PlexAvatar.initialsFor('  '), '');
  });

  testWidgets('renders initials when no image is provided', (tester) async {
    await tester.pumpWidget(
      _wrap(const PlexAvatar(name: 'Ada Lovelace')),
    );
    expect(find.text('AL'), findsOneWidget);
    expect(find.byType(Image), findsNothing);
  });

  testWidgets('renders image instead of initials when image is provided',
      (tester) async {
    await tester.pumpWidget(
      _wrap(
        PlexAvatar(
          name: 'Ada Lovelace',
          image: MemoryImage(_pixelPng),
        ),
      ),
    );
    await tester.pump();
    expect(find.byType(Image), findsOneWidget);
    expect(find.text('AL'), findsNothing);
  });

  testWidgets('status and square still build', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const PlexAvatar(
          name: 'Grace Hopper',
          size: 32,
          square: true,
          status: PlexAvatarStatus.online,
          ring: true,
        ),
      ),
    );
    expect(find.text('GH'), findsOneWidget);
    expect(find.byType(PlexAvatar), findsOneWidget);
  });
}
