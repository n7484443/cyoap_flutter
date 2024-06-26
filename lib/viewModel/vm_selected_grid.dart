import 'dart:ui';

import 'package:cyoap_core/choiceNode/pos.dart';
import 'package:cyoap_flutter/main.dart';
import 'package:cyoap_flutter/model/platform_system.dart';
import 'package:cyoap_flutter/util/platform_specified_util/platform_specified.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/device_preference.dart';

final selectedchoiceNodeStatusProvider =
    Provider.autoDispose<List<(Pos, int)>>((ref) {
  return getPlatform.selectedPos;
});

void saveAsImage(GlobalKey globalKey) async {
  var renderObject = globalKey.currentContext?.findRenderObject();
  if (renderObject == null) return;
  if (renderObject is! RenderRepaintBoundary) return;
  var image = await (await renderObject.toImage())
      .toByteData(format: ImageByteFormat.png);
  var pngBytes = image?.buffer.asUint8List();
  var name = "result.png";
  if (ConstList.isWeb()) {
    PlatformSpecified().saveProject?.downloadCapture("", name, pngBytes!);
  } else {
    PlatformSpecified().saveProject?.downloadCapture(
        await DevicePreference.getDownloadFolder(), name, pngBytes!);
  }
}
