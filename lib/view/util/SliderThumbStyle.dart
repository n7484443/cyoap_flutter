import 'package:flutter/material.dart';

class RoundedRectangleSliderShape extends SliderComponentShape {
  final double thumbRadius;
  final double cornerRadius;

  const RoundedRectangleSliderShape(
      {required this.thumbRadius, required this.cornerRadius});

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;

    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = sliderTheme.thumbColor ?? Colors.white;
    // draw the background shape here..
    canvas.drawRRect(
      RRect.fromRectXY(
          Rect.fromCenter(
              center: center, width: thumbRadius, height: thumbRadius * 2),
          cornerRadius,
          cornerRadius),
      paint,
    );
  }
}
