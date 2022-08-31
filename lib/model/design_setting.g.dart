// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'design_setting.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_PlatformDesignSetting _$$_PlatformDesignSettingFromJson(
        Map<String, dynamic> json) =>
    _$_PlatformDesignSetting(
      titleOverlap: json['titleOverlap'] as bool? ?? true,
      titlePosition: json['titlePosition'] as bool? ?? true,
      titleOutline: json['titleOutline'] as bool? ?? true,
      titleFont: json['titleFont'] as String? ?? "notoSans",
      mainFont: json['mainFont'] as String? ?? "notoSans",
      colorBackground: json['colorBackground'] == null
          ? Colors.white
          : const ColorConverter().fromJson(json['colorBackground'] as int),
      colorNode: json['colorNode'] == null
          ? Colors.white
          : const ColorConverter().fromJson(json['colorNode'] as int),
      colorOutline: json['colorOutline'] == null
          ? Colors.lightBlueAccent
          : const ColorConverter().fromJson(json['colorOutline'] as int),
      colorTitle: json['colorTitle'] == null
          ? Colors.black
          : const ColorConverter().fromJson(json['colorTitle'] as int),
    );

Map<String, dynamic> _$$_PlatformDesignSettingToJson(
        _$_PlatformDesignSetting instance) =>
    <String, dynamic>{
      'titleOverlap': instance.titleOverlap,
      'titlePosition': instance.titlePosition,
      'titleOutline': instance.titleOutline,
      'titleFont': instance.titleFont,
      'mainFont': instance.mainFont,
      'colorBackground':
          const ColorConverter().toJson(instance.colorBackground),
      'colorNode': const ColorConverter().toJson(instance.colorNode),
      'colorOutline': const ColorConverter().toJson(instance.colorOutline),
      'colorTitle': const ColorConverter().toJson(instance.colorTitle),
    };
