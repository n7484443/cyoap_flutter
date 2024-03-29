import 'dart:convert';
import 'dart:typed_data';

import 'package:cyoap_flutter/util/platform_specified_util/webp_converter.dart';

class Base64ToImage {
//   data:image/jpeg;base64,  base64blah blah blah
  static final RegExp pattern = RegExp(';|/');
  static Future<(String, Uint8List)?> convertToImage(String input) async {
    var split = input.split(",");
    if (split.length != 2) {
      return null;
    }
    var type = split[0].split(pattern);
    var imageType = type[1];

    Uint8List data = base64.decode(split[1]);
    getWebpConverterInstance().saveAsWebp = false;
    return await getWebpConverterInstance().convert(data, imageType);
  }
}
