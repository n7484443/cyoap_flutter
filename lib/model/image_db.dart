import 'dart:typed_data';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class ImageDB {
  static final ImageDB _instance = ImageDB._init();

  factory ImageDB() {
    return _instance;
  }

  ImageDB._init();

  final Map<String, Uint8List?> _dirImageUint8Map = {};
  final Map<String, Size> _dirImageSizeMap = {};

  List<String> get imageList => _dirImageUint8Map.keys.toList();

  Future<Map<String, String>> get imageMap async {
    Map<String, String> output = {};
    for (var key in _dirImageUint8Map.keys) {
      output[key] = getImageAsString(key) ?? "";
    }
    return output;
  }

  Future<void> uploadImages(String name, Uint8List data) async {
    if (_dirImageUint8Map.containsKey(name)) {
      return;
    }
    _dirImageUint8Map[name] = data;
  }

  Future<void> uploadImagesFuture(String name, Future<Uint8List> data) async {
    if (_dirImageUint8Map.containsKey(name)) {
      return;
    }
    _dirImageUint8Map[name] = null;
    data.then((value) async {
      _dirImageUint8Map[name] = value;
    });
  }

  Uint8List? _getImage(String name){
    return _dirImageUint8Map[name];
  }

  String? getImageAsString(String name){
    return String.fromCharCodes(_getImage(name)!);
  }

  String getImageName(int index) {
    if (index == -1) {
      return "";
    }
    if (ImageDB().imageList.length <= index) {
      return "";
    }
    return ImageDB().imageList[index];
  }

  int getImageIndex(String name) {
    return ImageDB().imageList.indexOf(name);
  }

  void clearImageCache() {
    _dirImageUint8Map.clear();
  }

  Image noImage = Image.asset('images/noImage.png');

  Future<void> removeImage(String name) async {
    _dirImageUint8Map.remove(name);
  }

  Size getSize(String name) {
    return _dirImageSizeMap[name] ?? const Size(100, 100);
  }

  void setSize(String name, Size size) {
    _dirImageSizeMap[name] = size;
  }

  Widget getImage(String name) {
    Uint8List? image = _getImage(name);
    if (image != null) {
      var output = ExtendedImage.memory(
        image,
        filterQuality: FilterQuality.high,
        isAntiAlias: true,
        fit: BoxFit.scaleDown,
        afterPaintImage: (canvas, rect, image, paint){
          setSize(name, rect.size);
        },
      );
      return output;
    }
    return noImage;
  }

  bool contains(String name) {
    return imageList.contains(name.trim());
  }
}
