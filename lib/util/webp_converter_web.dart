import 'dart:typed_data';

import 'package:cyoap_flutter/util/webp_converter.dart';
import 'package:js/js.dart';

class WebpConverterImp extends WebpConverter{
  @override
  Future<Uint8List> convert(Uint8List input, String type, int width, int height) async{
    return input;
  }

  @override
  void init() {}

  @override
  WebpConverter getWebpConverterImp(){
    return WebpConverterImp();
  }
}

@JS()
external Uint8List _convertToWebp(Uint8List data);