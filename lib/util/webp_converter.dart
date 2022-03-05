import 'dart:typed_data';
import '../util/webp_converter_vm.dart'
if(dart.library.html) '../util/webp_converter_web.dart';

abstract class WebpConverter{
  static WebpConverter? instance;

  Future<Uint8List> convert(Uint8List input, String type, int width, int height) async => throw "doesn't work in this platform";

  void init() {}
  bool canConvert() => false;

  WebpConverter? getWebpConverterImp() => null;
}

WebpConverter getWebpConverterInstance() {
  if(WebpConverter.instance == null){
    WebpConverter.instance = WebpConverterImp();
    WebpConverter.instance = WebpConverter.instance!.getWebpConverterImp();
    WebpConverter.instance!.init();
  }
  return WebpConverter.instance!;
}