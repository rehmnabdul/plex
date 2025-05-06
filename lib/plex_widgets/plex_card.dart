import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: margin,
      elevation: elevation,
      clipBehavior: Clip.hardEdge,
      color: color,
      surfaceTintColor: surfaceTintColor,
      shadowColor: shadowColor,
      borderOnForeground: borderOnForeground,
      shape: shape ??
          RoundedRectangleBorder(
            side: borderWidth <= 0 ? BorderSide.none : BorderSide(color: borderColor, width: borderWidth),
            borderRadius: BorderRadius.circular(cornerRadius),
          ),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPressed,
        child: Padding(
          padding: padding != null ? padding! : (disableDefaultPadding ? EdgeInsets.all(0) : EdgeInsets.all(PlexDim.small)),
          child: child,
        ),
      ),
    );
  }
}
