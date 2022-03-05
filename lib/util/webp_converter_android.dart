import 'dart:typed_data';
import 'package:cyoap_flutter/util/webp_converter.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class WebpConverterImp extends WebpConverter{
  Future<Uint8List> convert(Uint8List input, String type) async {
    var output = await FlutterImageCompress.compressWithList(input,
      format:CompressFormat.webp,
      quality: 100,
      minWidth: 10,
      minHeight: 10,
    );
    return output;
  }

  @override
  void init() {}

  @override
  bool canConvert() => true;
}