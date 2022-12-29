import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:cyoap_flutter/util/platform_specified_util/webp_converter.dart';
import 'package:ffi/ffi.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image/image.dart';
import 'package:tuple/tuple.dart';

import '../../main.dart';
import '../../model/opening_file_folder.dart';

class WebpConverterImp extends WebpConverter {
  factory WebpConverterImp() {
    if (ConstList.isDesktop()) {
      return WebpConverterImpWindows();
    }
    return WebpConverterImpAndroid();
  }
}

class WebpConverterImpWindows implements WebpConverterImp {
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
  void init() async {
    saveAsWebp = await ProjectPath().getSaveAsWebp();

    var startPath = Platform.script.resolve("libwebp.dll").toFilePath();
    // 'windows/libwebp.dll'
    File f = File(startPath);
    if (!await f.exists()) {
      startPath = "libwebp.dll";
    }
    nativeWebp = DynamicLibrary.open(startPath);

    webPEncodeRGB = nativeWebp.lookupFunction<
        Uint64 Function(Pointer<Uint8>, Int32, Int32, Int32, Float,
            Pointer<Pointer<Uint8>>),
        int Function(
            Pointer<Uint8> rgb,
            int width,
            int height,
            int stride,
            double qualityFactor,
            Pointer<Pointer<Uint8>> output)>('WebPEncodeRGB');
    webPEncodeRGBA = nativeWebp.lookupFunction<
        Uint64 Function(Pointer<Uint8>, Int32, Int32, Int32, Float,
            Pointer<Pointer<Uint8>>),
        int Function(
            Pointer<Uint8> rgb,
            int width,
            int height,
            int stride,
            double qualityFactor,
            Pointer<Pointer<Uint8>> output)>('WebPEncodeRGBA');
    webPEncodeLosslessRGB = nativeWebp.lookupFunction<
        Uint64 Function(
            Pointer<Uint8>, Int32, Int32, Int32, Pointer<Pointer<Uint8>>),
        int Function(Pointer<Uint8> rgb, int width, int height, int stride,
            Pointer<Pointer<Uint8>> output)>('WebPEncodeLosslessRGB');
    webPEncodeLosslessRGBA = nativeWebp.lookupFunction<
        Uint64 Function(
            Pointer<Uint8>, Int32, Int32, Int32, Pointer<Pointer<Uint8>>),
        int Function(Pointer<Uint8> rgb, int width, int height, int stride,
            Pointer<Pointer<Uint8>> output)>('WebPEncodeLosslessRGBA');
  }

  final double quality = 90;

  @override
  Future<Tuple2<String, Uint8List>> convert(
      Uint8List input, String name) async {
    if (!saveAsWebp) {
      return Tuple2(name, input);
    }
    Image decodedImage;
    bool isLossless = true;
    if (name.endsWith(".png")) {
      decodedImage = decodeImage(input)!;
      isLossless = true;
    } else if (name.endsWith(".jpg") |
        name.endsWith(".jpeg") |
        name.endsWith(".bmp")) {
      decodedImage = decodeImage(input)!;
      isLossless = false;
    } else {
      return Tuple2(name, input);
    }
    Pointer<Pointer<Uint8>> outputBuff = calloc.allocate<Pointer<Uint8>>(0);
    Pointer<Uint8> inputBuff;
    Uint8List output;
    int outputSize;
    if (decodedImage.channels == Channels.rgb) {
      var inputBuffered = decodedImage.getBytes(format: Format.rgb);
      int size = inputBuffered.length;
      inputBuff = calloc.allocate<Uint8>(size);
      for (int i = 0; i < inputBuffered.length; i++) {
        inputBuff[i] = inputBuffered[i];
      }
      if (isLossless) {
        outputSize = webPEncodeLosslessRGB(inputBuff, decodedImage.width,
            decodedImage.height, decodedImage.width * 3, outputBuff);
      } else {
        outputSize = webPEncodeRGB(inputBuff, decodedImage.width,
            decodedImage.height, decodedImage.width * 3, quality, outputBuff);
      }
    } else {
      //rgba
      var inputBuffered = decodedImage.getBytes(format: Format.rgba);
      int size = inputBuffered.length;
      inputBuff = calloc.allocate<Uint8>(size);
      for (int i = 0; i < inputBuffered.length; i++) {
        inputBuff[i] = inputBuffered[i];
      }
      if (isLossless) {
        outputSize = webPEncodeLosslessRGBA(inputBuff, decodedImage.width,
            decodedImage.height, decodedImage.width * 4, outputBuff);
      } else {
        outputSize = webPEncodeRGBA(inputBuff, decodedImage.width,
            decodedImage.height, decodedImage.width * 4, quality, outputBuff);
      }
    }
    if (outputSize == 0) throw 'encoding error!';
    output = outputBuff.value.asTypedList(outputSize);
    calloc.free(inputBuff);
    calloc.free(outputBuff);
    return Tuple2(
        name.replaceAll(RegExp('[.](png|jpg|jpeg|bmp)'), '.webp'), output);
  }

  @override
  bool saveAsWebp = true;

  @override
  bool get canConvert => saveAsWebp;
}

class WebpConverterImpAndroid implements WebpConverterImp {
  final int quality = 80;
  @override
  Future<Tuple2<String, Uint8List>> convert(
      Uint8List input, String name) async {
    if (!saveAsWebp) {
      return Tuple2(name, input);
    }
    Image decodeImage;
    if (name.endsWith(".png")) {
      decodeImage = PngDecoder().decodeImage(input)!;
    } else if (name.endsWith(".jpg") | name.endsWith(".jpeg")) {
      decodeImage = JpegDecoder().decodeImage(input)!;
    } else if (name.endsWith(".bmp")) {
      decodeImage = BmpDecoder().decodeImage(input)!;
    } else {
      return Tuple2(name, input);
    }
    var output = await FlutterImageCompress.compressWithList(
      input,
      format: CompressFormat.webp,
      quality: quality,
      minWidth: decodeImage.width,
      minHeight: decodeImage.height,
    );
    return Tuple2(
        name.replaceAll(RegExp('[.](png|jpg|jpeg|bmp)'), '.webp'), output);
  }

  @override
  void init() async {
    saveAsWebp = await ProjectPath().getSaveAsWebp();
  }

  @override
  bool saveAsWebp = true;

  @override
  bool get canConvert => saveAsWebp;
}
