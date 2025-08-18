import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:plex/plex_theme.dart';
import 'package:plex/plex_utils/plex_dimensions.dart';

class PlexCardGlassEffect extends StatelessWidget {
  final Widget child;
  final Color? shadowColor;
  final Color? shadowColorDark;
  final Color? glassColor;
  final Color? glassColorDark;
  final Color? borderColor;
  final Color? borderColorDark;
  final double borderWidth;
  final double cornerRadius;

  const PlexCardGlassEffect({
    super.key,
    this.shadowColor,
    this.shadowColorDark,
    this.glassColor,
    this.glassColorDark,
    this.borderColor,
    this.borderColorDark,
    this.borderWidth = 1,
    this.cornerRadius = PlexDim.medium,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = PlexTheme.getActiveTheme(context);
    final colorScheme = theme.colorScheme;
    final isDark = PlexTheme.isDarkMode(context);
    final gColor = isDark ? (glassColorDark ?? glassColor ?? Colors.white.withValues(alpha: 0.00)) : (glassColor ?? Colors.white.withValues(alpha: 0.42));
    final bColor = isDark ? (borderColorDark ?? borderColor ?? Colors.white.withValues(alpha: 0.28)) : (borderColor ?? Colors.black.withValues(alpha: 0.28));
    final sColor = isDark ? (shadowColorDark ?? shadowColor ?? colorScheme.primary.withValues(alpha: 0.15)) : (shadowColor ?? colorScheme.primary.withValues(alpha: 0.15));

    return ClipRRect(
      borderRadius: BorderRadius.circular(cornerRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          decoration: BoxDecoration(
            color: gColor,
            borderRadius: BorderRadius.circular(cornerRadius),
            border: Border.all(color: bColor, width: borderWidth),
            boxShadow: [
              BoxShadow(
                color: sColor,
                blurRadius: 24,
                spreadRadius: 6,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
