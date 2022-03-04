import 'dart:ffi';
import 'dart:typed_data';
import 'package:ffi/ffi.dart';
import 'package:image/image.dart';

class WebpConverterWindows {
  final DynamicLibrary nativeWebp = DynamicLibrary.open('windows/libwebp.dll');
  static late WebpConverterWindows instance;
  Future<Uint8List> convert(Uint8List input, String type) async {
    final webPEncodeRGB = nativeWebp.lookupFunction<
        Size Function(
            Pointer<Uint8>, Int, Int, Int, Float, Pointer<Pointer<Uint8>>),
        int Function(
            Pointer<Uint8> rgb,
            int width,
            int height,
            int stride,
            double qualityFactor,
            Pointer<Pointer<Uint8>> output)>('WebPEncodeRGB');
    final webPEncodeLosslessRGB = nativeWebp.lookupFunction<
        Size Function(Pointer<Uint8>, Int, Int, Int, Pointer<Pointer<Uint8>>),
        int Function(Pointer<Uint8> rgb, int width, int height, int stride,
            Pointer<Pointer<Uint8>> output)>('WebPEncodeLosslessRGB');
    Image decodeImage;
    switch(type){
      case "png":
        decodeImage = PngDecoder().decodeImage(input)!;
        break;
      case "jpg":
        decodeImage = JpegDecoder().decodeImage(input)!;
        break;
      default:
        return input;
    }

    var inputBuff = calloc.allocate<Uint8>(decodeImage.width * decodeImage.height * 3);
    var inputBuffered = decodeImage.getBytes(format: Format.rgb);
    for(int i = 0; i < decodeImage.width * decodeImage.height * 3; i++){
      inputBuff[i] = inputBuffered[i];
    }
    Pointer<Pointer<Uint8>> outputBuff = calloc.allocate<Pointer<Uint8>>(0);

    var outputSize = webPEncodeLosslessRGB(inputBuff, decodeImage.width, decodeImage.height, decodeImage.width*3, outputBuff);
    Uint8List output = outputBuff.value.asTypedList(outputSize);
    malloc.free(inputBuff);
    malloc.free(outputBuff);
    return output;
  }
}
