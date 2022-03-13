import 'dart:collection';
import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:cyoap_flutter/model/image_db.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

import '../util/json_file_parsing.dart';
import '../util/platform_specified_util/webp_converter.dart';
import '../util/tuple.dart';
import 'abstract_platform.dart';
import 'choiceNode/choice_node.dart';
import 'choiceNode/line_setting.dart';
import 'package:cyoap_flutter/util/platform_specified_util/save_non_js.dart'
if(dart.library.js) 'package:cyoap_flutter/util/platform_specified_util/save_js.dart';

class PlatformFileSystem {
  late AbstractPlatform platform;

  final Map<String, String> _imageSource = {};
  Map<String, String> get imageSource => _imageSource;

  Image noImage = Image.asset('asset/images/noImage.png');
  bool openAsFile = false;

  PlatformFileSystem();

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
            var bytes = await f.readAsBytes();
            ImageDB.instance.uploadImages(name, bytes);
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
        for(var source in map.keys){
          _imageSource[source] = map[source];
        }
      }
    }

    var existNodes = await dirNodes.exists();
    List<ChoiceNodeBase> nodeList = List.empty(growable: true);
    if (!existNodes) {
      dirNodes.create();
    } else {
      var dirList = await dirNodes.list().toList();
      for (FileSystemEntity f in dirList) {
        if (f is File) {
          var value = await f.readAsString();
          if(f.path.contains('lineSetting_')){
            var lineSetting = LineSetting.fromJson(jsonDecode(value));
            platform.addLineSettingData(lineSetting);
          }else{
            var node = ChoiceNodeBase.fromJson(jsonDecode(value));
            nodeList.add(node);
          }
        }
      }
    }

    platform.addDataAll(nodeList);
    platform.init();
  }

  Future<void> createFromZip(Archive archive) async{
    openAsFile = true;
    String? platformJson;

    List<ChoiceNodeBase> nodeList = List.empty(growable: true);
    List<LineSetting> lineSettingList = List.empty(growable: true);
    for (var file in archive) {
      Uint8List data = file.content as Uint8List;

      if (file.isFile) {
        var fileName = file.name;
        if (fileName.startsWith('images')) {
          int type = isImageFile(fileName);
          if (type == 1) {
            ImageDB.instance.uploadImages(fileName.split("/")[1], data);
          } else {
            //아직 지원 x
          }
        } else {
          String dataConverted = utf8.decode(data);
          if (fileName.startsWith('nodes')) {
            if (fileName.contains('lineSetting_')) {
              lineSettingList
                  .add(LineSetting.fromJson(jsonDecode(dataConverted)));
            } else {
              nodeList.add(ChoiceNodeBase.fromJson(jsonDecode(dataConverted)));
            }
          } else if (fileName.endsWith('platform.json')) {
            platformJson = dataConverted;
          } else if (fileName.endsWith('imageSource.json')) {
            Map map = jsonDecode(dataConverted);
            for(var source in map.keys){
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

    platform.addDataAll(nodeList);
    for(var lineSetting in lineSettingList){
      platform.addLineSettingData(lineSetting);
    }
    platform.init();
  }

  Future<void> createFromJson(String input, String path) async{
    var jsonParser = JsonProjectParser(path);
    platform = await jsonParser.getPlatform(input);
    platform.init();
  }

  void createFromVoid() {
    openAsFile = true;
    platform = AbstractPlatform.none();
  }

  Future<Tuple<Uint8List, String>> convertImage(String name, Uint8List data) async{
    return await getWebpConverterInstance().convert(data, name);
  }

  String convertImageName(String name){
    return name.replaceAll(RegExp('[.](png|jpg|jpeg|rawRgba)'), '.webp');
  }

  Future<void> saveToFolder(String path) async {
    var dirImages = Directory(path + '/images');
    var dirNodes = Directory(path + '/nodes');
    var dirNodesBackUp = Directory(path + '/nodes_backup');
    var platformJson = File(path + '/platform.json');
    var imageSourceJson = File(path + '/imageSource.json');

    List<String> skipImage = List.empty(growable: true);
    if (dirImages.existsSync()) {
      for (var existImage in await dirImages.list().toList()) {
        var name = basename(existImage.path);
        if (!await ImageDB.instance.hasImage(name)) {
          await existImage.delete();
        }else{
          skipImage.add(name);
        }
      }
    }else{
      dirImages.create();
    }
    for(var imageName in ImageDB.instance.imageList) {
      if (skipImage.contains(imageName)) {
        continue;
      }
      var image = await ImageDB.instance.getImage(imageName);
      var converted = await convertImage(imageName, image!);
      var file = File('$path/images/${converted.data2}');
      file.createSync();
      file.writeAsBytes(converted.data1);
    }

    if(dirNodesBackUp.existsSync()) {
      dirNodesBackUp.deleteSync(recursive: true);
    }

    for(var x = 0; x < platform.choiceNodes.length; x++){
      var tuple = platform.choiceNodes[x];
      var file = File('$path/nodes_backup/lineSetting_${tuple.data2.y}.json');
      file.createSync(recursive: true);
      file.writeAsString(jsonEncode(tuple.data2.toJson()));

      for (var node in tuple.data1) {
        var file = File('$path/nodes_backup/node_${node.y}_${node.x}.json');
        file.createSync(recursive: true);
        file.writeAsString(jsonEncode(node.toJson()));
      }
    }

    if(dirNodes.existsSync()) {
      dirNodes.deleteSync(recursive: true);
    }

    for(var x = 0; x < platform.choiceNodes.length; x++){
      var tuple = platform.choiceNodes[x];
      var file = File('$path/nodes/lineSetting_${tuple.data2.y}.json');
      file.createSync(recursive: true);
      file.writeAsString(jsonEncode(tuple.data2.toJson()));

      for (var node in tuple.data1) {
        var file = File('$path/nodes/node_${node.y}_${node.x}.json');
        file.createSync(recursive: true);
        file.writeAsString(jsonEncode(node.toJson()));
      }
    }


    if (platformJson.existsSync()) {
      platformJson.deleteSync(recursive: true);
    }
    platformJson.create();
    platformJson.writeAsString(jsonEncode(platform.toJson()));

    if (imageSourceJson.existsSync()) {
      imageSourceJson.deleteSync(recursive: true);
    }
    imageSourceJson.create();
    var map = {};
    for(var name in _imageSource.keys){
      map[convertImageName(name)] = _imageSource[name];
    }
    imageSourceJson.writeAsString(jsonEncode(map));
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

  Queue<Tuple<String, Uint8List>> temp = Queue();

  Future<Image> _getImage(String name) async{
    Uint8List? image;
    if(temp.any((element) => element.data1 == name)){
      var tmp = temp.firstWhere((element) => element.data1 == name);
      image = tmp.data2;
    }else if (await ImageDB.instance.hasImage(name)) {
      image = await ImageDB.instance.getImage(name);
      if(image != null){
        temp.addFirst(Tuple(name, image));
        while(temp.length > 10){
          temp.removeLast();
        }
      }
    }

    if(image != null){
      return Image.memory(
        image,
        filterQuality: FilterQuality.medium,
        isAntiAlias: true,
      );
    }else {
      return noImage;
    }
  }

  FutureBuilder getImage(String name){
    return FutureBuilder(
      future: _getImage(name),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(snapshot.hasData == false){
          return const CircularProgressIndicator();
        }else if(snapshot.hasError){
          return noImage;
        }else{
          return snapshot.data as Image;
        }
      },
    );
  }

  String getImageName(int index){
    return ImageDB.instance.imageList[index];
  }

  int getImageIndex(String name) {
    return ImageDB.instance.imageList.indexOf(name);
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

  Future<void> saveCapture(Map<String, dynamic> map) async{
    var input = Uint8List.fromList(map['uint8list'].codeUnits);

    var converted = await convertImage('exported.png', input);
    if(map['isOnlyFileAccept']) {
      await downloadCapture(converted.data2, converted.data1);
    }else{
      await downloadCapture('${map['path']}/${converted.data2}', converted.data1);
    }
  }
}
