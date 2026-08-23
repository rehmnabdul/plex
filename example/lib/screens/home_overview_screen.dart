import 'package:flutter/material.dart';
import 'package:plex/plex_package.dart';
import 'package:plex/plex_theme.dart';
import 'package:plex/plex_utils/plex_dimensions.dart';
import 'package:plex/plex_widgets/plex_alert.dart';
import 'package:plex/plex_widgets/plex_avatar.dart';
import 'package:plex/plex_widgets/plex_badge.dart';
import 'package:plex_app/screens/example_chrome.dart';
import 'package:plex_app/screens/example_routes.dart';

class HomeOverviewScreen extends StatelessWidget {
  const HomeOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = PlexThemeData.of(context).colors;
    final user = PlexApp.app.getUser();

    return ExampleScrollPage(
      children: [
        ExampleCard(
          child: Row(
            children: [
              PlexAvatar(
                name: user?.getLoggedInFullName() ?? "Plex User",
                size: 48,
                status: PlexAvatarStatus.online,
              ),
              const SizedBox(width: PlexDim.medium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome back",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: colors.textMuted,
                          ),
                    ),
                    Text(
                      user?.getLoggedInFullName() ?? "Plex Example",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: colors.textPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: PlexDim.small),
                    const Wrap(
                      spacing: PlexDim.small,
                      runSpacing: PlexDim.small,
                      children: [
                        PlexBadge(label: "Flat chrome"),
                        PlexBadge(
                          label: "Split login",
                          tone: PlexBadgeTone.info,
                          dot: true,
                        ),
                        PlexBadge(
                          label: "Material 3",
                          tone: PlexBadgeTone.success,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: PlexDim.medium),
        PlexAlert(
          variant: PlexAlertVariant.info,
          title: "Design system demo",
          message:
              "Use the Design system category to QA the 2.0.1 UI revamp. PlexDataGrid is the table engine; PlexAdvanceDataTable is a deprecated wrapper. PDF export is Plex-owned (PlexPrinter). Existing feature screens are restyled but keep their original purpose.",
        ),
        const SizedBox(height: PlexDim.medium),
        const ExampleSectionTitle(
          "Design system",
          detail: "Visual QA routes for the UI revamp.",
        ),
        Wrap(
          spacing: PlexDim.medium,
          runSpacing: PlexDim.medium,
          children: [
            _ShortcutCard(
              title: "Theme & brand",
              subtitle: "Seed, tokens, density",
              icon: Icons.palette_outlined,
              route: Routes.uiTheme,
            ),
            _ShortcutCard(
              title: "Buttons & identity",
              subtitle: "Phase 1 widgets",
              icon: Icons.smart_button_outlined,
              route: Routes.uiButtons,
            ),
            _ShortcutCard(
              title: "Forms",
              subtitle: "Checkbox, switch, fields",
              icon: Icons.edit_note_outlined,
              route: Routes.uiForms,
            ),
            _ShortcutCard(
              title: "Feedback",
              subtitle: "Cards, alerts, skeleton",
              icon: Icons.notifications_outlined,
              route: Routes.uiFeedback,
            ),
            _ShortcutCard(
              title: "Tabs",
              subtitle: "PlexTabs",
              icon: Icons.tab_outlined,
              route: Routes.uiTabs,
            ),
            _ShortcutCard(
              title: "Data grid",
              subtitle: "PlexDataGrid — sort, search, pages",
              icon: Icons.grid_on_outlined,
              route: Routes.dataGridScreen,
            ),
          ],
        ),
        const SizedBox(height: PlexDim.large),
        const ExampleSectionTitle(
          "Feature demos",
          detail: "Original example screens, restyled with the same tokens.",
        ),
        Wrap(
          spacing: PlexDim.medium,
          runSpacing: PlexDim.medium,
          children: [
            _ShortcutCard(
              title: "All inputs",
              subtitle: "Full form catalog",
              icon: Icons.input,
              route: Routes.allInputs,
            ),
            _ShortcutCard(
              title: "Advance table",
              subtitle: "Deprecated wrapper",
              icon: Icons.table_chart_outlined,
              route: Routes.advanceDataTable,
            ),
            _ShortcutCard(
              title: "Gantt chart",
              subtitle: "PlexChartGant",
              icon: Icons.timeline_outlined,
              route: Routes.ganttDemoScreen,
            ),
            _ShortcutCard(
              title: "Scanner",
              subtitle: "QR / barcode",
              icon: Icons.qr_code_scanner_outlined,
              route: Routes.scannerDemoScreen,
            ),
          ],
        ),
      ],
    );
  }
}

class _ShortcutCard extends StatelessWidget {
  const _ShortcutCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.route,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final String route;

  @override
  Widget build(BuildContext context) {
    final colors = PlexThemeData.of(context).colors;
    return SizedBox(
      width: 240,
      child: ExampleCard(
        hover: true,
        onTap: () => exampleNavigate(route),
        child: Row(
          children: [
            Icon(icon, color: colors.brandPrimary),
            const SizedBox(width: PlexDim.small),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: colors.textMuted,
                      fontSize: PlexFontSize.caption,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
