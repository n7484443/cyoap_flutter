import 'dart:typed_data';

import 'package:cyoap_flutter/util/webp_converter.dart';
import 'package:js/js.dart';

class WebpConverterImp extends WebpConverter{
  Future<Uint8List> convert(Uint8List input, String type) async{

    return input;
  }

  @override
  void init() {}
}

@JS()
external Uint8List _convertToWebp(Uint8List data);