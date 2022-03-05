import 'dart:typed_data';
import 'package:cyoap_flutter/util/webp_converter.dart';
import 'package:image_compression_flutter/image_compression_flutter.dart';

class WebpConverterImp extends WebpConverter{
  Configuration config = const Configuration(
    outputType: ImageOutputType.webpThenPng,
    quality: 100,
  );
  Future<Uint8List> convert(Uint8List input, String type) async {
    ImageFile inputImage = ImageFile(rawBytes: input, filePath: 'exported.$type');
    final param = ImageFileConfiguration(input: inputImage, config: config);
    final output = await compressor.compress(param);
    return output.rawBytes;
  }

  @override
  void init() {}

  @override
  bool canConvert() => true;
}