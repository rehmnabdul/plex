import 'package:flutter/material.dart';
import 'package:plex/plex_utils/plex_dimensions.dart';
import 'package:plex/plex_utils/plex_messages.dart';
import 'package:plex/plex_widgets/plex_avatar.dart';
import 'package:plex/plex_widgets/plex_badge.dart';
import 'package:plex/plex_widgets/plex_form_field_widgets.dart';
import 'package:plex/plex_widgets/plex_icon_button.dart';
import 'package:plex_app/screens/example_chrome.dart';

class UiKitButtonsScreen extends StatelessWidget {
  const UiKitButtonsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ExampleScrollPage(
      children: [
        ExampleCard(
          title: "PlexFormFieldButton",
          subtitle: "Phase 1 — elevated, text, outlined, filled, tonal, ink, danger",
          child: Wrap(
            spacing: PlexDim.small,
            runSpacing: PlexDim.small,
            children: [
              for (final type in PlexButtonType.values)
                PlexFormFieldButton(
                  properties: PlexFormFieldGeneric(
                    title: type.name,
                    useMargin: false,
                  ),
                  buttonType: type,
                  buttonClick: () {
                    context.showMessage("${type.name} pressed", title: "Button");
                  },
                ),
              PlexFormFieldButton(
                properties: const PlexFormFieldGeneric(
                  title: "Loading",
                  useMargin: false,
                ),
                loading: true,
                buttonClick: () {},
              ),
              PlexFormFieldButton(
                properties: const PlexFormFieldGeneric(
                  title: "Disabled",
                  enabled: false,
                  useMargin: false,
                ),
                buttonIcon: const Icon(Icons.block),
                buttonClick: () {},
              ),
              PlexFormFieldButton(
                properties: const PlexFormFieldGeneric(
                  title: "With icon",
                  useMargin: false,
                ),
                buttonType: PlexButtonType.filled,
                buttonIcon: const Icon(Icons.add),
                buttonClick: () {},
              ),
            ],
          ),
        ),
        const SizedBox(height: PlexDim.medium),
        ExampleCard(
          title: "PlexIconButton",
          subtitle: "Ghost / solid / outline — toolbar and row actions",
          child: Row(
            children: [
              PlexIconButton(
                icon: const Icon(Icons.more_vert),
                label: "More",
                onPressed: () {},
              ),
              PlexIconButton(
                icon: const Icon(Icons.add),
                variant: PlexIconButtonVariant.solid,
                label: "Add",
                onPressed: () {},
              ),
              PlexIconButton(
                icon: const Icon(Icons.filter_list),
                variant: PlexIconButtonVariant.outline,
                label: "Filter",
                onPressed: () {},
              ),
              PlexIconButton(
                icon: const Icon(Icons.delete_outline),
                size: PlexButtonSize.sm,
                onPressed: () {},
              ),
            ],
          ),
        ),
        const SizedBox(height: PlexDim.medium),
        const ExampleCard(
          title: "PlexBadge",
          subtitle: "Tone, appearance, optional dot",
          child: Wrap(
            spacing: PlexDim.small,
            runSpacing: PlexDim.small,
            children: [
              PlexBadge(label: "Neutral"),
              PlexBadge(label: "Info", tone: PlexBadgeTone.info, dot: true),
              PlexBadge(label: "Success", tone: PlexBadgeTone.success),
              PlexBadge(
                label: "Warning",
                tone: PlexBadgeTone.warning,
                appearance: PlexBadgeAppearance.outline,
              ),
              PlexBadge(
                label: "Danger",
                tone: PlexBadgeTone.danger,
                appearance: PlexBadgeAppearance.solid,
              ),
              PlexBadge(label: "Square", square: true),
            ],
          ),
        ),
        const SizedBox(height: PlexDim.medium),
        const ExampleCard(
          title: "PlexAvatar",
          subtitle: "Initials, size, square, presence",
          child: Wrap(
            spacing: PlexDim.medium,
            runSpacing: PlexDim.medium,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              PlexAvatar(name: "Ada Lovelace"),
              PlexAvatar(
                name: "Grace Hopper",
                size: 32,
                square: true,
                status: PlexAvatarStatus.online,
              ),
              PlexAvatar(
                name: "Alan Turing",
                size: 48,
                status: PlexAvatarStatus.busy,
                ring: true,
              ),
              PlexAvatar(
                name: "Katherine Johnson",
                status: PlexAvatarStatus.away,
              ),
              PlexAvatar(
                name: "Offline User",
                status: PlexAvatarStatus.offline,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
