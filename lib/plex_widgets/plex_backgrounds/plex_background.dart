import 'dart:math';

import 'package:flutter/material.dart';
import 'package:plex/plex_theme.dart';

enum PlexBackgroundType {
  neoGlass,
  particleField,
  gradientMesh,
  geometricTiles,
  solidSurface,
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
    Widget background;
    if (type == PlexBackgroundType.neoGlass) {
      background = _buildNeoGlassBackground(context);
    } else if (type == PlexBackgroundType.particleField) {
      background = const _ParticleFieldBackground(key: ValueKey('particle'));
    } else if (type == PlexBackgroundType.gradientMesh) {
      background = const _GradientMeshBackground(key: ValueKey('gradient'));
    } else if (type == PlexBackgroundType.geometricTiles) {
      background = _buildGeometricTilesBackground(context);
    } else if (type == PlexBackgroundType.solidSurface) {
      background = _buildSolidSurfaceBackground(context);
    } else {
      background = _buildNeoGlassBackground(context);
    }
    return Stack(
      children: [background, child],
    );
  }

  Widget _buildSolidSurfaceBackground(BuildContext context) {
    final theme = PlexTheme.getActiveTheme(context);
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: theme.colorScheme.surface,
    );
  }

  Widget _buildGeometricTilesBackground(BuildContext context) {
    final theme = PlexTheme.getActiveTheme(context);
    final tint = theme.colorScheme.primary.withValues(alpha: 0.06);
    return CustomPaint(
      painter: _GeometricTilesPainter(color: tint),
      size: Size.infinite,
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

class _ParticleFieldBackground extends StatefulWidget {
  const _ParticleFieldBackground({super.key});

  @override
  State<_ParticleFieldBackground> createState() => _ParticleFieldBackgroundState();
}

class _ParticleFieldBackgroundState extends State<_ParticleFieldBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final _particles = List.generate(30, (_) => _Particle());

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = PlexTheme.getActiveTheme(context);
    final color = theme.colorScheme.primary.withValues(alpha: 0.15);
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return CustomPaint(
          painter: _ParticleFieldPainter(
            particles: _particles,
            progress: _controller.value,
            color: color,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class _Particle {
  _Particle()
      : x = Random().nextDouble(),
        y = Random().nextDouble(),
        speed = 0.2 + Random().nextDouble() * 0.3,
        size = 2 + Random().nextDouble() * 4;

  final double x;
  final double y;
  final double speed;
  final double size;
}

class _ParticleFieldPainter extends CustomPainter {
  _ParticleFieldPainter({
    required this.particles,
    required this.progress,
    required this.color,
  });

  final List<_Particle> particles;
  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final x = (p.x + progress * p.speed) % 1.0 * size.width;
      final y = (p.y + progress * p.speed * 0.5) % 1.0 * size.height;
      canvas.drawCircle(
        Offset(x, y),
        p.size,
        Paint()..color = color,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ParticleFieldPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class _GradientMeshBackground extends StatefulWidget {
  const _GradientMeshBackground({super.key});

  @override
  State<_GradientMeshBackground> createState() => _GradientMeshBackgroundState();
}

class _GradientMeshBackgroundState extends State<_GradientMeshBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = PlexTheme.getActiveTheme(context);
    final t = _controller.value;
    final cs = theme.colorScheme;
    final colors = [
      Color.lerp(cs.surface, cs.primary.withValues(alpha: 0.12), 0.1 + t * 0.3)!,
      Color.lerp(cs.surface, cs.secondary.withValues(alpha: 0.10), 0.05 + t * 0.2)!,
      Color.lerp(cs.surface, cs.tertiary.withValues(alpha: 0.08), 0.05)!,
    ];
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(-1 + t * 0.5, -1),
          end: Alignment(1 - t * 0.3, 1),
          colors: colors,
        ),
      ),
    );
  }
}

class _GeometricTilesPainter extends CustomPainter {
  _GeometricTilesPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    const r = 24.0;
    for (var row = 0; row < (size.height / (r * 1.5)).ceil() + 1; row++) {
      for (var col = 0; col < (size.width / (r * 1.5)).ceil() + 1; col++) {
        final x = col * r * 1.5 + (row % 2) * 0.75 * r;
        final y = row * r * 1.3;
        _drawHexagon(canvas, Offset(x, y), r, paint);
      }
    }
  }

  void _drawHexagon(Canvas canvas, Offset center, double r, Paint paint) {
    final path = Path();
    for (var i = 0; i < 6; i++) {
      final angle = (i * 60 - 30) * pi / 180;
      final x = center.dx + r * cos(angle);
      final y = center.dy + r * sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint..style = PaintingStyle.stroke..strokeWidth = 1);
  }

  @override
  bool shouldRepaint(covariant _GeometricTilesPainter oldDelegate) =>
      oldDelegate.color != color;
}
