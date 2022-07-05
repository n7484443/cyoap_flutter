import 'dart:typed_data';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart' show GlobalKey;
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:image/image.dart';

class VMImageEditor extends GetxController {
  Uint8List? data;

  var globalEditorKey = GlobalKey<ExtendedImageEditorState>();

  Future<Uint8List> cropImage() async {
    var state = globalEditorKey.currentState!;
    var cropRect = state.getCropRect()!;
    var image = decodeImage(data!)!;
    var output = copyCrop(image, cropRect.left.toInt(), cropRect.top.toInt(),
        cropRect.width.toInt(), cropRect.height.toInt());
    data = null;
    return PngEncoder().encodeImage(output) as Uint8List;
  }
}
