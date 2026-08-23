import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plex/plex_theme.dart';
import 'package:plex/plex_widgets/plex_wizard.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    theme: ThemeData(
      useMaterial3: true,
      extensions: <ThemeExtension<dynamic>>[PlexThemeData.fallback()],
    ),
    home: Scaffold(body: child),
  );
}

List<PlexWizardStep> _threeSteps({bool Function()? firstValidator}) {
  return [
    PlexWizardStep(
      title: 'Account',
      child: const Text('Step one body'),
      validator: firstValidator,
    ),
    const PlexWizardStep(
      title: 'Details',
      child: Text('Step two body'),
    ),
    const PlexWizardStep(
      title: 'Review',
      child: Text('Step three body'),
    ),
  ];
}

void main() {
  testWidgets('builds with three steps and shows first step', (tester) async {
    await tester.pumpWidget(
      _wrap(PlexWizard(steps: _threeSteps())),
    );

    expect(find.text('Step one body'), findsOneWidget);
    expect(find.text('Account'), findsOneWidget);
  });

  testWidgets('tapping Next shows second step and fires onStepChanged',
      (tester) async {
    int? changedTo;
    await tester.pumpWidget(
      _wrap(
        PlexWizard(
          steps: _threeSteps(),
          onStepChanged: (index) => changedTo = index,
        ),
      ),
    );

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    expect(find.text('Step two body'), findsOneWidget);
    expect(changedTo, 1);
  });

  testWidgets('Back from step 1 returns to step 0', (tester) async {
    await tester.pumpWidget(
      _wrap(PlexWizard(steps: _threeSteps())),
    );

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(find.text('Step two body'), findsOneWidget);

    await tester.tap(find.text('Back'));
    await tester.pumpAndSettle();

    expect(find.text('Step one body'), findsOneWidget);
  });

  testWidgets('Finish is visible on last step and calls onComplete',
      (tester) async {
    var completed = false;
    await tester.pumpWidget(
      _wrap(
        PlexWizard(
          steps: _threeSteps(),
          onComplete: () => completed = true,
        ),
      ),
    );

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    expect(find.text('Finish'), findsOneWidget);
    expect(find.text('Next'), findsNothing);

    await tester.tap(find.text('Finish'));
    await tester.pumpAndSettle();
    expect(completed, isTrue);
  });

  testWidgets('Next does not advance when validator returns false',
      (tester) async {
    await tester.pumpWidget(
      _wrap(
        PlexWizard(steps: _threeSteps(firstValidator: () => false)),
      ),
    );

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    expect(find.text('Step one body'), findsOneWidget);
    expect(find.text('Step two body'), findsNothing);
  });

  testWidgets('vertical axis builds', (tester) async {
    await tester.pumpWidget(
      _wrap(
        PlexWizard(
          axis: PlexWizardAxis.vertical,
          steps: _threeSteps(),
        ),
      ),
    );
    expect(find.text('Step one body'), findsOneWidget);
    expect(find.text('Account'), findsOneWidget);
  });

  testWidgets('jump skips validators', (tester) async {
    int? changedTo;
    await tester.pumpWidget(
      _wrap(
        PlexWizard(
          allowStepJump: true,
          onStepChanged: (index) => changedTo = index,
          steps: _threeSteps(firstValidator: () => false),
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('plex-wizard-step-2')));
    await tester.pumpAndSettle();

    expect(find.text('Step three body'), findsOneWidget);
    expect(changedTo, 2);
  });
}
