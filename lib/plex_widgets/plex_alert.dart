import 'package:flutter/material.dart';
import 'package:plex/plex_theme.dart';
import 'package:plex/plex_utils/plex_dimensions.dart';

/// Semantic style for [PlexAlert].
enum PlexAlertVariant {
  info,
  success,
  warning,
  danger,
}

/// Inline contextual message banner.
class PlexAlert extends StatefulWidget {
  const PlexAlert({
    super.key,
    this.variant = PlexAlertVariant.info,
    this.title,
    this.message,
    this.child,
    this.onClose,
  });

  final PlexAlertVariant variant;
  final String? title;
  final String? message;
  final Widget? child;
  final VoidCallback? onClose;

  @override
  State<PlexAlert> createState() => _PlexAlertState();
}

class _PlexAlertState extends State<PlexAlert> {
  bool _visible = true;

  void _dismiss() {
    setState(() => _visible = false);
    widget.onClose?.call();
  }

  IconData _iconFor(PlexAlertVariant variant) {
    switch (variant) {
      case PlexAlertVariant.success:
        return Icons.check_circle_outline;
      case PlexAlertVariant.warning:
        return Icons.warning_amber_outlined;
      case PlexAlertVariant.danger:
        return Icons.error_outline;
      case PlexAlertVariant.info:
        return Icons.info_outline;
    }
  }

  ({Color fill, Color ink, Color accent}) _colorsFor(PlexColorTokens colors) {
    switch (widget.variant) {
      case PlexAlertVariant.success:
        return (
          fill: colors.statusSuccessSoft,
          ink: colors.statusSuccessInk,
          accent: colors.statusSuccess,
        );
      case PlexAlertVariant.warning:
        return (
          fill: colors.statusWarningSoft,
          ink: colors.statusWarningInk,
          accent: colors.statusWarning,
        );
      case PlexAlertVariant.danger:
        return (
          fill: colors.statusDangerSoft,
          ink: colors.statusDangerInk,
          accent: colors.statusDanger,
        );
      case PlexAlertVariant.info:
        return (
          fill: colors.statusInfoSoft,
          ink: colors.statusInfoInk,
          accent: colors.statusInfo,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_visible) return const SizedBox.shrink();

    final PlexColorTokens tokens = PlexThemeData.of(context).colors;
    final ({Color fill, Color ink, Color accent}) resolved = _colorsFor(tokens);

    return Semantics(
      container: true,
      liveRegion: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: resolved.fill,
          border: Border.all(color: resolved.accent.withValues(alpha: 0.45)),
          borderRadius: BorderRadius.circular(PlexRadius.md),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: PlexDim.medium,
            vertical: PlexDim.smallMedium,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(_iconFor(widget.variant), size: 18, color: resolved.accent),
              const SizedBox(width: PlexDim.smallMedium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.title != null)
                      Text(
                        widget.title!,
                        style: TextStyle(
                          color: resolved.ink,
                          fontWeight: FontWeight.w700,
                          fontSize: PlexFontSize.body,
                        ),
                      ),
                    if (widget.message != null)
                      Text(
                        widget.message!,
                        style: TextStyle(
                          color: resolved.ink,
                          fontSize: PlexFontSize.caption,
                          height: 1.4,
                        ),
                      ),
                    if (widget.child != null) widget.child!,
                  ],
                ),
              ),
              if (widget.onClose != null)
                IconButton(
                  tooltip: 'Dismiss',
                  onPressed: _dismiss,
                  icon: const Icon(Icons.close),
                  iconSize: 16,
                  color: resolved.ink,
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.all(PlexDim.mini),
                  constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
