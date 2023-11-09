import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// [PlexShimmerDirection] controls the direction of the shimmer effect
///
enum PlexShimmerDirection {
  /// Default direction is [PlexShimmerDirection.leftToRight], which starts the
  /// shimmer effect animation from left to right side of the child Widget.
  leftToRight,

  /// Direction [PlexShimmerDirection.rightToLeft], which starts the shimmer
  /// effect animation from right to left side of the child Widget.
  rightToLeft,

  /// Direction [PlexShimmerDirection.topToBottom], which starts the shimmer
  /// effect animation from top to bottom side of the child Widget.
  topToBottom,

  /// Direction [PlexShimmerDirection.bottomToTop], which starts the shimmer
  /// effect animation from bottom to top side of the child Widget.
  bottomToTop
}

class PlexShimmer extends StatefulWidget {
  /// [PlexShimmer] shows shimmer effect.
  const PlexShimmer({
    Key? key,
    required this.child,
    this.gradient,
    this.direction = PlexShimmerDirection.leftToRight,
    this.duration = const Duration(milliseconds: 1500),
    this.shimmerEffectCount = 0,
    this.showShimmerEffect = true,
    this.showGradient = false,
    this.mainColor = Colors.grey,
    this.secondaryColor = const Color(0xffE0E0E0),
  }) : super(key: key);

  /// The child of type [Widget] to display shimmer effect.
  final Widget child;

  /// Controls the speed of the shimmer effect.
  /// The default value is 1500 milliseconds.
  final Duration duration;

  /// Controls the direction of the shimmer effect.
  /// The default direction is GFShimmerDirection.leftToRight.
  final PlexShimmerDirection direction;

  /// Controls the [child]'s shades of color using Linear gradient.
  /// Child [Widget] only takes gradient color, If [showGradient] is true.
  final Gradient? gradient;

  /// Controls the animation shimmerEffectCount.
  /// The default value is '0', that displays child [Widget]'s shimmer effect forever.
  final int shimmerEffectCount;

  /// Controls animation effect, defaults true state that makes animation active.
  final bool showShimmerEffect;

  /// If true, takes gradient color [gradient] for the [child]'s shimmer effect.
  /// Default set to false.
  final bool showGradient;

  /// Defines the main color of the [child]'s shimmer effect.
  /// Child [Widget] takes main color, only if [showGradient] is false.
  /// Default [showGradient] will be false.
  final Color mainColor;

  /// defines the secondary color of the [child]'s shimmer effect.
  /// Child [Widget] takes secondary color, only if [showGradient] is false.
  /// Default [showGradient] will be false.
  final Color secondaryColor;

  @override
  PlexShimmerState createState() => PlexShimmerState();
}

class PlexShimmerState extends State<PlexShimmer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late int _count;

  @override
  void initState() {
    super.initState();
    _count = 0;
    _controller = AnimationController(duration: widget.duration, vsync: this)
      ..addStatusListener((AnimationStatus status) {
        if (status != AnimationStatus.completed) {
          return;
        }
        _count++;
        if (widget.shimmerEffectCount <= 0) {
          _controller.repeat();
        } else if (_count < widget.shimmerEffectCount) {
          _controller.forward(from: 0);
        }
      });
    if (widget.showShimmerEffect) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(PlexShimmer oldWidget) {
    if (widget.showShimmerEffect) {
      _controller.forward();
    } else {
      _controller.stop();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _controller,
        child: widget.child,
        builder: (BuildContext context, Widget? child) => _PlexShimmer(
          direction: widget.direction,
          gradient: widget.showGradient ? widget.gradient : LinearGradient(begin: Alignment.topLeft, end: Alignment.centerRight, colors: <Color>[widget.mainColor, widget.mainColor, widget.secondaryColor, widget.mainColor, widget.mainColor], stops: const <double>[0, 0.3, 0.5, 0.7, 1]),
          controllerValue: _controller.value,
          showShimmerEffect: widget.showShimmerEffect,
          child: child,
        ),
      );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

@immutable
class _PlexShimmer extends SingleChildRenderObjectWidget {
  const _PlexShimmer({
    Widget? child,
    this.controllerValue,
    this.direction,
    this.gradient,
    this.showShimmerEffect,
  }) : super(child: child);

  /// value that controls the animation controller
  final double? controllerValue;

  /// Controls the direction of the shimmer effect.
  /// The default direction is GFShimmerDirection.leftToRight.
  final PlexShimmerDirection? direction;

  /// Controls the [child]'s shades of color.
  final Gradient? gradient;

  /// Controls animation effect, defaults true state that makes animation active.
  final bool? showShimmerEffect;

  @override
  PlexShimmerFilter createRenderObject(BuildContext context) => PlexShimmerFilter(value: controllerValue, direction: direction, gradient: gradient, showShimmerEffect: showShimmerEffect);

  @override
  void updateRenderObject(BuildContext context, PlexShimmerFilter shimmer) {
    shimmer.controllerValue = controllerValue;
    shimmer.showShimmerEffect = showShimmerEffect;
  }
}

class PlexShimmerFilter extends RenderProxyBox {
  PlexShimmerFilter({this.value, this.direction, this.gradient, this.showShimmerEffect}) : gradientPaint = Paint()..blendMode = BlendMode.srcIn;

  /// Constructs an empty [Paint] object with all fields initialized to their defaults.
  final Paint initialPaint = Paint();

  /// Shader that paints a color gradient.
  final Paint gradientPaint;

  /// Controls the [child]'s shades of color.
  final Gradient? gradient;

  /// Controls the direction of the shimmer effect.
  /// The default direction is GFShimmerDirection.leftToRight.
  final PlexShimmerDirection? direction;

  /// Controls animation effect, defaults true state that makes animation active.
  bool? showShimmerEffect;

  /// value that controls the animation controller.
  double? value;

  /// Construct a rectangle from its left, top, right, and bottom edges.
  Rect? _rect;

  @override
  bool get alwaysNeedsCompositing => child != null;

  double? get controllerValue => value;

  set controllerValue(double? newValue) {
    if (newValue == value) {
      return;
    }
    value = newValue;
    markNeedsPaint();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child == null) {
      return;
    }
    assert(needsCompositing);

    context.canvas.saveLayer(offset & child!.size, initialPaint);
    context.paintChild(child!, offset);
    Rect rect;
    double dx, dy;
    final double width = child!.size.width;
    final double height = child!.size.height;

    if (direction == PlexShimmerDirection.leftToRight) {
      dx = _offset(-width, width, value!);
      dy = 0.0;
      rect = Rect.fromLTWH(offset.dx - width, offset.dy, 3 * width, height);
    } else if (direction == PlexShimmerDirection.bottomToTop) {
      dx = 0.0;
      dy = _offset(height, -height, value!);
      rect = Rect.fromLTWH(offset.dx, offset.dy - height, width, 3 * height);
    } else if (direction == PlexShimmerDirection.topToBottom) {
      dx = 0.0;
      dy = _offset(-height, height, value!);
      rect = Rect.fromLTWH(offset.dx, offset.dy - height, width, 3 * height);
    } else {
      dx = _offset(width, -width, value!);
      dy = 0.0;
      rect = Rect.fromLTWH(offset.dx - width, offset.dy, 3 * width, height);
    }
    if (_rect != rect) {
      gradientPaint.shader = gradient?.createShader(rect);
      _rect = rect;
    }
    context.canvas.translate(dx, dy);
    context.canvas.drawRect(rect, gradientPaint);
    context.canvas.restore();
  }

  double _offset(double start, double end, double controllerValue) => start + (end - start) * controllerValue;
}
