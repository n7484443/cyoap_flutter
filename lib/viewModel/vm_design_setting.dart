import 'package:cyoap_core/design_setting.dart';
import 'package:cyoap_flutter/model/platform_system.dart';
import 'package:cyoap_flutter/viewModel/vm_draggable_nested_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/image_db.dart';

final platformDesignSettingProvider = StateProvider.autoDispose<PlatformDesignSetting>((ref) {
  ref.listenSelf((PlatformDesignSetting? previous, PlatformDesignSetting next) {
    getPlatform.designSetting = next;
    ref.read(draggableNestedMapChangedProvider.notifier).state = true;
  });
  return getPlatform.designSetting;
});

final colorSelectProvider = StateProvider.autoDispose<int>((ref) => 0);

final backgroundCurrentStateProvider = StateProvider.autoDispose<int>((ref) {
  var backgroundName = ref.watch(platformDesignSettingProvider).backgroundImage;
  if (backgroundName == null) return -1;
  return ImageDB().getImageIndex(backgroundName);
});
