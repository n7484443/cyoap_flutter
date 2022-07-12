import 'package:cyoap_flutter/model/platform_system.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../main.dart';

class PlatformDesignSetting {
  bool titleOverlap = true;
  bool titlePosition = true;
  String titleFont = "notoSans";
  String mainFont = "notoSans";
  Color colorBackground = Colors.white;
  Rx<Color> colorNode = Colors.white.obs;

  PlatformDesignSetting();

  PlatformDesignSetting.fromJson(Map<String, dynamic> json)
      : titleFont = json['titleFont'] ?? 'notoSans',
        mainFont = json['mainFont'] ?? 'notoSans',
        titleOverlap = json['titleOverlap'] ?? true,
        titlePosition = json['titlePosition'] ?? true,
        colorBackground =
            (json['colorBackground'] != null && json['colorBackground'] is int)
                ? Color(json['colorBackground'])
                : Colors.white {
    colorNode.value = (json['colorNode'] != null && json['colorNode'] is int)
        ? Color(json['colorNode'])
        : Colors.white;
  }

  Map<String, dynamic> toJson() => {
        'titleFont': titleFont,
        'mainFont': mainFont,
        'titleOverlap': titleOverlap,
        'titlePosition': titlePosition,
        'colorBackground': colorBackground.value,
        'colorNode': colorNode.value.value,
      };
}

TextStyle get titleFont =>
    ConstList.getFont(getPlatform.designSetting.titleFont);

TextStyle get mainFont => ConstList.getFont(getPlatform.designSetting.mainFont);
