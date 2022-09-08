import 'package:cyoap_flutter/model/platform_system.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/choiceNode/choice_node.dart';
import '../model/choiceNode/pos.dart';

final selectedChoiceNodeProvider = Provider.autoDispose<List<Pos>>((ref) {
  List<Pos> list = [];
  for (var line in getPlatform.lineSettings) {
    for (var choice in line.children) {
      (choice as ChoiceNode).doAllChild((node){
        if(node.isSelected() && node.isSelectableMode) {
          list.add(node.pos);
        }
      });
    }
  }
  return list;
});
