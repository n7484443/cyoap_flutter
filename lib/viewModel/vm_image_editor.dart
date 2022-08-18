import 'dart:typed_data';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart' show GlobalKey;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image/image.dart';
import 'package:tuple/tuple.dart';

final globalEditorKeyProvider =
    Provider.autoDispose<GlobalKey<ExtendedImageEditorState>>(
        (ref) => GlobalKey<ExtendedImageEditorState>());

final imageProvider = StateProvider<Tuple2<String, Uint8List>?>((ref) => null);

final cropImageProvider = FutureProvider.autoDispose<Uint8List>((ref) async {
  var state = ref.watch(globalEditorKeyProvider).currentState!;
  var cropRect = state.getCropRect()!;
  var image = decodeImage(ref.watch(imageProvider)!.item2)!;
  var output = copyCrop(image, cropRect.left.toInt(), cropRect.top.toInt(),
      cropRect.width.toInt(), cropRect.height.toInt());
  return PngEncoder().encodeImage(output) as Uint8List;
});

final imageCropRatioProvider = StateProvider<double?>((ref) => null);
final imageCropIndexProvider = StateProvider<int>((ref) => 0);