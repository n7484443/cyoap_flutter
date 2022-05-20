import 'dart:math';

import 'package:cyoap_flutter/model/choiceNode/recursive_status.dart';
import 'package:cyoap_flutter/model/variable_db.dart';
import 'package:cyoap_flutter/util/platform_specified_util/platform_specified.dart';

import '../grammar/value_type.dart';
import 'generable_parser.dart';

class ChoiceNode extends GenerableParserAndPosition {
  //grid 단위로 설정
  bool isCard;
  bool isRound = true;
  int maxRandom = 0;
  int random = -1;
  String title;
  String contentsString;
  String imageString;
  @override
  bool get isSelectableCheck => isSelectable;
  bool isSelectable = true;
  bool isOccupySpace = true;
  bool maximizingImage = false;

  bool get isRandom => maxRandom > 0;

  ChoiceNode(int width, this.isCard, this.title, this.contentsString,
      this.imageString) {
    recursiveStatus = RecursiveStatus();
    this.width = width;
  }

  ChoiceNode.origin(int width, this.isCard, this.title,
      this.contentsString, this.imageString) {
    recursiveStatus = RecursiveStatus();
    this.width = width;
  }

  ChoiceNode.noTitle(
      int width, this.isCard, this.contentsString, this.imageString)
      : title = '' {
    recursiveStatus = RecursiveStatus();
    title = "선택지 ${Random().nextInt(99)}";
    this.width = width;
  } //랜덤 문자로 제목 중복 방지

  ChoiceNode.fromJson(Map<String, dynamic> json)
      : isCard = json['isCard'] ?? true,
        isRound = json['isRound'] ?? true,
        isOccupySpace = json['isOccupySpace'] ?? true,
        maximizingImage = json['maximizingImage'] ?? false,
        maxRandom = json['maxRandom'] ?? 0,
        isSelectable = json['isSelectable'],
        title = json['title'] ?? '',
        contentsString = json['contentsString'],
        imageString = json['imageString'] ?? json['image'] {
    width = json['width'] ?? 2;
    currentPos = json['x'] ?? json['pos'];
    recursiveStatus = RecursiveStatus.fromJson(json);
    if (json.containsKey('children')) {
      children.addAll((json['children'] as List)
          .map((e) => ChoiceNode.fromJson(e)..parent = this)
          .toList());
    }
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = super.toJson();
    map.addAll({
      'isCard': isCard,
      'isRound': isRound,
      'isOccupySpace': isOccupySpace,
      'isSelectable': isSelectable,
      'maxRandom': maxRandom,
      'title': title,
      'contentsString': contentsString,
      'image': convertToWebp(imageString),
      'maximizingImage': maximizingImage,
    });
    return map;
  }

  void selectNode() {
    status = status.reverseSelected(isSelectable);
  }

  @override
  void generateParser() {
    recursiveStatus.generateParser();
    for(var child in children){
      child.generateParser();
    }
  }

  @override
  void initValueTypeWrapper() {
    VariableDataBase().setValue(
        title.trim(), ValueTypeWrapper(ValueType(status.isSelected()), false));
    VariableDataBase().setValue(
        '${title.trim()}:random', ValueTypeWrapper(ValueType(random), false));
    if (status.isNotSelected()) {
      status = isSelectable ? SelectableStatus.open : SelectableStatus.selected;
    }
    for(var child in children){
      child.initValueTypeWrapper();
    }
  }

  String convertToWebp(String name) {
    return PlatformSpecified().saveProject!.convertImageName(name);
  }

  ChoiceNode? getParentLast() {
    ChoiceNode parent = this;
    while (true) {
      if (parent.parent == null) break;
      if (parent.parent is! ChoiceNode) break;
      parent = parent.parent as ChoiceNode;
    }
    return parent;
  }
}
