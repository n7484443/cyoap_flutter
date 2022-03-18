import 'dart:convert';
import 'dart:typed_data';

import 'package:cyoap_flutter/util/platform_specified_util/webp_converter.dart';
import 'package:cyoap_flutter/util/tuple.dart';

class Base64ToImage {
//   data:image/jpeg;base64,  base64어쩌구
  static Future<Tuple<String, Uint8List>> convertToImage(
      String input, String name) {
    var split = input.split(",");
    var type = split[0];
    var pattern = RegExp(';|/');
    var imageType = type.split(pattern)[1];
    var encode = type.split(pattern)[2];
    print('$name.$imageType');

    Uint8List data = base64.decode(split[1]);
    return getWebpConverterInstance().convert(data, '$name.$imageType');
  }
}
