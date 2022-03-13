import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:cyoap_flutter/main.dart';
import 'package:cyoap_flutter/model/choiceNode/choice_node.dart';
import 'package:cyoap_flutter/model/variable_db.dart';
import 'package:cyoap_flutter/util/tuple.dart';
import 'package:flutter/material.dart';

import '../util/platform_specified_util/webp_converter.dart';
import '../util/version.dart';
import 'choiceNode/line_setting.dart';
import 'grammar/value_type.dart';

class AbstractPlatform {
  double scale = 1.0;
  String stringImageName;
  Color colorBackground;
  int flag;
  List<Tuple<List<ChoiceNodeBase>, LineSetting>> choiceNodes = List.empty(growable: true);
  Map<String, ValueTypeWrapper> globalSetting = {};
  String version;

  String titleFont;
  String mainFont;

  bool isEditable = true;

  bool isVisibleSource = false;

  void init() {
    checkDataCollect();
    if (isEditable) {
      generateRecursiveParser();
    }
    updateSelectable();
  }

  bool versionCheckWithPlatform(String versionProgram){
    return versionCheck(versionProgram, version) >= 0;
  }

  AbstractPlatform(this.stringImageName,
      this.colorBackground,
      this.flag,
      this.version, {
        this.titleFont = "notoSans",
        this.mainFont = "notoSans",
      });

  AbstractPlatform.none()
      : stringImageName = '',
        colorBackground = Colors.white,
        flag = 0,
        version = ConstList.version ?? '',
        titleFont = "notoSans",
        mainFont = "notoSans";

  AbstractPlatform.fromJson(Map<String, dynamic> json)
      : stringImageName = json['stringImageName'] ?? '',
        colorBackground = (json['colorBackground'] != null && json['colorBackground'] is int) ? Color(json['colorBackground']) : Colors.white,
        flag = json['flag'] ?? 0,
        globalSetting = (json['globalSetting'] as Map)
            .map((k, v) => MapEntry(k, ValueTypeWrapper.fromJson(v))),
        version = json['version'] ?? ConstList.version,
        titleFont = json['titleFont'] ?? 'notoSans',
        mainFont = json['mainFont'] ?? 'notoSans';

  Map<String, dynamic> toJson() => {
    'stringImageName' : stringImageName,
    'colorBackground' : colorBackground.value,
    'flag' : flag,
    'globalSetting' : globalSetting,
    'version' : version,
    'titleFont' : titleFont,
    'mainFont' : mainFont,
  };

  void addLineSettingData(LineSetting lineSetting) {
    while (choiceNodes.length <= lineSetting.y) {
      choiceNodes.add(Tuple(List.empty(growable: true), LineSetting(choiceNodes.length)));
    }
    choiceNodes[lineSetting.y].data2 = lineSetting;
  }

  void addData(int x, int y, ChoiceNodeBase node) {
    node.x = x;
    node.y = y;
    while (choiceNodes.length <= node.y) {
      choiceNodes.add(Tuple(List.empty(growable: true), LineSetting(choiceNodes.length)));
    }
    if(x > choiceNodes[y].data1.length){
      choiceNodes[y].data1.add(node);
    }else{
      choiceNodes[y].data1.insert(x, node);
    }
  }


  void addDataAll(List<ChoiceNodeBase> nodeList) {
    List<List<ChoiceNodeBase>> nodeListAdditional = List.empty(growable: true);
    for(var node in nodeList){
      while(nodeListAdditional.length <= node.y){
        nodeListAdditional.add(List.empty(growable: true));
      }
      nodeListAdditional[node.y].add(node);
    }
    for(var nodeY in nodeListAdditional){
      nodeY.sort((a, b) => a.x.compareTo(b.x));
      for(var node in nodeY){
        addData(node.x, node.y, node);
      }
    }
  }

  void removeData(int x, int y){
    choiceNodes[y].data1.removeAt(x);
    checkDataCollect();
  }

  ChoiceNodeBase? getChoiceNode(int posX, int posY) {
    if(choiceNodes.length <= posY)return null;
    if(choiceNodes[posY].data1.length <= posX)return null;
    return choiceNodes[posY].data1[posX];
  }

  LineSetting? getLineSetting(int y){
    if(choiceNodes.length <= y)return null;
    return choiceNodes[y].data2;
  }

  void changeData(Tuple<int, int> start, Tuple<int, int> pos) {
    var node = getChoiceNode(start.data1, start.data2)!;
    removeData(start.data1, start.data2);
    addData(pos.data1, pos.data2, node);
    checkDataCollect();
  }

  void compress(){
    choiceNodes.removeWhere((item) => item.data1.isEmpty);
    checkDataCollect();
  }

  void checkDataCollect(){
    for(int y = 0; y < choiceNodes.length; y++){
      for(int x = 0; x < choiceNodes[y].data1.length; x++){
        choiceNodes[y].data1[x].x = x;
        choiceNodes[y].data1[x].y = y;
      }
    }
  }

  void setSelect(int posX, int posY) {
    getChoiceNode(posX, posY)?.selectNode();
    updateSelectable();
  }

  bool isSelect(int posX, int posY) {
    return getChoiceNode(posX, posY)?.select ?? false;
  }

  void updateSelectable() {
    VariableDataBase.instance.clear();

    VariableDataBase.instance.varMap.addAll(globalSetting);
    for(var nodeY in choiceNodes) {
      nodeY.data2.initValueTypeWrapper();
      for (var node in nodeY.data1) {
        node.initValueTypeWrapper();
      }
    }
    for (var nodeY in choiceNodes) {
      var lineSetting = nodeY.data2;
      for (var node in nodeY.data1) {
        if (node.select) {
          if (node.executeCodeRecursive != null) {
            for (var codes in node.executeCodeRecursive!) {
              codes.unzip();
            }
          }
          lineSetting.executeRecursive?.unzip();
        }
      }
    }

    for (var nodeY in choiceNodes) {
      var lineSetting = nodeY.data2;
      var clickableLine = lineSetting.clickableRecursive?.unzip().dataUnzip();
      bool clickableLineTest = true;
      if (clickableLine != null) {
        if (clickableLine is bool) {
          clickableLineTest = clickableLine;
        } else if (clickableLine is ValueTypeWrapper) {
          var data = clickableLine.valueType.data;
          clickableLineTest = data is bool ? data : true;
        }
      }
      for (var node in nodeY.data1) {
        if (node.conditionClickableRecursive != null) {
          if (!node.select) {
            var data = node.conditionClickableRecursive!.unzip().dataUnzip();
            bool checkClickable = true;
            if (data != null) {
              if (data is bool) {
                checkClickable = data;
              } else if (data is ValueTypeWrapper) {
                checkClickable =
                data.valueType.data is bool ? data.valueType.data : true;
              }
            }
            checkClickable &= clickableLineTest;

            node.isSelectableCheck = checkClickable;
            if (node.isSelectableCheck == false) {
              node.selectNodeWithValue(false);
            }
          }
        } else if (!node.select) {
          node.isSelectableCheck = clickableLineTest;
          if (node.isSelectableCheck == false) {
            node.selectNodeWithValue(false);
          }
        } else{
          node.isSelectableCheck = true;
        }
      }
    }
  }

  void generateRecursiveParser(){
    for(var yList in choiceNodes){
      yList.data2.generateParser();
      for(var node in yList.data1){
        node.generateParser();
      }
    }
  }

  void setGlobalSetting(Map<String, ValueTypeWrapper> units) {
    globalSetting.clear();
    globalSetting.addAll(units);
  }

  Future<Archive> toArchive(
      List<ChoiceNodeBase> nodeIn, List<LineSetting> lineIn,
      {Map<String, Uint8List>? mapImage,
      Map<String, String>? mapSource}) async {
    var archive = Archive();
    if (mapImage != null) {
      for (var imageName in mapImage.keys) {
        var converted = await convertImage(imageName, mapImage[imageName]!);
        archive.addFile(ArchiveFile('images/${converted.data2}',
            converted.data1.length, converted.data1));
      }
    }

    for (int i = 0; i < nodeIn.length; i++) {
      var node = nodeIn[i];
      var utf = utf8.encode(jsonEncode(node.toJson()));
      archive.addFile(
          ArchiveFile('nodes/node_${node.y}_${node.x}.json', utf.length, utf));
    }
    for (int i = 0; i < lineIn.length; i++) {
      var data = utf8.encode(jsonEncode(lineIn[i].toJson()));
      archive.addFile(ArchiveFile(
          'nodes/lineSetting_${lineIn[i].y}.json', data.length, data));
    }

    var platformJson = utf8.encode(jsonEncode(toJson()));
    archive.addFile(
        ArchiveFile('platform.json', platformJson.length, platformJson));

    if (mapSource != null) {
      var map = {};
      for (var name in mapSource.keys) {
        map[convertImageName(name)] = mapSource[name];
      }
      var imageSource = utf8.encode(jsonEncode(map));
      archive.addFile(
          ArchiveFile('imageSource.json', imageSource.length, imageSource));
    }
    return archive;
  }

  String convertImageName(String name) {
    return name.replaceAll(RegExp('[.](png|jpg|jpeg)'), '.webp');
  }

  Future<Tuple<Uint8List, String>> convertImage(
      String name, Uint8List data) async {
    return await getWebpConverterInstance().convert(data, name);
  }
}
