import 'package:cyoap_flutter/model/platform_system.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class PlatformDesignSetting {
  bool titleOverlap = true;
  bool titlePosition = true;
  String titleFont = "notoSans";
  String mainFont = "notoSans";

  PlatformDesignSetting();

  PlatformDesignSetting.fromJson(Map<String, dynamic> json)
      : titleFont = json['titleFont'] ?? 'notoSans',
        mainFont = json['mainFont'] ?? 'notoSans',
        titleOverlap = json['titleOverlap'] ?? true,
        titlePosition = json['titlePosition'] ?? true;

  Map<String, dynamic> toJson() => {
        'titleFont': titleFont,
        'mainFont': mainFont,
        'titleOverlap': titleOverlap,
        'titlePosition': titlePosition,
      };
}

TextStyle get titleFont =>
    ConstList.getFont(getPlatform.designSetting.titleFont);

TextStyle get mainFont => ConstList.getFont(getPlatform.designSetting.mainFont);
