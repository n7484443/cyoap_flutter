import 'dart:typed_data';

import 'package:cyoap_flutter/util/platform_specified_util/platform_specified.dart';
import 'package:image/image.dart';

class WebpConverterImp extends WebpConverter {
  @override
  Future<(String, Uint8List)> convert(Uint8List input, String name) async {
    if (name.endsWith(".bmp")) {
      var image = BmpDecoder().decode(input);
      var output = Uint8List.fromList(PngEncoder().encode(image!));
      return (name.replaceAll(RegExp('[.](bmp)'), '.png'), output);
    }
    return (name, input);
  }

  @override
  void init() async {}

  @override
  bool get canConvert => false;
}
