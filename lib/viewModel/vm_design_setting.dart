import 'dart:ui';

import 'package:cyoap_flutter/model/platform_system.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final mainFontProvider = StateProvider.autoDispose<String>(
    (ref) => getPlatform.designSetting.mainFont);
final titleFontProvider = StateProvider.autoDispose<String>(
    (ref) => getPlatform.designSetting.titleFont);
final variableFontProvider = StateProvider.autoDispose<String>(
    (ref) => getPlatform.designSetting.variableFont);
final titlePositionProvider = StateProvider.autoDispose<bool>(
    (ref) => getPlatform.designSetting.titlePosition);
final titleOutlineProvider = StateProvider.autoDispose<bool>(
    (ref) => getPlatform.designSetting.titleOutline);
final colorNodeProvider = StateProvider.autoDispose<Color>(
    (ref) => Color(getPlatform.designSetting.colorNode));
final colorBackgroundProvider = StateProvider.autoDispose<Color>(
    (ref) => Color(getPlatform.designSetting.colorBackground));
final colorOutlineProvider = StateProvider.autoDispose<Color>(
    (ref) => Color(getPlatform.designSetting.colorOutline));
final colorTitleProvider = StateProvider.autoDispose<Color>(
    (ref) => Color(getPlatform.designSetting.colorTitle));
final colorSelectProvider = StateProvider.autoDispose<int>((ref) => 0);
