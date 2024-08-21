import 'package:cyoap_core/design_setting.dart';
import 'package:cyoap_flutter/model/platform_system.dart';
import 'package:cyoap_flutter/viewModel/edit/vm_draggable_nested_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/image_db.dart';

final platformDesignSettingProvider =
    StateProvider.autoDispose<PlatformDesignSetting>((ref) {
  ref.listenSelf((PlatformDesignSetting? previous, PlatformDesignSetting next) {
    if (previous == null || previous == next) return;
    ref
        .read(currentProjectChangedProvider.notifier)
        .changed(needUpdateCode: false);
    getPlatform.designSetting = next;
  });
  return getPlatform.designSetting;
});

final platformDesignSettingImageDecorationProvider =
    Provider.autoDispose<DecorationImage?>((ref) {
  var designSetting = ref.watch(platformDesignSettingProvider);
  if (designSetting.backgroundImage == null) {
    return null;
  }
  if (ImageDB().getImage(designSetting.backgroundImage!) == null) {
    return null;
  }

  BoxFit backgroundBoxFit = BoxFit.contain;
  ImageRepeat backgroundRepeat = ImageRepeat.noRepeat;
  switch (designSetting.backgroundAttribute) {
    case ImageAttribute.fill:
      backgroundBoxFit = BoxFit.cover;
      break;
    case ImageAttribute.fit:
      backgroundBoxFit = BoxFit.contain;
      break;
    case ImageAttribute.pattern:
      backgroundBoxFit = BoxFit.contain;
      backgroundRepeat = ImageRepeat.repeat;
      break;
    case ImageAttribute.stretch:
      backgroundBoxFit = BoxFit.fill;
      break;
  }
  return DecorationImage(
    image:
        Image.memory(ImageDB().getImage(designSetting.backgroundImage!)!).image,
    fit: backgroundBoxFit,
    repeat: backgroundRepeat,
    filterQuality: FilterQuality.high,
  );
});

final colorSelectProvider = StateProvider.autoDispose<int>((ref) => 0);

final backgroundCurrentStateProvider = StateProvider.autoDispose<int>((ref) {
  var backgroundName = ref.watch(platformDesignSettingProvider).backgroundImage;
  if (backgroundName == null) return -1;
  return ImageDB().getImageIndex(backgroundName);
});
