import 'package:flutter/material.dart';
import 'package:plex/plex_package.dart';
import 'package:plex/plex_theme.dart';
import 'package:plex/plex_utils/plex_dimensions.dart';
import 'package:plex/plex_widgets/plex_card.dart';

/// Shared padding + vertical list for dashboard demo pages.
class ExampleScrollPage extends StatelessWidget {
  const ExampleScrollPage({
    super.key,
    required this.children,
    this.padding,
  });

  final List<Widget> children;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: padding ?? const EdgeInsets.all(PlexDim.medium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }
}

/// Flat [PlexCard] using theme border tokens (glass is opt-in elsewhere).
class ExampleCard extends StatelessWidget {
  const ExampleCard({
    super.key,
    required this.child,
    this.title,
    this.subtitle,
    this.actions,
    this.footer,
    this.flush = false,
    this.hover = false,
    this.onTap,
  });

  final Widget child;
  final String? title;
  final String? subtitle;
  final Widget? actions;
  final Widget? footer;
  final bool flush;
  final bool hover;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = PlexThemeData.of(context).colors;
    return PlexCard(
      title: title,
      subtitle: subtitle,
      actions: actions,
      footer: footer,
      flush: flush,
      hover: hover,
      onTap: onTap,
      elevation: 0,
      borderWidth: 1,
      borderColor: colors.borderSubtle,
      color: colors.surfaceCard,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      child: child,
    );
  }
}

class ExampleSectionTitle extends StatelessWidget {
  const ExampleSectionTitle(this.text, {super.key, this.detail});

  final String text;
  final String? detail;

  @override
  Widget build(BuildContext context) {
    final colors = PlexThemeData.of(context).colors;
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: PlexDim.small),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: textTheme.titleMedium?.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (detail != null) ...[
            const SizedBox(height: PlexDim.mini),
            Text(
              detail!,
              style: textTheme.bodySmall?.copyWith(color: colors.textMuted),
            ),
          ],
        ],
      ),
    );
  }
}

void exampleNavigate(String route) {
  final config = PlexApp.app.dashboardConfig;
  if (config == null) return;
  final index = config.indexOfRoute(route);
  if (index >= 0) {
    config.navigateOnDashboard(index);
  }
}
