import 'dart:core';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';

class PlatformFileSystem {
  final Map<String, Uint8List> _dirImage = {};
  Map<String, String> dirNode = {};
  String? platform;

  PlatformFileSystem(Archive archive) {
    for (final file in archive) {
      if (file.isFile) {
        var fileName = file.name;
        if (fileName.startsWith('images')) {
          _dirImage.putIfAbsent(file.name.split("/")[1], () => file.content);
        }else if (fileName.startsWith('nodes')) {
          var str = String.fromCharCodes(file.content);
          dirNode.putIfAbsent(file.name.split("/")[1], () => str);
        }else if (fileName.endsWith('platform.json')) {
          platform = String.fromCharCodes(file.content);
        }
      }
    }
  }

  Image getImage(String name){
    return Image.memory(_dirImage[name]!);
  }
}
