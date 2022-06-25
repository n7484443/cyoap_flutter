import 'dart:math';

import 'package:cyoap_flutter/model/choiceNode/recursive_status.dart';
import 'package:cyoap_flutter/model/variable_db.dart';
import 'package:cyoap_flutter/util/platform_specified_util/platform_specified.dart';

import '../../view/util/view_wrap_custom.dart';
import '../grammar/value_type.dart';
import 'generable_parser.dart';

class ChoiceNode extends GenerableParserAndPosition {
  //grid 단위로 설정
  bool isCard;
  bool isRound = true;
  int maxRandom = 0;
  int random = -1;
  int imagePosition = 0; //0:default, 1:left 2:right
  String title;
  String contentsString;
  String imageString;

  @override
  bool get isSelectableCheck => isSelectable;
  bool isSelectable = true;
  bool isOccupySpace = true;
  bool maximizingImage = false;
  bool hideTitle = false;

  bool get isRandom => maxRandom > 0;

  ChoiceNode(int width, this.isCard, this.title, this.contentsString,
      this.imageString) {
    recursiveStatus = RecursiveStatus();
    this.width = width;
  }

  ChoiceNode.origin(int width, this.isCard, this.title, this.contentsString,
      this.imageString) {
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
        imagePosition = json['imagePosition'] ?? 0,
        title = json['title'] ?? '',
        contentsString = json['contentsString'],
        imageString = json['imageString'] ?? json['image'],
        hideTitle = json['hideTitle'] ?? false {
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
      'imagePosition': imagePosition,
      'hideTitle': hideTitle,
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
    for (var child in children) {
      child.generateParser();
    }
  }

  @override
  void initValueTypeWrapper() {
    var titleWhitespaceRemoved = title.replaceAll(" ", "");
    VariableDataBase().setValue(titleWhitespaceRemoved,
        ValueTypeWrapper(ValueType(status.isSelected()), false));
    VariableDataBase().setValue('$titleWhitespaceRemoved:random',
        ValueTypeWrapper(ValueType(random), false));
    if (status.isNotSelected()) {
      status = isSelectable ? SelectableStatus.open : SelectableStatus.selected;
    }
    for (var child in children) {
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

  int getMaxSize(bool containSelf) {
    var nodeParent = containSelf ? this : parent;
    var out = 0;
    while (true) {
      if (nodeParent is ChoiceNode) {
        if (nodeParent.width == 0) {
          nodeParent = nodeParent.parent;
          continue;
        } else {
          out = nodeParent.width;
          break;
        }
      } else {
        out = defaultMaxSize;
        break;
      }
    }
    return out;
  }
}
