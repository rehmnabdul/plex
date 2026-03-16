import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plex/plex_widgets/plex_form_field_widgets.dart';

void main() {
  group('PlexFormFieldDropdown', () {
    testWidgets('renders with title and items', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(useMaterial3: true),
          home: Scaffold(
            body: PlexFormFieldDropdown<String>(
              properties: const PlexFormFieldGeneric.title('Select'),
              dropdownItems: ['A', 'B', 'C'],
              dropdownItemAsString: (item) => item.toString(),
            ),
          ),
        ),
      );

      expect(find.text('Select'), findsOneWidget);
    });

    testWidgets('shows initial selection', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(useMaterial3: true),
          home: Scaffold(
            body: PlexFormFieldDropdown<String>(
              properties: const PlexFormFieldGeneric.title('Select'),
              dropdownItems: ['Option A', 'Option B'],
              initialSelection: 'Option A',
              dropdownItemAsString: (item) => item.toString(),
            ),
          ),
        ),
      );

      expect(find.text('Option A'), findsOneWidget);
    });
  });
}
