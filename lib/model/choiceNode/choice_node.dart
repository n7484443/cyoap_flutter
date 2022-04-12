import 'dart:math';

import 'package:cyoap_flutter/model/choiceNode/recursive_status.dart';
import 'package:cyoap_flutter/model/variable_db.dart';
import 'package:cyoap_flutter/util/platform_specified_util/platform_specified.dart';

import '../grammar/value_type.dart';
import 'generable_parser.dart';

class ChoiceNodeBase extends GenerableParserAndPosition {
  //grid 단위로 설정
  int width; //0 = 무한대
  bool isCard;
  int maxRandom = -1;
  int random = -1;
  String title;
  String contentsString;
  String imageString;
  @override
  bool get isSelectableCheck => isSelectable;
  bool isSelectable = true;

  bool get isRandom => maxRandom > 0;

  ChoiceNodeBase(this.width, this.isCard, this.title, this.contentsString,
      this.imageString) {
    recursiveStatus = RecursiveStatus();
  }

  ChoiceNodeBase.origin(this.width, this.isCard, this.title,
      this.contentsString, this.imageString) {
    recursiveStatus = RecursiveStatus();
  }

  ChoiceNodeBase.noTitle(
      this.width, this.isCard, this.contentsString, this.imageString)
      : title = '' {
    recursiveStatus = RecursiveStatus();
    title = "선택지 " + Random().nextInt(99).toString();
  } //랜덤 문자로 제목 중복 방지

  ChoiceNodeBase.fromJson(Map<String, dynamic> json)
      : width = json['width'] ?? 1,
        isCard = json['isCard'] ?? true,
        maxRandom = json['maxRandom'] ?? -1,
        isSelectable = json['isSelectable'],
        title = json['title'] ?? '',
        contentsString = json['contentsString'],
        imageString = json['imageString'] ?? json['image'] {
    currentPos = json['x'] ?? json['pos'];
    recursiveStatus = RecursiveStatus.fromJson(json);
    if (json.containsKey('children')) {
      children.addAll((json['children'] as List)
          .map((e) => ChoiceNodeBase.fromJson(e)..parent = this)
          .toList());
    }
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = super.toJson();
    map.addAll({
      'width': width,
      'isCard': isCard,
      'isSelectable': isSelectable,
      'maxRandom': maxRandom,
      'title': title,
      'contentsString': contentsString,
      'image': convertToWebp(imageString),
    });
    return map;
  }

  void selectNode() {
    status = status.reverseSelected(isSelectable);
  }

  @override
  void generateParser() {
    recursiveStatus.generateParser();
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
  }

  String convertToWebp(String name) {
    return PlatformSpecified().saveProject!.convertImageName(name);
  }

  ChoiceNodeBase? getParentLast() {
    ChoiceNodeBase parent = this;
    while (true) {
      if (parent.parent == null) break;
      if (parent.parent is! ChoiceNodeBase) break;
      parent = parent.parent as ChoiceNodeBase;
    }
    return parent;
  }
}
