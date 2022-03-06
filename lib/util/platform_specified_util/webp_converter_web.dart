import 'dart:typed_data';

import 'package:cyoap_flutter/util/tuple.dart';
import 'package:cyoap_flutter/util/platform_specified_util/webp_converter.dart';

class WebpConverterImp extends WebpConverter{
  @override
  Future<Tuple<Uint8List, String>> convert(Uint8List input, String name, int width, int height) async{
    return Tuple(input, name);
  }

  @override
  void init() {}

  @override
  WebpConverter getWebpConverterImp(){
    return WebpConverterImp();
  }
}