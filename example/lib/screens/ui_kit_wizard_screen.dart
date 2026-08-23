import 'package:flutter/material.dart';
import 'package:plex/plex_theme.dart';
import 'package:plex/plex_utils/plex_dimensions.dart';
import 'package:plex/plex_utils/plex_messages.dart';
import 'package:plex/plex_widgets/plex_badge.dart';
import 'package:plex/plex_widgets/plex_wizard.dart';
import 'package:plex_app/screens/example_chrome.dart';

class UiKitWizardScreen extends StatefulWidget {
  const UiKitWizardScreen({super.key});

  @override
  State<UiKitWizardScreen> createState() => _UiKitWizardScreenState();
}

class _UiKitWizardScreenState extends State<UiKitWizardScreen> {
  int _step = 0;
  bool _completed = false;

  @override
  Widget build(BuildContext context) {
    final colors = PlexThemeData.of(context).colors;

    return ExampleScrollPage(
      children: [
        ExampleCard(
          title: "PlexWizard",
          subtitle:
              "Linear multi-step flow. Footer labels: Back, Next, Finish.",
          actions: const PlexBadge(label: "Phase 7", tone: PlexBadgeTone.info),
          child: Text(
            _completed
                ? "Finished. Use Back / Next to walk the fake steps again."
                : "Step ${_step + 1} of 3. This is not a login flow.",
            style: TextStyle(color: colors.textSecondary),
          ),
        ),
        const SizedBox(height: PlexDim.medium),
        PlexWizard(
          steps: [
            PlexWizardStep(
              title: "Details",
              subtitle: "Order header",
              child: Text(
                "Warehouse North and a due date of 29 Aug. Placeholder copy only.",
                style: TextStyle(color: colors.textSecondary),
              ),
              validator: () => true,
            ),
            PlexWizardStep(
              title: "Lines",
              subtitle: "SKU mix",
              child: Text(
                "240 pcs of A-1042 and 96 pcs of B-881. Optional notes go here.",
                style: TextStyle(color: colors.textSecondary),
              ),
            ),
            const PlexWizardStep(
              title: "Review",
              subtitle: "Confirm",
              optional: false,
              child: Text("Check the summary, then tap Finish."),
            ),
          ],
          onStepChanged: (index) => setState(() {
            _step = index;
            _completed = false;
          }),
          onComplete: () {
            setState(() => _completed = true);
            context.showMessage("Wizard finished", title: "PlexWizard");
          },
        ),
      ],
    );
  }
}
