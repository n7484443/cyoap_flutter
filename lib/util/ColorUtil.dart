import 'package:flutter/material.dart';

extension ColorUtil on Color{
  Color lighten({double amount = .1}){
    var hsl = HSLColor.fromColor(this);
    var hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

    return hslLight.toColor();
  }
  Color darken({double amount = .1}){
    var hsl = HSLColor.fromColor(this);
    var hslLight = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslLight.toColor();
  }
}