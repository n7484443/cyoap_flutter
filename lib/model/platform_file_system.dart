import 'dart:collection';
import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:cyoap_flutter/model/image_db.dart';
import 'package:cyoap_flutter/model/platform_system.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:tuple/tuple.dart';

import '../main.dart';
import '../util/json_file_parsing.dart';
import '../util/platform_specified_util/platform_specified.dart';
import '../util/platform_specified_util/webp_converter.dart';
import 'abstract_platform.dart';
import 'choiceNode/choice_line.dart';

class PlatformFileSystem {
  AbstractPlatform? platform;

  final Map<String, String> _imageSource = {};
  Map<String, String> get imageSource => _imageSource;

  Image noImage = Image.asset('images/noImage.png');
  bool openAsFile = false;
  bool _isEditable = true;
  bool get isEditable => ConstList.isDistributed ? false : _isEditable;
  set isEditable(bool input) => _isEditable = input;

  PlatformFileSystem();
  /*TODO - page 시스템 개발*/
  Future<void> createFromFolder(String path) async {
    openAsFile = false;
    var dirImages = Directory(path + '/images');
    var dirNodes = Directory(path + '/nodes');
    var platformJson = File(path + '/platform.json');
    var imageSourceJson = File(path + '/imageSource.json');

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
    List<LineSetting> lineSettingList = List.empty(growable: true);
    if (!existNodes) {
      dirNodes.create();
    } else {
      var dirList = await dirNodes.list().toList();
      for (FileSystemEntity f in dirList) {
        if (f is File) {
          var value = await f.readAsString();
          if (f.path.contains('lineSetting_')) {
            lineSettingList.add(LineSetting.fromJson(jsonDecode(value)));
          }
        }
      }
    }

    platform!.addDataAll(lineSettingList);
    platform!.init();
  }

  Future<void> createPlatformList(
      Map<String, String> choiceNodes,
      String imageSource,
      String platformData) async {
    openAsFile = true;

    List<LineSetting> lineSettingList = List.empty(growable: true);

    for (var name in choiceNodes.keys) {
      var data = choiceNodes[name]!;
      var decoded = jsonDecode(data);
      if (name.contains('lineSetting_')) {
        lineSettingList.add(LineSetting.fromJson(decoded));
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

    List<LineSetting> lineSettingList = List.empty(growable: true);
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
                  .add(LineSetting.fromJson(jsonDecode(dataConverted)));
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

  Future<void> createFromJson(String input, String path) async {
    var jsonParser = JsonProjectParser(path);
    platform = await jsonParser.getPlatform(input);
    platform!.init();
  }

  void createFromVoid() {
    openAsFile = true;
    platform = AbstractPlatform.none();
  }

  final regReplace = RegExp(r'[.](png|jpg|jpeg|rawRgba)');
  String convertImageName(String name) {
    return name.replaceAll(regReplace, '.webp');
  }

  Future<Map<String, dynamic>> get saveDataMap async {
    Map<String, String> lineSetting = {};
    for (int i = 0; i < getPlatform().lineSettings.length; i++) {
      var line = getPlatform().lineSettings[i];
      lineSetting['lineSetting_${line.currentPos}.json'] =
          jsonEncode(line.toJson());
    }

    var input = {
      'imageMap': await ImageDB().imageMap,
      'imageSource': getPlatformFileSystem.imageSource,
      'platform': jsonEncode(getPlatform().toJson()),
      'lineSetting': lineSetting,
    };
    return input;
  }

  Future<void> saveAsFile() async {
    await PlatformSpecified().saveProject!.saveZip(
        ConstList.isOnlyFileAccept() ? 'exported.zip' : PlatformSystem().path!,
        await saveDataMap);
  }

  Future<void> saveAsFolder() async {
    await PlatformSpecified().saveProject!.saveRaw(PlatformSystem().path!, await saveDataMap);
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

  Queue<Tuple2<String, Image>> temp = Queue();

  Future<Image> _getImage(String name) async {
    Uint8List? image;
    if (temp.any((element) => element.item1 == name)) {
      var tmp = temp.firstWhere((element) => element.item1 == name);
      temp.remove(tmp);
      temp.add(tmp);
      return tmp.item2;
    } else if (await ImageDB().hasImage(name)) {
      image = await ImageDB().getImage(name);
      if (image != null) {
        var output = Image.memory(
          image,
          filterQuality: FilterQuality.medium,
          isAntiAlias: true,
          fit: BoxFit.scaleDown,
        );
        temp.add(Tuple2(name, output));
        while (temp.length > 30) {
          temp.removeFirst();
        }
        return output;
      }
    }

    return noImage;
  }

  FutureBuilder getImage(String name) {
    return FutureBuilder(
      future: _getImage(name),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData == false) {
          return const SizedBox(
            width: 50,
            height: 50,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return noImage;
        } else {
          return snapshot.data as Image;
        }
      },
    );
  }

  String getImageName(int index) {
    return ImageDB().imageList[index];
  }

  int getImageIndex(String name) {
    return ImageDB().imageList.indexOf(name);
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

  Future<Tuple2<String, Uint8List>> saveCapture(Uint8List input) async {
    return await getWebpConverterInstance().convert(input, 'exported.png');
  }
}
