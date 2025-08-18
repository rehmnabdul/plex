import 'package:flutter/material.dart';
import 'package:plex/plex_theme.dart';

enum PlexBackgroundType {
  neoGlass,
}

class PlexBackground extends StatelessWidget {

  final PlexBackgroundType type;
  final Widget child;

  const PlexBackground({
    super.key,
    this.type = PlexBackgroundType.neoGlass,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if(type == PlexBackgroundType.neoGlass) ...{
          _buildNeoGlassBackground(context),
        },
        child,
      ],
    );
  }

  Widget _buildNeoGlassBackground(BuildContext context) {
    final theme = PlexTheme.getActiveTheme(context);
    final cs = theme.colorScheme;
    final bgStart = Color.lerp(cs.surface, cs.primary.withValues(alpha: 0.10), 0.05)!;
    final bgEnd = Color.lerp(cs.surface, cs.secondary.withValues(alpha: 0.10), 0.05)!;

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [bgStart, bgEnd],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -80,
            left: -40,
            child: _glowOrb(cs.primary.withValues(alpha: 0.35), 220),
          ),
          Positioned(
            bottom: -60,
            right: -20,
            child: _glowOrb(cs.secondary.withValues(alpha: 0.30), 180),
          ),
          Positioned(
            bottom: 120,
            left: -60,
            child: _glowOrb(cs.tertiary.withValues(alpha: 0.20), 160),
          ),
        ],
      ),
    );
  }

  Widget _glowOrb(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color, Colors.transparent],
          stops: const [0.0, 1.0],
        ),
      ),
    );
  }
}
