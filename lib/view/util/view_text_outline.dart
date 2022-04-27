import 'package:flutter/material.dart';

class TextOutline extends StatelessWidget {
  final String text;
  final Color textColor;
  final Color outlineColor;
  final double strokeWidth;
  final double fontSize;
  final FontWeight fontWeight;
  final TextStyle style;

  const TextOutline(this.text, this.fontSize, this.style,
      {this.textColor = Colors.black,
      this.outlineColor = Colors.white,
      this.strokeWidth = 4.0,
      this.fontWeight = FontWeight.normal,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Text(
        text,
        style: style.copyWith(
          fontSize: fontSize,
          foreground: Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = strokeWidth
            ..color = outlineColor,
        ),
      ),
      Text(
        text,
        style: style.copyWith(
          fontWeight: fontWeight,
          fontSize: fontSize,
          color: textColor,
        ),
      ),
    ]);
  }
}
