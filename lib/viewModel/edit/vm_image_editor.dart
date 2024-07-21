import 'dart:typed_data';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image/image.dart';

final globalEditorKeyProvider =
    Provider.autoDispose<GlobalKey<ExtendedImageEditorState>>(
        (ref) => GlobalKey<ExtendedImageEditorState>());

final imageProvider = StateProvider<(String, Uint8List)?>((ref) => null);

final cropImageProvider = FutureProvider.autoDispose<Uint8List>((ref) async {
  var state = ref.watch(globalEditorKeyProvider).currentState!;
  var cropRect = state.getCropRect()!;
  var image = decodeImage(ref.watch(imageProvider)!.$2)!;
  var output = copyCrop(image,
      x: cropRect.left.toInt(),
      y: cropRect.top.toInt(),
      width: cropRect.width.toInt(),
      height: cropRect.height.toInt());
  return encodePng(output, singleFrame: image.numFrames == 1);
});

final imageCropRatioProvider =
    StateProvider<(double?, double?)?>((ref) => null);
final imageCropIndexProvider = StateProvider<int>((ref) => 0);

final textFieldWidthRatioProvider =
    StateProvider.autoDispose<TextEditingController>((ref) {
  var controller = TextEditingController();
  ref.onDispose(() {
    controller.dispose();
  });
  controller.addListener(() {
    var w = double.tryParse(controller.text);
    var h = ref.read(imageCropRatioProvider)?.$2;
    ref.read(imageCropRatioProvider.notifier).state = (w, h);
  });
  return controller;
});

final textFieldHeightRatioProvider =
    StateProvider.autoDispose<TextEditingController>((ref) {
  var controller = TextEditingController();
  ref.onDispose(() {
    controller.dispose();
  });
  controller.addListener(() {
    var w = ref.read(imageCropRatioProvider)?.$1;
    var h = double.tryParse(controller.text);
    ref.read(imageCropRatioProvider.notifier).state = (w, h);
  });
  return controller;
});
