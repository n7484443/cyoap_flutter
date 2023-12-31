import 'dart:typed_data';

import 'webp_converter_vm.dart'
    if (dart.library.html) 'webp_converter_web.dart';

abstract class WebpConverter {
  static WebpConverter? instance = WebpConverterImp();

  Future<(String, Uint8List)> convert(Uint8List input, String name) async =>
      throw "doesn't work in this platform";

  void init() async {}
  bool saveAsWebp = false;
  bool get canConvert => false;
  static WebpConverter? getWebpConverterImp() => null;
}

WebpConverter getWebpConverterInstance() {
  return WebpConverter.instance!;
}
