import 'dart:typed_data';

import 'package:cyoap_flutter/util/platform_specified_util/webp_converter.dart';
import 'package:image/image.dart';
import 'package:tuple/tuple.dart';

class WebpConverterImp extends WebpConverter {
  @override
  Future<Tuple2<String, Uint8List>> convert(
      Uint8List input, String name) async {
    if (name.endsWith(".bmp")) {
      var image = BmpDecoder().decodeImage(input);
      var output = Uint8List.fromList(PngEncoder().encodeImage(image!));
      return Tuple2(name.replaceAll(RegExp('[.](bmp)'), '.png'), output);
    }
    return Tuple2(name, input);
  }

  @override
  void init() {}
}
