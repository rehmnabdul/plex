import 'package:flutter/material.dart';
import 'package:plex/plex_theme.dart';

class PlexHighlightWidget extends StatelessWidget {
  final Widget child;
  final Color? tagBgColor;
  final double size;
  final Alignment alignment;
  final bool enabled;
  late final List<double?> position;

  PlexHighlightWidget({super.key, required this.child, this.tagBgColor, this.size = 10, this.alignment = Alignment.topRight, this.enabled = true}) {
    if(![Alignment.topRight, Alignment.topLeft,Alignment.bottomLeft, Alignment.bottomRight].contains(alignment)) {
      throw Exception("Alignment must be one of the following lisr: [Alignment.topRight, Alignment.topLeft,Alignment.bottomLeft, Alignment.bottomRight]");
    }
    position = calculatePosition(alignment);
  }

  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;
    return Stack(
      children: [
        child,
        Positioned(
          left: position[0],
          right: position[1],
          top: position[2],
          bottom: position[3],
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: tagBgColor ?? PlexTheme.navigationTagColor,
              borderRadius: BorderRadius.circular(size / 2),
            ),
          ),
        ),
      ],
    );
  }

  List<double?> calculatePosition(Alignment alignment) {
    double? left, right, top, bottom;
    if (alignment == Alignment.topLeft) {
      left = 0;
    } else if (alignment == Alignment.topRight) {
      right = 0;
    } else if (alignment == Alignment.bottomLeft) {
      bottom = 0;
    } else if (alignment == Alignment.bottomRight) {
      right = 0;
      bottom = 0;
    }
    return [left, right, top, bottom];
  }
}
