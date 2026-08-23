import 'package:flutter/material.dart';
import 'package:plex/plex_theme.dart';
import 'package:plex/plex_utils/plex_dimensions.dart';

class PlexCard extends StatelessWidget {
  const PlexCard({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPressed,
    this.margin,
    this.borderOnForeground = true,
    this.shape,
    this.cornerRadius = PlexDim.small,
    this.borderWidth = 0,
    this.borderColor = Colors.grey,
    this.color,
    this.surfaceTintColor,
    this.shadowColor,
    this.elevation = PlexDim.medium,
    this.disableDefaultPadding = false,
    this.padding,
    this.title,
    this.subtitle,
    this.actions,
    this.footer,
    this.hover = false,
    this.flush = false,
  });

  final Widget child;
  final double elevation;
  final EdgeInsets? margin;
  final bool disableDefaultPadding;
  final EdgeInsets? padding;
  final GestureTapCallback? onTap;
  final GestureLongPressCallback? onLongPressed;
  final bool borderOnForeground;
  final ShapeBorder? shape;
  final double cornerRadius;
  final double borderWidth;
  final Color borderColor;
  final Color? color;
  final Color? surfaceTintColor;
  final Color? shadowColor;

  /// Optional header title. Header renders if [title], [subtitle], or [actions] is set.
  final String? title;

  /// Optional subtitle under [title].
  final String? subtitle;

  /// Right-aligned header actions.
  final Widget? actions;

  /// Optional footer below the body.
  final Widget? footer;

  /// Lift the card slightly on pointer hover.
  final bool hover;

  /// Remove default body padding (for tables/media). Explicit [padding] still wins.
  final bool flush;

  bool get _hasHeader => title != null || subtitle != null || actions != null;

  bool get _hasChrome => _hasHeader || footer != null;

  EdgeInsets get _bodyPadding {
    if (padding != null) return padding!;
    if (flush || disableDefaultPadding) return EdgeInsets.zero;
    return const EdgeInsets.all(PlexDim.small);
  }

  @override
  Widget build(BuildContext context) {
    if (!hover) {
      return _buildCard(context, hovered: false);
    }
    return _PlexCardHover(
      builder: (bool hovered) => _buildCard(context, hovered: hovered),
    );
  }

  Widget _buildCard(BuildContext context, {required bool hovered}) {
    final PlexColorTokens colors = PlexThemeData.of(context).colors;
    final double resolvedElevation =
        hovered ? elevation + PlexElevation.sm : elevation;

    Widget body = child;
    if (_bodyPadding != EdgeInsets.zero) {
      body = Padding(padding: _bodyPadding, child: body);
    }

    Widget content = body;
    if (_hasChrome) {
      content = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_hasHeader) _header(context, colors),
          body,
          if (footer != null) _footerBar(colors),
        ],
      );
    }

    Widget card = Card(
      margin: margin,
      elevation: resolvedElevation,
      clipBehavior: Clip.hardEdge,
      color: color,
      surfaceTintColor: surfaceTintColor,
      shadowColor: shadowColor,
      borderOnForeground: borderOnForeground,
      shape: shape ??
          RoundedRectangleBorder(
            side: borderWidth <= 0
                ? BorderSide.none
                : BorderSide(color: borderColor, width: borderWidth),
            borderRadius: BorderRadius.circular(cornerRadius),
          ),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPressed,
        child: content,
      ),
    );

    if (hovered) {
      card = Transform.translate(
        offset: const Offset(0, -2),
        child: card,
      );
    }
    return card;
  }

  Widget _header(BuildContext context, PlexColorTokens colors) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: PlexDim.medium,
        vertical: PlexDim.smallMedium,
      ),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colors.borderSubtle)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null)
                  Text(
                    title!,
                    style: textTheme.titleMedium?.copyWith(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: textTheme.bodySmall?.copyWith(
                      color: colors.textMuted,
                    ),
                  ),
              ],
            ),
          ),
          if (actions != null) ...[
            const SizedBox(width: PlexDim.small),
            actions!,
          ],
        ],
      ),
    );
  }

  Widget _footerBar(PlexColorTokens colors) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: PlexDim.medium,
        vertical: PlexDim.smallMedium,
      ),
      decoration: BoxDecoration(
        color: colors.surfaceSunken,
        border: Border(top: BorderSide(color: colors.borderSubtle)),
      ),
      child: footer,
    );
  }
}

class _PlexCardHover extends StatefulWidget {
  const _PlexCardHover({required this.builder});

  final Widget Function(bool hovered) builder;

  @override
  State<_PlexCardHover> createState() => _PlexCardHoverState();
}

class _PlexCardHoverState extends State<_PlexCardHover> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: widget.builder(_hovered),
    );
  }
}
