import 'package:cyoap_flutter/model/platform_system.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class PlatformDesignSetting {
  bool titleOverlap = true;
  bool titlePosition = true;
  bool titleOutline = true;
  String titleFont = "notoSans";
  String mainFont = "notoSans";
  Color colorBackground = Colors.white;
  Color colorNode = Colors.white;

  PlatformDesignSetting();

  PlatformDesignSetting.fromJson(Map<String, dynamic> json)
      : titleFont = json['titleFont'] ?? 'notoSans',
        mainFont = json['mainFont'] ?? 'notoSans',
        titleOverlap = json['titleOverlap'] ?? true,
        titlePosition = json['titlePosition'] ?? true,
        titleOutline = json['titleOutline'] ?? true,
        colorBackground =
            (json['colorBackground'] != null && json['colorBackground'] is int)
                ? Color(json['colorBackground'])
                : Colors.white {
    colorNode = (json['colorNode'] != null && json['colorNode'] is int)
        ? Color(json['colorNode'])
        : Colors.white;
  }

  Map<String, dynamic> toJson() => {
        'titleFont': titleFont,
        'mainFont': mainFont,
        'titleOverlap': titleOverlap,
        'titlePosition': titlePosition,
        'titleOutline': titleOutline,
        'colorBackground': colorBackground.value,
        'colorNode': colorNode.value,
      };
}

TextStyle get titleFont =>
    ConstList.getFont(getPlatform.designSetting.titleFont);

TextStyle get mainFont => ConstList.getFont(getPlatform.designSetting.mainFont);
