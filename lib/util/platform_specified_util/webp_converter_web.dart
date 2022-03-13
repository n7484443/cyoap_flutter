import 'dart:typed_data';

import 'package:cyoap_flutter/util/tuple.dart';
import 'package:cyoap_flutter/util/platform_specified_util/webp_converter.dart';
import 'package:image/image.dart';

class WebpConverterImp extends WebpConverter{
  @override
  Future<Tuple<Uint8List, String>> convert(Uint8List input, String name) async{
    if(name.endsWith(".bmp")){
      var image = BmpDecoder().decodeImage(input);
      var output = Uint8List.fromList(PngEncoder().encodeImage(image!));
      return Tuple(output, name.replaceAll(RegExp('[.](bmp)'), '.png'));
    }
    return Tuple(input, name);
  }

  @override
  void init() {}

  @override
  WebpConverter getWebpConverterImp(){
    return WebpConverterImp();
  }
}