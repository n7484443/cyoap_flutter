import 'dart:typed_data';
import 'package:cyoap_flutter/util/tuple.dart';

import 'webp_converter_vm.dart'
    if (dart.library.html) 'webp_converter_web.dart';

abstract class WebpConverter {
  static WebpConverter? instance = WebpConverterImp()..init();

  Future<Tuple<String, Uint8List>> convert(
          Uint8List input, String name) async =>
      throw "doesn't work in this platform";

  void init() {}
  bool canConvert() => false;

  static WebpConverter? getWebpConverterImp() => null;
}

WebpConverter getWebpConverterInstance() {
  return WebpConverter.instance!;
}
