import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plex/plex_widget.dart';
import 'package:plex/plex_widgets/plex_form_field_widgets.dart';

void main() {
  group('PlexFormFieldInput', () {
    testWidgets('renders with title and hint', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(useMaterial3: true),
          home: Scaffold(
            body: PlexFormFieldInput(
              properties: const PlexFormFieldGeneric.title('Username'),
              inputHint: 'Enter username',
            ),
          ),
        ),
      );

      expect(find.text('Username'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('accepts user input', (tester) async {
      final controller = TextEditingController();
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(useMaterial3: true),
          home: Scaffold(
            body: PlexFormFieldInput(
              properties: const PlexFormFieldGeneric.title('Test'),
              inputController: controller,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'hello');
      expect(controller.text, 'hello');
    });

    testWidgets('shows error when errorController has data', (tester) async {
      final errorController = PlexWidgetController<String?>();
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(useMaterial3: true),
          home: Scaffold(
            body: PlexFormFieldInput(
              properties: const PlexFormFieldGeneric.title('Test'),
              errorController: errorController,
            ),
          ),
        ),
      );

      errorController.setValue('Invalid input');
      await tester.pump();

      expect(find.text('Invalid input'), findsOneWidget);
    });
  });
}
