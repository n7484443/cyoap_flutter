import 'dart:math';

import 'package:cyoap_core/preset/node_preset.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

extension ColorHelper on ColorOption {
  bool hasGradient() {
    return colorType == ColorType.gradient;
  }

  Gradient? getGradient() {
    if (!hasGradient()) {
      return null;
    }
    switch (gradientType) {
      case GradientType.linear:
        return LinearGradient(
          begin: Alignment(
              gradientData[0].gradientPos.$1, gradientData[0].gradientPos.$2),
          end: Alignment(
              gradientData[1].gradientPos.$1, gradientData[1].gradientPos.$2),
          colors: [Color(gradientData[0].color), Color(gradientData[1].color)],
        );
      case GradientType.radial:
        return RadialGradient(
          center: Alignment(gradientData[0].gradientPos.$1 * 2.0 - 1.0,
              gradientData[0].gradientPos.$2 * 2.0 - 1.0),
          colors: [Color(gradientData[0].color), Color(gradientData[1].color)],
          stops: [
            0.5,
            1.0,
          ],
        );
      case GradientType.sweep:
        return SweepGradient(
          center: Alignment(gradientData[0].gradientPos.$1 * 2.0 - 1.0,
              gradientData[0].gradientPos.$2 * 2.0 - 1.0),
          colors: [
            Color(gradientData[0].color),
            Color(gradientData[1].color),
            Color(gradientData[0].color)
          ],
          stops: [0.0, 0.5, 1.0],
          transform: GradientRotation(-atan2(
                  gradientData[1].gradientPos.$1 - 0.5,
                  gradientData[1].gradientPos.$2 - 0.5) -
              pi / 2.0),
        );
    }
  }

  Color? getColor() {
    if (hasGradient()) {
      return null;
    }
    return Color(color);
  }

  Color getColorIgnoreGradient() {
    return Color(color);
  }

  ColorOption changeGradientColor(int index, Color color) {
    var newList = List<GradientData>.from(gradientData);
    newList[index] = newList[index].copyWith(color: color.value);
    return copyWith(gradientData: newList);
  }

  ColorOption changeGradientPosition(int index, double x, double y) {
    var newList = List<GradientData>.from(gradientData);
    newList[index] = newList[index].copyWith(gradientPos: (x, y));
    return copyWith(gradientData: newList);
  }
}
