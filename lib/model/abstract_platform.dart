import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:cyoap_flutter/main.dart';
import 'package:cyoap_flutter/model/choiceNode/choice_node.dart';
import 'package:cyoap_flutter/model/platform_system.dart';
import 'package:cyoap_flutter/model/variable_db.dart';
import 'package:cyoap_flutter/util/tuple.dart';
import 'package:flutter/material.dart';

import '../util/platform_specified_util/platform_specified.dart';
import '../util/version.dart';
import 'choiceNode/choice_line.dart';
import 'choiceNode/generable_parser.dart';
import 'grammar/value_type.dart';

class AbstractPlatform {
  double scale = 1.0;
  String stringImageName;
  Color colorBackground;
  int flag;
  List<LineSetting> lineSettings = List.empty(growable: true);
  Map<String, ValueTypeWrapper> globalSetting = {};
  String version;

  String titleFont;
  String mainFont;

  bool isVisibleSource = false;

  void init() {
    checkDataCollect();
    if (getPlatformFileSystem().isEditable) {
      generateRecursiveParser();
    }
    updateSelectable();
  }

  bool versionCheckWithPlatform(String versionProgram) {
    return versionCheck(versionProgram, version) >= 0;
  }

  AbstractPlatform(
    this.stringImageName,
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
        version = ConstList.version,
        titleFont = "notoSans",
        mainFont = "notoSans";

  AbstractPlatform.fromJson(Map<String, dynamic> json)
      : stringImageName = json['stringImageName'] ?? '',
        colorBackground =
            (json['colorBackground'] != null && json['colorBackground'] is int)
                ? Color(json['colorBackground'])
                : Colors.white,
        flag = json['flag'] ?? 0,
        globalSetting = (json['globalSetting'] as Map)
            .map((k, v) => MapEntry(k, ValueTypeWrapper.fromJson(v))),
        version = json['version'] ?? ConstList.version,
        titleFont = json['titleFont'] ?? 'notoSans',
        mainFont = json['mainFont'] ?? 'notoSans';

  Map<String, dynamic> toJson() => {
        'stringImageName': stringImageName,
        'colorBackground': colorBackground.value,
        'flag': flag,
        'globalSetting': globalSetting,
        'version': version,
        'titleFont': titleFont,
        'mainFont': mainFont,
      };

  void addLineSettingData(LineSetting lineSetting) {
    while (lineSettings.length <= lineSetting.currentPos) {
      lineSettings.add(LineSetting(lineSettings.length));
    }
    lineSettings[lineSetting.currentPos] = lineSetting;
  }

  void addData(int x, int y, ChoiceNodeBase node) {
    while (lineSettings.length <= y) {
      lineSettings.add(LineSetting(lineSettings.length));
    }
    lineSettings[y].addData(x, node);
  }

  void addDataAll(List<LineSetting> lineList) {
    for (var lineSetting in lineList) {
      addLineSettingData(lineSetting);
    }
  }

  void removeData(int x, int y) {
    lineSettings[y].children.removeAt(x);
    checkDataCollect();
  }

  ChoiceNodeBase? getChoiceNode(int posX, int posY) {
    if (lineSettings.length <= posY) return null;
    if (lineSettings[posY].children.length <= posX) return null;
    return lineSettings[posY].children[posX];
  }

  LineSetting? getLineSetting(int y) {
    if (lineSettings.length <= y) return null;
    return lineSettings[y];
  }

  void changeData(Tuple<int, int> start, Tuple<int, int> pos) {
    var node = getChoiceNode(start.data1, start.data2)!;
    removeData(start.data1, start.data2);
    addData(pos.data1, pos.data2, node);
    checkDataCollect();
  }

  void compress() {
    lineSettings.removeWhere((item) => item.children.isEmpty);
    checkDataCollect();
  }

  void checkDataCollect() {
    for (var line in lineSettings) {
      for (int x = 0; x < line.children.length; x++) {
        line.children[x].x = x;
      }
    }
  }

  void setSelect(int posX, int posY) {
    getChoiceNode(posX, posY)?.selectNode();
    updateSelectable();
  }

  bool isSelect(int posX, int posY) {
    return getChoiceNode(posX, posY)?.status.isSelected() ?? false;
  }

  void updateSelectable() {
    VariableDataBase.instance.clear();

    VariableDataBase.instance.varMap.addAll(globalSetting);
    for (var lineSetting in lineSettings) {
      lineSetting.initValueTypeWrapper();

      for (var node in lineSetting.children) {
        if (node.status.isSelected()) {
          node.execute();
          if (node.isSelectable) {
            lineSetting.execute();
          }
        }
      }
      for (var node in lineSetting.children) {
        var visible = node.isVisible();
        if (node.status != SelectableStatus.selected) {
          if (!visible) {
            node.status = SelectableStatus.hide;
          }
          node.updateSelectValueTypeWrapper();
        }
      }

      bool clickableLineTest = lineSetting.isClickable();

      for (var node in lineSetting.children) {
        var selectable = node.isClickable();
        if (node.isSelectable) {
          if (node.status != SelectableStatus.selected &&
              node.status != SelectableStatus.hide) {
            selectable &= clickableLineTest;
            node.status =
                selectable ? SelectableStatus.open : SelectableStatus.closed;
          }
        } else {
          node.status = SelectableStatus.selected;
        }

        node.updateSelectValueTypeWrapper();
      }
    }
  }

  void generateRecursiveParser() {
    for(var lineSetting in lineSettings){
      lineSetting.generateParser();
    }
  }

  void setGlobalSetting(Map<String, ValueTypeWrapper> units) {
    globalSetting.clear();
    globalSetting.addAll(units);
    generateRecursiveParser();
    updateSelectable();
  }

  Future<Archive> toArchive(
      Map<String, Uint8List>? mapImage, Map<String, String>? mapSource) async {
    var archive = Archive();
    if (mapImage != null) {
      for (var imageName in mapImage.keys) {
        var converted = await saveProject!
            .convertImage(imageName, mapImage[imageName]!);
        archive.addFile(ArchiveFile('images/${converted.data1}',
            converted.data2.length, converted.data2));
      }
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

  void doAllChoiceNode(void Function(ChoiceNodeBase node) action) {
    for (var lineSetting in lineSettings) {
      for (var node in lineSetting.children) {
        action(node);
      }
    }
  }
}
