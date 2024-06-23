import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui show Gradient;

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
          begin: Alignment(gradientData[0].gradientPos.$1 * 2 - 1,
              gradientData[0].gradientPos.$2 * 2 - 1),
          end: Alignment(gradientData[1].gradientPos.$1 * 2 - 1,
              gradientData[1].gradientPos.$2 * 2 - 1),
          colors: [Color(gradientData[0].color), Color(gradientData[1].color)],
        );
      case GradientType.radial:
        return CssLikeRadialGradient(
          center: Alignment(gradientData[0].gradientPos.$1 * 2.0 - 1.0,
              gradientData[0].gradientPos.$2 * 2.0 - 1.0),
          colors: [Color(gradientData[0].color), Color(gradientData[1].color)],
          stops: [
            0.0,
            gradientData[1].gradientPos.$1,
          ],
          radius: 1.0,
        );
      case GradientType.sweep:
        var angle = gradientData[1].gradientPos.$1 / 180.0 * pi;
        var pos = gradientData[0].gradientPos;
        return SweepGradient(
          center: Alignment(pos.$1 * 2.0 - 1.0, pos.$2 * 2.0 - 1.0),
          colors: [
            Color(gradientData[0].color),
            Color(gradientData[1].color),
            Color(gradientData[0].color)
          ],
          stops: [0.0, 0.5, 1.0],
          transform: GradientTranslateRotation(angle, Offset(pos.$1, pos.$2)),
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

class GradientTranslateRotation extends GradientRotation {
  const GradientTranslateRotation(super.radians, this.center);
  final Offset center;

  @override
  Matrix4 transform(Rect bounds, {TextDirection? textDirection}) {
    var x = bounds.left + bounds.width * center.dx;
    var y = bounds.top + bounds.height * center.dy;
    return Matrix4.identity()
      ..translate(x, y)
      ..rotateZ(radians)
      ..translate(-x, -y);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is GradientRotation && other.radians == radians;
  }

  @override
  int get hashCode => radians.hashCode * center.hashCode;
}

class CssLikeRadialGradient extends RadialGradient {
  const CssLikeRadialGradient(
      {required super.colors, super.center, super.radius, super.stops});

  List<double> _impliedStops() {
    if (stops != null) {
      return stops!;
    }
    assert(colors.length >= 2, 'colors list must have at least two colors');
    final double separation = 1.0 / (colors.length - 1);
    return List<double>.generate(
      colors.length,
      (int index) => index * separation,
      growable: false,
    );
  }

  Float64List? _resolveTransform(Rect bounds, TextDirection? textDirection) {
    return transform?.transform(bounds, textDirection: textDirection)?.storage;
  }

  @override
  Shader createShader(Rect rect, {TextDirection? textDirection}) {
    return ui.Gradient.radial(
      center.resolve(textDirection).withinRect(rect),
      radius * rect.longestSide,
      colors,
      _impliedStops(),
      tileMode,
      _resolveTransform(rect, textDirection),
      focal?.resolve(textDirection).withinRect(rect),
      focalRadius * rect.longestSide,
    );
  }
}
