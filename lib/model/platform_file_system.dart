import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';

import 'abstract_platform.dart';

//platformFileSystem - abstractPlatform
class PlatformFileSystem {
  late AbstractPlatform platform;
  final Map<String, Uint8List> _dirImage = {};
  final Map<String, Image> _dirImageNetwork = {};
  Map<String, String> dirNode = {};
  Image noImage = Image.asset('images/noImage.png');

  PlatformFileSystem();

  Future<void> createFromFolder(String path) async {
    var dirImages = Directory(path + '/images');
    var dirNodes = Directory(path + '/nodes');
    var platformJson = File(path + '/platform.json');

    var existImages = await dirImages.exists();
    if (!existImages) {
      dirImages.create();
    } else {
      var dirList = await dirImages.list().toList();
      for (FileSystemEntity f in dirList) {
        var name = basename(f.path);
        var type = isImageFile(name);
        if (f is File && type != -1) {
          if (type == 1) {
            _dirImageNetwork.putIfAbsent(name, () => Image.file(f));
          } else {
            var value = await f.readAsString();
            _dirImageNetwork.putIfAbsent(name, () => Image.network(value));
          }
        }
      }
    }
    var existNodes = await dirNodes.exists();
    if (!existNodes) {
      dirNodes.create();
    } else {
      var dirList = await dirNodes.list().toList();
      for (FileSystemEntity f in dirList) {
        var name = basename(f.path);
        if (f is File) {
          var value = await f.readAsString();
          dirNode.putIfAbsent(name, () => value);
        }
      }
    }
    var existJson = await platformJson.exists();
    if (existJson) {
      var data = await platformJson.readAsString();
      if (data.isNotEmpty) {
        platform = AbstractPlatform.fromJson(jsonDecode(data));
      } else {
        platform = AbstractPlatform.none();
      }
    } else {
      platform = AbstractPlatform.none();
    }
  }

  void createFromZip(Archive archive) {
    String? platformJson;

    for (var file in archive) {
      Uint8List data = file.content as Uint8List;
      if (file.isFile) {
        var fileName = file.name;
        if (fileName.startsWith('images')) {
          var realName = file.name.split("/")[1];
          int type = isImageFile(fileName);
          if (type == 0) {
            _dirImageNetwork.putIfAbsent(
                realName, () => Image.network(String.fromCharCodes(data)));
          } else if (type == 1) {
            _dirImage.putIfAbsent(realName, () => data);
          }
        } else if (fileName.startsWith('nodes')) {
          dirNode.putIfAbsent(
              file.name.split("/")[1], () => String.fromCharCodes(data));
        } else if (fileName.endsWith('platform.json')) {
          platformJson = String.fromCharCodes(data);
        }
      }
    }
    if (platformJson != null) {
      platform = AbstractPlatform.fromJson(jsonDecode(platformJson));
    } else {
      platform = AbstractPlatform.none();
    }
  }

  //1 = 일반 이미지, 0 = 웹 이미지, -1 = 이미지 아님.
  int isImageFile(String path) {
    var name = basename(path).toLowerCase();
    if (name.startsWith('http')) {
      return 0;
    }
    if (name.endsWith('.webp')) {
      return 1;
    }
    if (name.endsWith('.png')) {
      return 1;
    }
    if (name.endsWith('.jpg')) {
      return 1;
    }
    if (name.endsWith('.bmp')) {
      return 1;
    }
    if (name.endsWith('.gif')) {
      return 1;
    }
    return -1;
  }

  Image getImage(String name) {
    if (_dirImage[name] != null) {
      return Image.memory(_dirImage[name]!);
    } else if (_dirImageNetwork[name] != null) {
      return _dirImageNetwork[name]!;
    } else {
      return noImage;
    }
  }
}
