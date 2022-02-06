import 'package:cyoap_flutter/model/choiceNode/choice_node.dart';
import 'package:cyoap_flutter/model/variable_db.dart';
import 'package:cyoap_flutter/util/tuple.dart';
import 'package:cyoap_flutter/viewModel/vm_variable_table.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';

import 'grammar/value_type.dart';

class AbstractPlatform {
  int halfWidth;
  int halfHeight;
  int localX;
  int localY;
  double scale;
  String stringImageName;
  String colorBackground;
  int flag;
  List<List<ChoiceNodeBase>> choiceNodes = List.empty(growable: true);
  List<Tuple<String, ValueTypeVisible>> globalSetting = List.empty(growable: true);

  bool isEditable = true;

  void init() {
    for(var initialValue in globalSetting){
      VariableDataBase.instance.setValue(initialValue.data1, initialValue.data2.valueType);
    }
    checkDataCollect();
  }

  AbstractPlatform(this.halfWidth, this.halfHeight, this.localX, this.localY,
      this.scale, this.stringImageName, this.colorBackground, this.flag) {
    init();
  }

  AbstractPlatform.none()
      : halfWidth = 800,
        halfHeight = 400,
        localX = 0,
        localY = 0,
        scale = 1.0,
        stringImageName = '',
        colorBackground = '#909090',
        flag = 0 {
    init();
  }

  AbstractPlatform.fromJson(Map<String, dynamic> json)
      : halfWidth = json['halfWidth'],
        halfHeight = json['halfHeight'],
        localX = json['localX'],
        localY = json['localY'],
        scale = json['scale'],
        stringImageName = json['stringImageName'],
        colorBackground = json['colorBackground'],
        flag = json['flag'],
        globalSetting = (json['globalSetting'] as List).map((e) => Tuple<String, ValueTypeVisible>.fromJson(e)).toList() {
    init();
  }

  Map<String, dynamic> toJson() => {
    'halfWidth' : halfWidth,
    'halfHeight' : halfHeight,
    'localX' : localX,
    'localY' : localY,
    'scale' : scale,
    'stringImageName' : stringImageName,
    'colorBackground' : colorBackground,
    'flag' : flag,
    'globalSetting' : globalSetting,
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
    return choiceNodes[posY][posX];
  }

  void changeData(Tuple<int, int> start, Tuple<int, int> pos) {
    var node = getChoiceNode(start.data1, start.data2)!;
    removeData(start.data1, start.data2);
    addData(pos.data1, pos.data2, node);
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
    for(var initialValue in globalSetting){
      VariableDataBase.instance.setValue(initialValue.data1, initialValue.data2.valueType);
    }
    for (var nodeY in choiceNodes) {
      for (var node in nodeY) {
        if(node.conditionClickableRecursive != null){
          var data = node.conditionClickableRecursive!.unzip().data;
          if(data != valueTypeData.none){
            node.isSelectableCheck = data as bool;
          }
        }else{
          node.isSelectableCheck = true;
        }
        if(node.select && node.executeCodeRecursive != null){
          for (var codes in node.executeCodeRecursive!) {
            codes.unzip();
          }
        }
      }
    }
    Get.find<VMVariableTable>().update();
  }

  void setGlobalSetting(List<Tuple<String, ValueTypeVisible>> units){
    globalSetting.clear();
    globalSetting.addAll(units);
  }
}
