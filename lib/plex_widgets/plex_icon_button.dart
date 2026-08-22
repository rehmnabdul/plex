import 'package:flutter/material.dart';
import 'package:plex/plex_theme.dart';
import 'package:plex/plex_utils/plex_dimensions.dart';
import 'package:plex/plex_widgets/plex_form_field_widgets.dart';

/// Visual style for [PlexIconButton].
enum PlexIconButtonVariant {
  ghost,
  solid,
  outline,
}

/// Square icon-only button for toolbars, table rows, and top-bar controls.
class PlexIconButton extends StatelessWidget {
  const PlexIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.variant = PlexIconButtonVariant.ghost,
    this.size = PlexButtonSize.md,
    this.label,
    this.enabled = true,
  });

  final Widget icon;
  final VoidCallback? onPressed;
  final PlexIconButtonVariant variant;
  final PlexButtonSize size;
  final String? label;
  final bool enabled;

  double _dimension() {
    switch (size) {
      case PlexButtonSize.sm:
        return PlexDim.large;
      case PlexButtonSize.md:
        return PlexDim.largePlus;
      case PlexButtonSize.lg:
        return PlexDim.extraLargeMinus;
    }
  }

  double _iconSize() {
    switch (size) {
      case PlexButtonSize.sm:
        return PlexFontSize.medium;
      case PlexButtonSize.md:
        return PlexFontSize.large;
      case PlexButtonSize.lg:
        return PlexFontSize.title;
    }
  }

  @override
  Widget build(BuildContext context) {
    final PlexColorTokens colors = PlexThemeData.of(context).colors;
    final double dim = _dimension();
    final Color foreground;
    final Color background;
    final BorderSide side;

    switch (variant) {
      case PlexIconButtonVariant.solid:
        foreground = colors.textInverse;
        background = colors.brandPrimary;
        side = BorderSide.none;
        break;
      case PlexIconButtonVariant.outline:
        foreground = colors.textPrimary;
        background = Colors.transparent;
        side = BorderSide(color: colors.borderDefault);
        break;
      case PlexIconButtonVariant.ghost:
        foreground = colors.textSecondary;
        background = Colors.transparent;
        side = BorderSide.none;
        break;
    }

    return IconButton(
      onPressed: enabled ? onPressed : null,
      tooltip: label,
      icon: icon,
      iconSize: _iconSize(),
      style: IconButton.styleFrom(
        foregroundColor: foreground,
        backgroundColor: background,
        disabledForegroundColor: colors.textDisabled,
        hoverColor: colors.surfaceHover,
        minimumSize: Size.square(dim),
        maximumSize: Size.square(dim),
        padding: EdgeInsets.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(PlexRadius.md),
        ),
        side: side,
      ),
    );
  }
}
