import 'dart:typed_data';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class VMImageEditor extends GetxController {
  Uint8List? data;

  var globalEditorKey = GlobalKey<ExtendedImageEditorState>();

  Future<void> cropImage() async {
    /*final Uint8List fileData = Uint8List.fromList(kIsWeb
        ? (await cropImageDataWithDartLibrary(
        state: globalEditorKey.currentState!))!
        : (await cropImageDataWithNativeLibrary(
    state: globalEditorKey.currentState!))!);*/
  }

}