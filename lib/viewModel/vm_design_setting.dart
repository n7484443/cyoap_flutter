import 'package:cyoap_core/design_setting.dart';
import 'package:cyoap_flutter/model/platform_system.dart';
import 'package:cyoap_flutter/viewModel/vm_draggable_nested_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/image_db.dart';

final variableFontProvider = StateProvider.autoDispose<String>((ref) {
  ref.listenSelf((String? previous, String next) {
    getPlatform.designSetting =
        getPlatform.designSetting.copyWith(variableFont: next);
    ref.read(draggableNestedMapChangedProvider.notifier).state = true;
  });
  return getPlatform.designSetting.variableFont;
});
final colorBackgroundProvider = StateProvider.autoDispose<Color>((ref) {
  ref.listenSelf((previous, Color next) {
    getPlatform.designSetting =
        getPlatform.designSetting.copyWith(colorBackground: next.value);
    ref.read(draggableNestedMapChangedProvider.notifier).state = true;
  });
  return Color(getPlatform.designSetting.colorBackground);
});

final colorSelectProvider = StateProvider.autoDispose<int>((ref) => 0);

final backgroundProvider = StateProvider.autoDispose<String?>((ref) {
  ref.listenSelf((previous, next) {
    getPlatform.designSetting =
        getPlatform.designSetting.copyWith(backgroundImage: next);
    ref.read(draggableNestedMapChangedProvider.notifier).state = true;
  });
  return getPlatform.designSetting.backgroundImage;
});
final backgroundCurrentStateProvider = StateProvider.autoDispose<int>((ref) {
  var backgroundName = ref.watch(backgroundProvider);
  if (backgroundName == null) return -1;
  return ImageDB().getImageIndex(backgroundName);
});
final backgroundAttributeProvider =
    StateProvider.autoDispose<ImageAttribute>((ref) {
  ref.listenSelf((previous, ImageAttribute next) {
    getPlatform.designSetting =
        getPlatform.designSetting.copyWith(backgroundAttribute: next);
    ref.read(draggableNestedMapChangedProvider.notifier).state = true;
  });
  return getPlatform.designSetting.backgroundAttribute;
});

final marginVerticalProvider = StateProvider.autoDispose<double>((ref) {
  ref.listenSelf((previous, double next) {
    getPlatform.designSetting =
        getPlatform.designSetting.copyWith(marginVertical: next);
    ref.read(draggableNestedMapChangedProvider.notifier).state = true;
  });
  return getPlatform.designSetting.marginVertical;
});
