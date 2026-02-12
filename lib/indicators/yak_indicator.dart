import 'package:flutter/material.dart';

import '../theme/yak_color.dart';

/// Computes the painted width of the active segment for a given [value] (0–1)
/// and [totalWidth], with [height] used for the 0% dot and min segment width.
double _activeWidth(double value, double totalWidth, double height) {
  if (value <= 0) return height;
  if (value >= 1) return totalWidth;
  final w = height + (totalWidth - height) * value;
  return w.clamp(height, totalWidth);
}

/// A horizontal progress indicator with rounded ends and smooth value animation.
///
/// - [value] is clamped to 0.0–1.0. Changes animate smoothly.
/// - [indicatorRadius] controls the roundness of the active (filled) segment
///   and the track. Use a value >= half of [height] for pill/capsule ends.
/// - At 0%, a small circular dot is shown; at 100% the bar is fully filled.
class YakIndicator extends StatefulWidget {
  /// Progress from 0.0 to 1.0. Values are clamped.
  final double value;

  /// Height of the indicator bar.
  final double height;

  /// Radius for the rounded ends of both the track and the active segment.
  /// Defaults to half of [height] for fully rounded (pill) ends.
  final double? indicatorRadius;

  /// Duration of the animation when [value] changes.
  final Duration duration;

  /// Curve for the value animation.
  final Curve curve;

  /// Color of the active (filled) segment. Defaults to success green.
  final Color? activeColor;

  /// Color of the track (background). Defaults to a light cream.
  final Color? backgroundColor;

  /// Whether to show a percentage label above the trailing end of the indicator.
  final bool showLabel;

  const YakIndicator({
    super.key,
    required this.value,
    this.height = 12.0,
    this.indicatorRadius,
    this.duration = const Duration(milliseconds: 400),
    this.curve = Curves.easeInOut,
    this.activeColor,
    this.backgroundColor,
    this.showLabel = false,
  });

  @override
  State<YakIndicator> createState() => _YakIndicatorState();
}

class _YakIndicatorState extends State<YakIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  static const Color _defaultActiveColor = Color(0xFF6DCF9F);
  static const Color _defaultBackgroundColor = Color(0xFFFCF8E3);

  @override
  void initState() {
    super.initState();
    final clamped = _clamp(widget.value);
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _animation = Tween<double>(begin: clamped, end: clamped).animate(
      CurvedAnimation(parent: _controller, curve: widget.curve),
    );
    _controller.value = 1.0;
  }

  @override
  void didUpdateWidget(YakIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newValue = _clamp(widget.value);
    final oldValue = _clamp(oldWidget.value);
    if (newValue != oldValue) {
      _animation = Tween<double>(begin: oldValue, end: newValue).animate(
        CurvedAnimation(parent: _controller, curve: widget.curve),
      );
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _clamp(double v) => v.clamp(0.0, 1.0);

  @override
  Widget build(BuildContext context) {
    final radius = widget.indicatorRadius ?? (widget.height / 2);
    final activeColor = widget.activeColor ??
        YakColor.primitive.success.success400 ??
        _defaultActiveColor;
    final backgroundColor = widget.backgroundColor ?? _defaultBackgroundColor;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        return AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            final value = _animation.value;
            final widthPx = _activeWidth(value, width, widget.height);
            return SizedBox(
              height: widget.showLabel ? widget.height + 28 : widget.height,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: widget.showLabel ? 20.0 : 0,
                    left: 0,
                    right: 0,
                    child: CustomPaint(
                      size: Size(width, widget.height),
                      painter: _YakIndicatorPainter(
                        value: value,
                        height: widget.height,
                        radius: radius,
                        activeColor: activeColor,
                        backgroundColor: backgroundColor,
                      ),
                    ),
                  ),
                  if (widget.showLabel)
                    Positioned(
                      left: (widthPx - 20).clamp(0.0, width - 40),
                      top: 0,
                      child: _PercentageBubble(
                        value: value,
                        barHeight: widget.height,
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _PercentageBubble extends StatelessWidget {
  const _PercentageBubble({required this.value, required this.barHeight});

  final double value;
  final double barHeight;

  @override
  Widget build(BuildContext context) {
    final percent = (value * 100).round();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Text(
        '$percent%',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: YakColor.primitive.gray.gray700,
        ),
      ),
    );
  }
}

class _YakIndicatorPainter extends CustomPainter {
  _YakIndicatorPainter({
    required this.value,
    required this.height,
    required this.radius,
    required this.activeColor,
    required this.backgroundColor,
  });

  final double value;
  final double height;
  final double radius;
  final Color activeColor;
  final Color backgroundColor;

  @override
  void paint(Canvas canvas, Size size) {
    final effectiveRadius = radius.clamp(0.0, height / 2).toDouble();
    final trackRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, height),
      Radius.circular(effectiveRadius),
    );
    canvas.drawRRect(trackRRect, Paint()..color = backgroundColor);

    final activeWidth = _activeWidth(value, size.width, height);

    if (activeWidth <= height) {
      final center = Offset(effectiveRadius, height / 2);
      canvas.drawCircle(center, effectiveRadius, Paint()..color = activeColor);
    } else {
      final activeRect = RRect.fromRectAndCorners(
        Rect.fromLTWH(0, 0, activeWidth, height),
        topLeft: Radius.circular(effectiveRadius),
        bottomLeft: Radius.circular(effectiveRadius),
        topRight: Radius.circular(effectiveRadius),
        bottomRight: Radius.circular(effectiveRadius),
      );
      canvas.drawRRect(activeRect, Paint()..color = activeColor);
    }
  }

  @override
  bool shouldRepaint(_YakIndicatorPainter oldDelegate) {
    return oldDelegate.value != value ||
        oldDelegate.height != height ||
        oldDelegate.radius != radius ||
        oldDelegate.activeColor != activeColor ||
        oldDelegate.backgroundColor != backgroundColor;
  }
}
