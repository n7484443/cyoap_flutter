import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../view/view_choice_node.dart';

class VMPlatform extends GetxController{
  List<List<int>> type = [
    [0, 1, 2, 0],
    [0, 1, 0],
    [0, 2],
    [1], ];
  List<List<Widget>> widgetList = [[]];

  void updateWidgetList(){
    widgetList = List.generate(1, (index) => [], growable: true);
    for(var i = 0; i < type.length; i++){
      print(i);
      if(widgetList[i].isEmpty){
        widgetList.add(<Widget>[]);
      }
      for(var j = 0; j < type[i].length; j++){
        widgetList[i].add(getWidgetFromType(type[i][j]));
      }
    }
    update();
  }

  Widget getWidgetFromType(int type){
    switch(type){
      case 0:
        return const ViewChoiceNode();
      case 1:
        return const ViewChoiceNodeImage();
      default:
        return const ViewChoiceNodeTextWithImage();
    }
  }
}