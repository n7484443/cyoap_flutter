import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'design_setting.freezed.dart';
part 'design_setting.g.dart';

@freezed
class PlatformDesignSetting with _$PlatformDesignSetting {
  @JsonSerializable(explicitToJson: true, converters: [ColorConverter()])
  factory PlatformDesignSetting({
    @Default(true) bool titleOverlap,
    @Default(true) bool titlePosition,
    @Default(true) bool titleOutline,
    @Default("notoSans") String titleFont,
    @Default("notoSans") String mainFont,
    @Default(Colors.white) Color colorBackground,
    @Default(Colors.white) Color colorNode,
    @Default(Colors.lightBlueAccent) Color colorOutline,
    @Default(Colors.black) Color colorTitle,
  }) = _PlatformDesignSetting;

  factory PlatformDesignSetting.fromJson(Map<String, dynamic> json) =>
      _$PlatformDesignSettingFromJson(json);
}

class ColorConverter implements JsonConverter<Color, int> {
  const ColorConverter();
  @override
  Color fromJson(int json) => Color(json);

  @override
  int toJson(Color color) => color.value;
}
