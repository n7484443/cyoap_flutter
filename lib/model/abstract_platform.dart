import 'package:cyoap_flutter/main.dart';
import 'package:cyoap_flutter/model/choiceNode/choice_node.dart';
import 'package:cyoap_flutter/model/variable_db.dart';
import 'package:cyoap_flutter/util/tuple.dart';

import 'grammar/value_type.dart';

class AbstractPlatform {
  int halfWidth;
  int halfHeight;
  double scale;
  String stringImageName;
  String colorBackground;
  int flag;
  List<List<ChoiceNodeBase>> choiceNodes = List.empty(growable: true);
  Map<String, ValueTypeWrapper> globalSetting = {};
  String version;

  bool isEditable = true;

  void init() {
    checkDataCollect();
    updateSelectable();
  }

  bool versionCheck(String versionProgram){
    var vPlatform = version.split('.');
    var vProgram = versionProgram.split('.');
    for(int i = 0; i < 3; i ++){
      if(int.parse(vPlatform[i]) < int.parse(vProgram[i]))return false;
    }

    return true;
  }

  AbstractPlatform(this.halfWidth, this.halfHeight, this.scale, this.stringImageName, this.colorBackground, this.flag, this.version);

  AbstractPlatform.none()
      : halfWidth = 800,
        halfHeight = 400,
        scale = 1.0,
        stringImageName = '',
        colorBackground = '#909090',
        flag = 0,
        version = ConstList.version ?? '';

  AbstractPlatform.fromJson(Map<String, dynamic> json)
      : halfWidth = json['halfWidth'] ?? 800,
        halfHeight = json['halfHeight'] ?? 400,
        scale = json['scale'] ?? 1.0,
        stringImageName = json['stringImageName'] ?? '',
        colorBackground = json['colorBackground'] ?? '#909090',
        flag = json['flag'] ?? 0,
        globalSetting = (json['globalSetting'] as Map)
            .map((k, v) => MapEntry(k, ValueTypeWrapper.fromJson(v))),
        version = json['version'] ?? ConstList.version;

  Map<String, dynamic> toJson() => {
    'halfWidth' : halfWidth,
    'halfHeight' : halfHeight,
    'scale' : scale,
    'stringImageName' : stringImageName,
    'colorBackground' : colorBackground,
    'flag' : flag,
    'globalSetting' : globalSetting,
    'version' : version,
  };

  int getMinX() => -halfWidth;

  int getMinY() => -halfHeight;

  int getMaxX() => halfWidth;

  int getMaxY() => halfHeight;

  int getWidth() => halfWidth * 2;

  int getHeight() => halfHeight * 2;

  void addData(int x, int y, ChoiceNodeBase node) {
    node.x = x;
    node.y = y;
    while (choiceNodes.length <= node.y) {
      choiceNodes.add(List.empty(growable: true));
    }
    if(x > choiceNodes[y].length){
      choiceNodes[y].add(node);
    }else{
      choiceNodes[y].insert(x, node);
    }
  }

  void removeData(int x, int y){
    choiceNodes[y].removeAt(x);
    checkDataCollect();
  }

  ChoiceNodeBase? getChoiceNode(int posX, int posY) {
    if(choiceNodes.length <= posY)return null;
    if(choiceNodes[posY].length <= posX)return null;
    return choiceNodes[posY][posX];
  }

  void changeData(Tuple<int, int> start, Tuple<int, int> pos) {
    var node = getChoiceNode(start.data1, start.data2)!;
    removeData(start.data1, start.data2);
    addData(pos.data1, pos.data2, node);
    checkDataCollect();
  }

  void compress(){
    choiceNodes.removeWhere((item) => item.isEmpty);
    checkDataCollect();
  }

  void checkDataCollect(){
    for(int y = 0; y < choiceNodes.length; y++){
      for(int x = 0; x < choiceNodes[y].length; x++){
        choiceNodes[y][x].x = x;
        choiceNodes[y][x].y = y;
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
      for (var node in nodeY) {
        VariableDataBase.instance.setValue(node.title.replaceAll(" ", ""),
            ValueTypeWrapper(ValueType(node.select), false, true));
      }
    }
    for (var nodeY in choiceNodes) {
      for (var node in nodeY) {
        if (node.conditionClickableRecursive != null) {
          var data = node.conditionClickableRecursive!.unzip().data;
          if (data != null && data != valueTypeData.none) {
            if (data is VariableUnit) {
              var varData = VariableDataBase.instance.getValueTypeWrapper(data.varName);
              node.isSelectableCheck = (varData != null && varData.valueType.data is bool) ? varData.valueType.data as bool : true;
              if (node.isSelectableCheck == false) {
                node.selectNodeWithValue(false);
              }
            } else if(data is bool){
              node.isSelectableCheck = data;
              if (node.isSelectableCheck == false) {
                node.selectNodeWithValue(false);
              }
            }
          }
        } else {
          node.isSelectableCheck = true;
        }
        if (node.select && node.executeCodeRecursive != null) {
          for (var codes in node.executeCodeRecursive!) {
            codes.unzip();
          }
        }
      }
    }
  }

  void setGlobalSetting(Map<String, ValueTypeWrapper> units) {
    globalSetting.clear();
    globalSetting.addAll(units);
  }
}
