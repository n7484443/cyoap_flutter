import 'dart:ffi';
import 'dart:io' ;
import 'dart:typed_data';

import 'package:cyoap_flutter/util/platform_specified_util/webp_converter.dart';
import 'package:cyoap_flutter/util/tuple.dart';
import 'package:ffi/ffi.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image/image.dart';

class WebpConverterImp extends WebpConverter {
  @override
  WebpConverter getWebpConverterImp(){
    if(Platform.isWindows){
      return WebpConverterImpWindows();
    }
    return WebpConverterImpAndroid();
  }
}
class WebpConverterImpWindows extends WebpConverter {
  late final DynamicLibrary nativeWebp;
  late final int Function(Pointer<Uint8> rgb, int width, int height, int stride,
      double qualityFactor, Pointer<Pointer<Uint8>> output) webPEncodeRGB;
  late final int Function(Pointer<Uint8> rgb, int width, int height, int stride,
      double qualityFactor, Pointer<Pointer<Uint8>> output) webPEncodeRGBA;
  late final Function(Pointer<Uint8> rgb, int width, int height, int stride,
      Pointer<Pointer<Uint8>> output) webPEncodeLosslessRGB;
  late final Function(Pointer<Uint8> rgb, int width, int height, int stride,
      Pointer<Pointer<Uint8>> output) webPEncodeLosslessRGBA;

  @override
  void init() {
    var startPath = Platform.script.resolve("libwebp.dll").toFilePath();
    // 'windows/libwebp.dll'
    File f = File(startPath);
    if (!f.existsSync()) {
      startPath = "libwebp.dll";
    }
    nativeWebp = DynamicLibrary.open(startPath);

    webPEncodeRGB = nativeWebp.lookupFunction<
        Size Function(
            Pointer<Uint8>, Int, Int, Int, Float, Pointer<Pointer<Uint8>>),
        int Function(
            Pointer<Uint8> rgb,
            int width,
            int height,
            int stride,
            double qualityFactor,
            Pointer<Pointer<Uint8>> output)>('WebPEncodeRGB');
    webPEncodeRGBA = nativeWebp.lookupFunction<
        Size Function(
            Pointer<Uint8>, Int, Int, Int, Float, Pointer<Pointer<Uint8>>),
        int Function(
            Pointer<Uint8> rgb,
            int width,
            int height,
            int stride,
            double qualityFactor,
            Pointer<Pointer<Uint8>> output)>('WebPEncodeRGBA');
    webPEncodeLosslessRGB = nativeWebp.lookupFunction<
        Size Function(Pointer<Uint8>, Int, Int, Int, Pointer<Pointer<Uint8>>),
        int Function(Pointer<Uint8> rgb, int width, int height, int stride,
            Pointer<Pointer<Uint8>> output)>('WebPEncodeLosslessRGB');
    webPEncodeLosslessRGBA = nativeWebp.lookupFunction<
        Size Function(Pointer<Uint8>, Int, Int, Int, Pointer<Pointer<Uint8>>),
        int Function(Pointer<Uint8> rgb, int width, int height, int stride,
            Pointer<Pointer<Uint8>> output)>('WebPEncodeLosslessRGBA');
  }
  final double quality = 90;

  @override
  Future<Tuple<String, Uint8List>> convert(Uint8List input, String name) async {
    Image decodeImage;
    bool isLossless = true;
    if(name.endsWith(".png")){
      decodeImage = PngDecoder().decodeImage(input)!;
      isLossless = true;
    }else if(name.endsWith(".jpg") | name.endsWith(".jpeg")){
      decodeImage = JpegDecoder().decodeImage(input)!;
      isLossless = false;
    }else if(name.endsWith(".bmp")){
      decodeImage = BmpDecoder().decodeImage(input)!;
      isLossless = true;
    }else{
      return Tuple(name, input);
    }
    Pointer<Pointer<Uint8>> outputBuff = calloc.allocate<Pointer<Uint8>>(0);
    Pointer<Uint8> inputBuff;
    Uint8List output;
    int outputSize;
    if(decodeImage.channels == Channels.rgb){
      var inputBuffered = decodeImage.getBytes(format: Format.rgb);
      int size = inputBuffered.length;
      inputBuff = calloc.allocate<Uint8>(size + 1);
      for (int i = 0; i < inputBuffered.length; i++) {
        inputBuff[i] = inputBuffered[i];
      }
      if(isLossless){
        outputSize = webPEncodeLosslessRGB(inputBuff, decodeImage.width,
            decodeImage.height, decodeImage.width * 3, outputBuff);
      }else{
        outputSize = webPEncodeRGB(inputBuff, decodeImage.width,
            decodeImage.height, decodeImage.width * 3, quality, outputBuff);
      }
    }else{//rgba
      var inputBuffered = decodeImage.getBytes(format: Format.rgba);
      int size = inputBuffered.length;
      inputBuff = calloc.allocate<Uint8>(size + 1);
      for (int i = 0; i < inputBuffered.length; i++) {
        inputBuff[i] = inputBuffered[i];
      }
      if(isLossless){
        outputSize = webPEncodeLosslessRGBA(inputBuff, decodeImage.width,
            decodeImage.height, decodeImage.width * 4, outputBuff);
      }else{
        outputSize = webPEncodeRGBA(inputBuff, decodeImage.width,
            decodeImage.height, decodeImage.width * 4, quality, outputBuff);
      }
    }
    if(outputSize == 0)throw 'encoding error!';
    output = outputBuff.value.asTypedList(outputSize);
    calloc.free(inputBuff);
    calloc.free(outputBuff);
    return Tuple(name.replaceAll(RegExp('[.](png|jpg|jpeg|bmp)'), '.webp'), output);
  }
  @override
  bool canConvert() => true;
}
class WebpConverterImpAndroid extends WebpConverter{
  final int quality = 90;
  @override
  Future<Tuple<String, Uint8List>> convert(Uint8List input, String name) async {
    Image decodeImage;
    if (name.endsWith(".png")) {
      decodeImage = PngDecoder().decodeImage(input)!;
    } else if (name.endsWith(".jpg") | name.endsWith(".jpeg")) {
      decodeImage = JpegDecoder().decodeImage(input)!;
    } else if (name.endsWith(".bmp")) {
      decodeImage = BmpDecoder().decodeImage(input)!;
    } else {
      return Tuple(name, input);
    }

    var output = await FlutterImageCompress.compressWithList(
      input,
      format: CompressFormat.webp,
      quality: quality,
      minWidth: decodeImage.width,
      minHeight: decodeImage.height,
    );
    return Tuple(name.replaceAll(RegExp('[.](png|jpg|jpeg|bmp)'), '.webp'), output);
  }

  @override
  void init() {}

  @override
  bool canConvert() => true;
}
