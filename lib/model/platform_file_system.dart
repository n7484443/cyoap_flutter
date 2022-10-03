import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:cyoap_core/choiceNode/choice_line.dart';
import 'package:cyoap_flutter/model/image_db.dart';
import 'package:cyoap_flutter/model/opening_file_folder.dart';
import 'package:cyoap_flutter/model/platform_system.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';

import '../main.dart';
import '../util/json_file_parsing.dart';
import '../util/platform_specified_util/platform_specified.dart';
import 'platform.dart';

class PlatformFileSystem {
  AbstractPlatform? platform;

  final Map<String, String> _imageSource = {};

  Map<String, String> get imageSource => _imageSource;

  bool openAsFile = false;
  bool isEditable = true;

  String? path;

  PlatformFileSystem();

  /*TODO - page 시스템 개발*/
  Future<void> createFromFolder(String path) async {
    openAsFile = false;
    var dirImages = Directory('$path/images');
    var dirNodes = Directory('$path/nodes');
    var platformJson = File('$path/platform.json');
    var imageSourceJson = File('$path/imageSource.json');

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
            ImageDB().uploadImagesFuture(name, f.readAsBytes());
          } else {
            //지원 아직 x
          }
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

    var existImageSource = await imageSourceJson.exists();
    if (existImageSource) {
      var data = await imageSourceJson.readAsString();
      if (data.isNotEmpty) {
        var map = jsonDecode(data) as Map;
        for (var source in map.keys) {
          _imageSource[source] = map[source];
        }
      }
    }

    var existNodes = await dirNodes.exists();
    List<ChoiceLine> lineSettingList = List.empty(growable: true);
    if (!existNodes) {
      dirNodes.create();
    } else {
      var dirList = await dirNodes.list().toList();
      for (FileSystemEntity f in dirList) {
        if (f is File) {
          var value = await f.readAsString();
          if (f.path.contains('lineSetting_')) {
            lineSettingList.add(ChoiceLine.fromJson(jsonDecode(value)));
          }
        }
      }
    }

    platform!.addDataAll(lineSettingList);
    platform!.init();
  }

  Future<void> createPlatformList(Map<String, String> choiceNodes,
      String imageSource, String platformData) async {
    openAsFile = true;

    List<ChoiceLine> lineSettingList = List.empty(growable: true);

    for (var name in choiceNodes.keys) {
      var data = choiceNodes[name]!;
      var decoded = jsonDecode(data);
      if (name.contains('lineSetting_')) {
        lineSettingList.add(ChoiceLine.fromJson(decoded));
      }
    }
    Map map = jsonDecode(imageSource);
    for (var source in map.keys) {
      _imageSource[source] = map[source];
    }

    platform = AbstractPlatform.fromJson(jsonDecode(platformData));

    platform!.addDataAll(lineSettingList);
    platform!.init();
  }

  Future<void> createFromZip(Archive archive) async {
    openAsFile = true;
    String? platformJson;

    List<ChoiceLine> lineSettingList = List.empty(growable: true);
    for (var file in archive) {
      Uint8List data = file.content as Uint8List;

      if (file.isFile) {
        var fileName = file.name;
        if (fileName.startsWith('images')) {
          int type = isImageFile(fileName);
          if (type == 1) {
            ImageDB().uploadImages(fileName.split("/")[1], data);
          } else {
            //아직 지원 x
          }
        } else {
          String dataConverted = utf8.decode(data);
          if (fileName.startsWith('nodes')) {
            if (fileName.contains('lineSetting_')) {
              lineSettingList
                  .add(ChoiceLine.fromJson(jsonDecode(dataConverted)));
            }
          } else if (fileName.endsWith('platform.json')) {
            platformJson = dataConverted;
          } else if (fileName.endsWith('imageSource.json')) {
            Map map = jsonDecode(dataConverted);
            for (var source in map.keys) {
              _imageSource[source] = map[source];
            }
          }
        }
      }
    }
    if (platformJson != null) {
      platform = AbstractPlatform.fromJson(jsonDecode(platformJson));
    } else {
      platform = AbstractPlatform.none();
    }

    platform!.addDataAll(lineSettingList);
    platform!.init();

    archive.clear();
  }

  Future<void> createFromJson(String input, Ref ref) async {
    var jsonParser = JsonProjectParser(path!);
    var output = await jsonParser.getPlatform(input, ref);
    for(var key in output.item2.keys){
      ImageDB().uploadImages(key, output.item2[key]!);
    }
    platform = output.item1;
    platform!.init();
  }

  void createFromVoid() {
    openAsFile = true;
    platform = AbstractPlatform.none();
  }

  Future<Map<String, dynamic>> get saveDataMap async {
    Map<String, String> lineSetting = {};
    for (int i = 0; i < getPlatform.lineSettings.length; i++) {
      var line = getPlatform.lineSettings[i];
      lineSetting['lineSetting_${line.currentPos}.json'] =
          jsonEncode(line.toJson());
    }

    var input = {
      'imageMap': await ImageDB().imageMap,
      'imageSource': getPlatformFileSystem.imageSource,
      'platform': jsonEncode(getPlatform.toJson()),
      'lineSetting': lineSetting,
    };
    return input;
  }

  Future<void> save(bool asFile) async {
    var data = await saveDataMap;
    if (asFile) {
      if (ConstList.isWeb()) {
        await PlatformSpecified().saveProject!.saveZip('exported.zip', data);
      } else if (ConstList.isMobile()) {
        await PlatformSpecified()
            .saveProject!
            .saveZip(await ProjectPath.getDownloadFolder(), data);
      } else {
        await PlatformSpecified().saveProject!.saveZip(path!, data);
      }
    } else {
      await PlatformSpecified().saveProject!.saveRaw(path!, data);
    }
  }

  final regCheckImage = RegExp(r'[.](webp|png|jpg|jpeg|bmp|gif)$');

  //1 = 일반 이미지, 0 = 웹 이미지, -1 = 이미지 아님.
  int isImageFile(String path) {
    var name = basename(path).toLowerCase();
    if (name.startsWith('http')) {
      return 0;
    }
    if (regCheckImage.hasMatch(name)) {
      return 1;
    }
    return -1;
  }

  void addSource(String image, String source) {
    _imageSource[image] = source;
  }

  String? getSource(String image) {
    return _imageSource[image];
  }

  bool hasSource(String image) {
    return _imageSource[image]?.isNotEmpty ?? false;
  }
}
