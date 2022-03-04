import 'dart:typed_data';
import '../util/webp_converter_android.dart'
if(dart.library.html) '../util/webp_converter_web.dart'
if(dart.library.ffi) '../util/webp_converter_windows.dart';

abstract class WebpConverter{
  static WebpConverter? instance;
  WebpConverter getWebpConverter();

  Future<Uint8List> convert(Uint8List input, String type) async => throw "doesn't work in this platform";

  void init() {}
}

WebpConverter getWebpConverterInstance() {
  if(WebpConverter.instance == null){
    WebpConverter.instance = WebpConverterImp();
    WebpConverter.instance!.init();
  }
  return WebpConverter.instance!.getWebpConverter();
}