import 'package:flutter/material.dart';
import 'package:plex/plex_theme.dart';
import 'package:plex/plex_utils/plex_dimensions.dart';
import 'package:plex/plex_widgets/plex_shimmer.dart';

/// Surface treatment for [PlexWidgetCard].
enum PlexWidgetCardTone {
  standard,
  brand,
  accent,
}

/// Dashboard widget shell: eyebrow / title / actions / loading / empty.
///
/// Does **not** replace the reactive [PlexWidget] / [PlexWidgetController].
class PlexWidgetCard extends StatelessWidget {
  const PlexWidgetCard({
    super.key,
    this.eyebrow,
    this.title,
    this.subtitle,
    this.actions,
    this.onMenu,
    this.footer,
    this.tone = PlexWidgetCardTone.standard,
    this.flat = false,
    this.flush = false,
    this.rule = false,
    this.height,
    this.loading = false,
    this.empty = false,
    this.emptyTitle = 'No data yet',
    this.emptyMessage,
    this.child,
  });

  final String? eyebrow;
  final String? title;
  final String? subtitle;
  final Widget? actions;
  final VoidCallback? onMenu;
  final Widget? footer;
  final PlexWidgetCardTone tone;
  final bool flat;
  final bool flush;
  final bool rule;
  final double? height;
  final bool loading;
  final bool empty;
  final String emptyTitle;
  final String? emptyMessage;
  final Widget? child;

  bool get _hasHeader =>
      eyebrow != null ||
      title != null ||
      subtitle != null ||
      actions != null ||
      onMenu != null;

  @override
  Widget build(BuildContext context) {
    final PlexColorTokens colors = PlexThemeData.of(context).colors;
    final ({Color background, Color foreground, Color muted, Color border})
        surface = _surface(colors);

    Widget body;
    if (loading) {
      body = const _LoadingBody();
    } else if (empty) {
      body = _EmptyBody(
        title: emptyTitle,
        message: emptyMessage,
        titleColor: surface.foreground,
        mutedColor: surface.muted,
      );
    } else {
      body = child ?? const SizedBox.shrink();
    }

    if (!flush && !loading && !empty) {
      body = Padding(
        padding: const EdgeInsets.fromLTRB(
          PlexDim.mediumPlus,
          0,
          PlexDim.mediumPlus,
          PlexDim.mediumPlus,
        ),
        child: body,
      );
    } else if (loading || empty) {
      body = Padding(
        padding: const EdgeInsets.fromLTRB(
          PlexDim.mediumPlus,
          0,
          PlexDim.mediumPlus,
          PlexDim.mediumPlus,
        ),
        child: body,
      );
    }

    final List<Widget> column = <Widget>[
      if (_hasHeader) _header(context, surface),
      if (height != null) Expanded(child: body) else body,
      if (footer != null) _footerBar(surface),
    ];

    Widget card = Material(
      color: surface.background,
      elevation: flat ? 0 : PlexElevation.xs,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(PlexRadius.lg),
        side: BorderSide(color: surface.border),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        mainAxisSize: height == null ? MainAxisSize.min : MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: column,
      ),
    );

    if (height != null) {
      card = SizedBox(height: height, child: card);
    }
    return card;
  }

  Widget _header(
    BuildContext context,
    ({Color background, Color foreground, Color muted, Color border}) surface,
  ) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        PlexDim.mediumPlus,
        PlexDim.medium,
        PlexDim.mediumPlus,
        PlexDim.smallMedium,
      ),
      decoration: BoxDecoration(
        border: rule ? Border(bottom: BorderSide(color: surface.border)) : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (eyebrow != null)
                  Text(
                    eyebrow!.toUpperCase(),
                    style: TextStyle(
                      color: surface.muted,
                      fontSize: PlexFontSize.smallest,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                    ),
                  ),
                if (title != null) ...[
                  if (eyebrow != null) const SizedBox(height: PlexDim.mini),
                  Text(
                    title!,
                    style: TextStyle(
                      color: surface.foreground,
                      fontSize: PlexFontSize.body,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
                if (subtitle != null) ...[
                  const SizedBox(height: PlexDim.mini),
                  Text(
                    subtitle!,
                    style: TextStyle(
                      color: surface.muted,
                      fontSize: PlexFontSize.small,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (actions != null || onMenu != null) ...[
            const SizedBox(width: PlexDim.small),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (actions != null) actions!,
                if (onMenu != null)
                  IconButton(
                    tooltip: 'Widget options',
                    visualDensity: VisualDensity.compact,
                    icon: Icon(Icons.more_vert, color: surface.muted),
                    onPressed: onMenu,
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _footerBar(
    ({Color background, Color foreground, Color muted, Color border}) surface,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: PlexDim.mediumPlus,
        vertical: PlexDim.smallMedium,
      ),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: surface.border)),
      ),
      child: DefaultTextStyle.merge(
        style: TextStyle(color: surface.muted, fontSize: PlexFontSize.small),
        child: footer!,
      ),
    );
  }

  ({Color background, Color foreground, Color muted, Color border}) _surface(
    PlexColorTokens colors,
  ) {
    switch (tone) {
      case PlexWidgetCardTone.brand:
        return (
          background: colors.surfaceInverse,
          foreground: colors.textInverse,
          muted: colors.textInverse.withValues(alpha: 0.64),
          border: colors.surfaceInverse,
        );
      case PlexWidgetCardTone.accent:
        return (
          background: colors.brandPrimary,
          foreground: colors.textInverse,
          muted: colors.textInverse.withValues(alpha: 0.72),
          border: colors.brandPrimary,
        );
      case PlexWidgetCardTone.standard:
        return (
          background: colors.surfaceCard,
          foreground: colors.textPrimary,
          muted: colors.textMuted,
          border: colors.borderSubtle,
        );
    }
  }
}

class _LoadingBody extends StatelessWidget {
  const _LoadingBody();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        PlexSkeleton.line(width: 220, height: 10),
        SizedBox(height: PlexDim.small),
        PlexSkeleton.line(width: 160, height: 10),
        SizedBox(height: PlexDim.small),
        PlexSkeleton.line(width: 240, height: 10),
        SizedBox(height: PlexDim.small),
        PlexSkeleton.line(width: 180, height: 10),
      ],
    );
  }
}

class _EmptyBody extends StatelessWidget {
  const _EmptyBody({
    required this.title,
    required this.message,
    required this.titleColor,
    required this.mutedColor,
  });

  final String title;
  final String? message;
  final Color titleColor;
  final Color mutedColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: PlexDim.large),
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: titleColor,
              fontSize: PlexFontSize.body,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: PlexDim.smallest),
            Text(
              message!,
              textAlign: TextAlign.center,
              style: TextStyle(color: mutedColor, fontSize: PlexFontSize.caption),
            ),
          ],
        ],
      ),
    );
  }
}
