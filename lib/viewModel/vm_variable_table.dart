import 'package:cyoap_flutter/model/platform_system.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class VMVariableTable extends GetxController {
  List<String> getNodeNameList(){
    List<String> nodeNameList = List.empty(growable: true);
    var nodes = PlatformSystem.getPlatform().choiceNodes;
    for(var t in nodes){
      for(var node in t){
        nodeNameList.add(node.title);
      }
    }
    return nodeNameList;
  }
}