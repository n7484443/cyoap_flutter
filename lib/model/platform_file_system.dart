import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' show decodeImage;
import 'package:path/path.dart';

import '../util/platform_specified_util/webp_converter.dart';
import '../util/tuple.dart';
import 'abstract_platform.dart';
import 'choiceNode/choice_node.dart';
import 'choiceNode/line_setting.dart';

//platformFileSystem - abstractPlatform
class ProgressData {
  int progress;
  int progressMax;
  double progressPercent;

  ProgressData({this.progress = 0, this.progressMax = 0, this.progressPercent = 0});

  void addProgress() {
    progress++;
    progressPercent = progress / progressMax;
  }
}

class PlatformFileSystem {
  late AbstractPlatform platform;
  final Map<String, Uint8List> _dirImage = {};
  final Map<String, String> _imageSource = {};
  Image noImage = Image.asset('images/noImage.png');
  bool openAsFile = false;

  PlatformFileSystem();

  var saveProgress = ProgressData().obs;

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
            _dirImage.putIfAbsent(name, () => bytes);
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
            _dirImage.putIfAbsent(fileName.split("/")[1], () => data);
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
  void createFromVoid() {
    platform = AbstractPlatform.none();
  }

  Future<Tuple<Uint8List, String>> convertImage(String name, Uint8List data) async{
    var image = decodeImage(data)!;
    return await getWebpConverterInstance().convert(data, name, image.width, image.height);
  }

  String convertImageName(String name){
    return name.replaceAll(RegExp('[.](png|jpg|jpeg)'), '.webp');
  }


  Future<Archive> saveToZip() async {
    saveProgress.update((val) {
      val?.progress = 0;
      val?.progressMax = _dirImage.length + platform.choiceNodes.length + 2;
    });
    var archive = Archive();
    for (var imageName in _dirImage.keys) {
      var converted = await convertImage(imageName, _dirImage[imageName]!);
      archive.addFile(ArchiveFile('images/${converted.data2}',
          converted.data1.length, converted.data1));
      saveProgress.update((val) => val?.addProgress());
    }
    for (int i = 0; i < platform.choiceNodes.length; i++) {
      var tuple = platform.choiceNodes[i];
      var data = utf8.encode(jsonEncode(tuple.data2.toJson()));
      archive.addFile(ArchiveFile(
          'nodes/lineSetting_${tuple.data2.y}.json', data.length, data));

      for (int j = 0; j < tuple.data1.length; j++) {
        var node = platform.choiceNodes[i].data1[j];
        var utf = utf8.encode(jsonEncode(node.toJson()));
        archive
            .addFile(ArchiveFile('nodes/node_${node.y}_${node.x}.json', utf.length, utf));
      }
      saveProgress.update((val) => val?.addProgress());
    }
    var platformJson = utf8.encode(jsonEncode(platform.toJson()));
    archive.addFile(
        ArchiveFile('platform.json', platformJson.length, platformJson));
    saveProgress.update((val) => val?.addProgress());

    var map = {};
    for(var name in _imageSource.keys){
      map[convertImageName(name)] = _imageSource[name];
    }
    var imageSource = utf8.encode(jsonEncode(map));
    archive.addFile(
        ArchiveFile('imageSource.json', imageSource.length, imageSource));
    saveProgress.update((val) => val?.addProgress());
    return archive;
  }

  Future<void> saveToFolder(String path) async {
    saveProgress.update((val) {
      val?.progress = 0;
      val?.progressMax = _dirImage.length + platform.choiceNodes.length * 2 + 2;
    });
    var dirImages = Directory(path + '/images');
    var dirNodes = Directory(path + '/nodes');
    var dirNodesBackUp = Directory(path + '/nodes_backup');
    var platformJson = File(path + '/platform.json');
    var imageSourceJson = File(path + '/imageSource.json');

    List<String> skipImage = List.empty(growable: true);
    if (dirImages.existsSync()) {
      for (var existImage in await dirImages.list().toList()) {
        var name = basename(existImage.path);
        if (!_dirImage.containsKey(name)) {
          await existImage.delete();
        }else{
          skipImage.add(name);
        }
      }
    }else{
      dirImages.create();
    }
    for(var imageName in _dirImage.keys) {
      if (skipImage.contains(imageName)) {
        saveProgress.update((val) => val?.addProgress());
        continue;
      }
      var converted = await convertImage(imageName, _dirImage[imageName]!);
      var file = File('$path/images/${converted.data2}');
      file.createSync();
      file.writeAsBytes(converted.data1);
      saveProgress.update((val) => val?.addProgress());
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
      saveProgress.update((val) => val?.addProgress());
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
      saveProgress.update((val) => val?.addProgress());
    }


    if (platformJson.existsSync()) {
      platformJson.deleteSync(recursive: true);
    }
    platformJson.create();
    platformJson.writeAsString(jsonEncode(platform.toJson()));
    saveProgress.update((val) => val?.addProgress());

    if (imageSourceJson.existsSync()) {
      imageSourceJson.deleteSync(recursive: true);
    }
    imageSourceJson.create();
    var map = {};
    for(var name in _imageSource.keys){
      map[convertImageName(name)] = _imageSource[name];
    }
    imageSourceJson.writeAsString(jsonEncode(map));
    saveProgress.update((val) => val?.addProgress());
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
      return Image.memory(
        _dirImage[name]!,
        filterQuality: FilterQuality.high,
        isAntiAlias: true,
      );
    } else {
      return noImage;
    }
  }
  List<Uint8List> getImageList(){
    return _dirImage.values.toList();
  }
  String getImageName(int index){
    return _dirImage.keys.toList()[index];
  }

  void addImage(String name, Uint8List data) {
    _dirImage[name] = data;
  }

  int getImageIndex(String name) {
    return _dirImage.keys.toList().indexOf(name);
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
