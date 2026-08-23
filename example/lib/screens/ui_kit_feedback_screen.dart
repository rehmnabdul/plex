import 'package:flutter/material.dart';
import 'package:plex/plex_theme.dart';
import 'package:plex/plex_utils/plex_dimensions.dart';
import 'package:plex/plex_utils/plex_messages.dart';
import 'package:plex/plex_widgets/plex_alert.dart';
import 'package:plex/plex_widgets/plex_form_field_widgets.dart';
import 'package:plex/plex_widgets/plex_progress_bar.dart';
import 'package:plex/plex_widgets/plex_shimmer.dart';
import 'package:plex_app/screens/example_chrome.dart';

class UiKitFeedbackScreen extends StatefulWidget {
  const UiKitFeedbackScreen({super.key});

  @override
  State<UiKitFeedbackScreen> createState() => _UiKitFeedbackScreenState();
}

class _UiKitFeedbackScreenState extends State<UiKitFeedbackScreen> {
  bool _showAlert = true;

  @override
  Widget build(BuildContext context) {
    final colors = PlexThemeData.of(context).colors;

    return ExampleScrollPage(
      children: [
        ExampleCard(
          title: "PlexCard slots",
          subtitle: "title, subtitle, actions, footer — child-only cards still work",
          actions: PlexFormFieldButton(
            properties: const PlexFormFieldGeneric(
              title: "Action",
              useMargin: false,
            ),
            buttonType: PlexButtonType.text,
            buttonClick: () {},
          ),
          footer: Text(
            "Footer slot",
            style: TextStyle(color: colors.textMuted),
          ),
          child: const Text("Body content uses the same tokens as the rest of the kit."),
        ),
        const SizedBox(height: PlexDim.medium),
        const ExampleSectionTitle("PlexAlert"),
        if (_showAlert)
          PlexAlert(
            variant: PlexAlertVariant.info,
            title: "Inline banner",
            message: "Dismissible PlexAlert using semantic tokens.",
            onClose: () => setState(() => _showAlert = false),
          )
        else
          PlexFormFieldButton(
            properties: const PlexFormFieldGeneric(
              title: "Show alert again",
              useMargin: false,
            ),
            buttonType: PlexButtonType.outlined,
            buttonClick: () => setState(() => _showAlert = true),
          ),
        const SizedBox(height: PlexDim.small),
        const PlexAlert(
          variant: PlexAlertVariant.success,
          title: "Saved",
          message: "Changes are stored locally.",
        ),
        const SizedBox(height: PlexDim.small),
        const PlexAlert(
          variant: PlexAlertVariant.warning,
          title: "Check dates",
          message: "Ship date is in the past.",
        ),
        const SizedBox(height: PlexDim.small),
        const PlexAlert(
          variant: PlexAlertVariant.danger,
          title: "Failed",
          message: "The request could not be completed.",
        ),
        const SizedBox(height: PlexDim.medium),
        const ExampleCard(
          title: "PlexProgressBar",
          child: Column(
            children: [
              PlexProgressBar(label: "Sync", value: 64, showValue: true),
              SizedBox(height: PlexDim.medium),
              PlexProgressBar(
                label: "Success tone",
                value: 80,
                showValue: true,
                tone: PlexProgressBarTone.success,
              ),
              SizedBox(height: PlexDim.medium),
              PlexProgressBar(
                label: "Indeterminate",
                indeterminate: true,
              ),
            ],
          ),
        ),
        const SizedBox(height: PlexDim.medium),
        ExampleCard(
          title: "PlexSkeleton / PlexShimmer",
          child: Column(
            children: [
              const Row(
                children: [
                  PlexSkeleton.circle(size: 40),
                  SizedBox(width: PlexDim.small),
                  Expanded(
                    child: Column(
                      children: [
                        PlexSkeleton.line(),
                        SizedBox(height: PlexDim.small),
                        PlexSkeleton.line(width: 160),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: PlexDim.medium),
              PlexShimmer(
                child: Container(
                  height: 72,
                  decoration: BoxDecoration(
                    color: colors.surfaceSunken,
                    borderRadius: BorderRadius.circular(PlexRadius.md),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: PlexDim.medium),
        ExampleCard(
          title: "Toasts",
          subtitle: "context.showMessage uses PlexThemeData colors",
          child: Wrap(
            spacing: PlexDim.small,
            runSpacing: PlexDim.small,
            children: [
              PlexFormFieldButton(
                properties: const PlexFormFieldGeneric(
                  title: "Info",
                  useMargin: false,
                ),
                buttonType: PlexButtonType.outlined,
                buttonClick: () {
                  context.showMessage(
                    "Semantic toast colors from PlexThemeData.",
                    title: "Info",
                    type: MessageType.info,
                  );
                },
              ),
              PlexFormFieldButton(
                properties: const PlexFormFieldGeneric(
                  title: "Success",
                  useMargin: false,
                ),
                buttonType: PlexButtonType.filled,
                buttonClick: () {
                  context.showMessage(
                    "Saved successfully.",
                    title: "Success",
                    type: MessageType.success,
                  );
                },
              ),
              PlexFormFieldButton(
                properties: const PlexFormFieldGeneric(
                  title: "Warning",
                  useMargin: false,
                ),
                buttonType: PlexButtonType.outlined,
                buttonClick: () {
                  context.showMessage(
                    "Check the form before submitting.",
                    title: "Warning",
                    type: MessageType.warning,
                  );
                },
              ),
              PlexFormFieldButton(
                properties: const PlexFormFieldGeneric(
                  title: "Error",
                  useMargin: false,
                ),
                buttonType: PlexButtonType.danger,
                buttonClick: () {
                  context.showMessage(
                    "Something went wrong.",
                    title: "Error",
                    type: MessageType.error,
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
