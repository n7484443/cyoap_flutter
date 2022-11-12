import 'dart:ui';

import 'package:cyoap_core/design_setting.dart';
import 'package:cyoap_flutter/model/platform_system.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/image_db.dart';

final mainFontProvider = StateProvider.autoDispose<String>(
    (ref) => getPlatform.designSetting.mainFont);
final titleFontProvider = StateProvider.autoDispose<String>(
    (ref) => getPlatform.designSetting.titleFont);
final variableFontProvider = StateProvider.autoDispose<String>(
    (ref) => getPlatform.designSetting.variableFont);
final titlePositionProvider = StateProvider.autoDispose<bool>(
    (ref) => getPlatform.designSetting.titlePosition);
final colorNodeProvider = StateProvider.autoDispose<Color>(
    (ref) => Color(getPlatform.designSetting.colorNode));
final colorBackgroundProvider = StateProvider.autoDispose<Color>(
    (ref) => Color(getPlatform.designSetting.colorBackground));
final colorOutlineProvider = StateProvider.autoDispose<Color>(
    (ref) => Color(getPlatform.designSetting.colorOutline));
final colorTitleProvider = StateProvider.autoDispose<Color>(
    (ref) => Color(getPlatform.designSetting.colorTitle));
final colorSelectProvider = StateProvider.autoDispose<int>((ref) => 0);

final backgroundProvider = StateProvider.autoDispose<String?>(
        (ref) => getPlatform.designSetting.backgroundImage);
final backgroundCurrentStateProvider = StateProvider.autoDispose<int>((ref){
  var backgroundName = ref.watch(backgroundProvider);
  if(backgroundName == null) return -1;
  return ImageDB().getImageIndex(backgroundName);
});
final backgroundAttributeProvider = StateProvider.autoDispose<ImageAttribute>((ref) => getPlatform.designSetting.backgroundAttribute);

final marginVerticalProvider = StateProvider.autoDispose<double>((ref) => getPlatform.designSetting.marginVertical);
