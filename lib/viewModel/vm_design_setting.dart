import 'dart:ui';

import 'package:cyoap_flutter/model/platform_system.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final mainFontProvider = StateProvider.autoDispose<String>(
    (ref) => getPlatform.designSetting.mainFont);
final titleFontProvider = StateProvider.autoDispose<String>(
    (ref) => getPlatform.designSetting.titleFont);
final titlePositionProvider = StateProvider.autoDispose<bool>(
    (ref) => getPlatform.designSetting.titlePosition);
final titleOverlapProvider = StateProvider.autoDispose<bool>(
    (ref) => getPlatform.designSetting.titleOverlap);
final titleOutlineProvider = StateProvider.autoDispose<bool>(
    (ref) => getPlatform.designSetting.titleOutline);
final colorNodeProvider = StateProvider.autoDispose<Color>(
    (ref) => getPlatform.designSetting.colorNode);
final colorBackgroundProvider = StateProvider.autoDispose<Color>(
    (ref) => getPlatform.designSetting.colorBackground);
final colorOutlineProvider = StateProvider.autoDispose<Color>(
        (ref) => getPlatform.designSetting.colorOutline);
final colorSelectProvider = StateProvider.autoDispose<int>(
        (ref) => 0);
