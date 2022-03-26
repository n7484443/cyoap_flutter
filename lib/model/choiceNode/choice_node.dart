import 'package:cyoap_flutter/model/choiceNode/recursive_status.dart';
import 'package:cyoap_flutter/model/variable_db.dart';
import 'package:english_words/english_words.dart';

import '../grammar/value_type.dart';
import 'generable_parser.dart';

class ChoiceNodeBase extends GenerableParserAndPosition {
  //grid 단위로 설정
  int width; //-1 = 무한대
  int height; //0 == 1/2
  bool isCard;
  String title;
  String contentsString;
  String imageString;
  @override
  bool get isSelectableCheck => isSelectable;
  bool isSelectable = true;

  ChoiceNodeBase(this.width, this.height, this.isCard,
      this.title, this.contentsString, this.imageString){
    recursiveStatus = RecursiveStatus();
  }

  ChoiceNodeBase.origin(this.width, this.height, this.isCard, this.title,
      this.contentsString, this.imageString)
      {
    recursiveStatus = RecursiveStatus();
  }

  ChoiceNodeBase.noTitle(this.width, this.height, this.isCard,
      this.contentsString, this.imageString)
      : title = '' {
    recursiveStatus = RecursiveStatus();
    for (int i = 0; i < 2; i++) {
      title += WordPair.random().asPascalCase;
    }
  } //랜덤 문자로 제목 중복 방지

  ChoiceNodeBase.fromJson(Map<String, dynamic> json)
      : width = json['width'],
        height = json['height'],
        isCard = json['isCard'],
        isSelectable = json['isSelectable'],
        title = json['title'],
        contentsString = json['contentsString'],
        imageString = json['imageString'] ?? json['image'] {
    currentPos = json['x'] ?? json['currentPos'];
    recursiveStatus = RecursiveStatus.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = super.toJson();
    map.addAll({
      'width': width,
      'height': height,
      'isCard': isCard,
      'isSelectable': isSelectable,
      'title': title,
      'contentsString': contentsString,
      'image': convertToWebp(imageString),
    });
    return map;
  }

  void selectNode() {
    status = status.reverseSelected(isSelectable);
    updateSelectValueTypeWrapper();
  }

  void updateSelectValueTypeWrapper() {
    VariableDataBase.instance.setValue('${title.trim()}:select',
        ValueTypeWrapper(ValueType(status.isSelected()), false, true));
  }

  @override
  void generateParser() {
    recursiveStatus.generateParser();
  }

  @override
  void initValueTypeWrapper() {
    VariableDataBase.instance.setValue(title.replaceAll(" ", ""),
        ValueTypeWrapper(ValueType(status.isSelected()), false, true));
    if (status.isNotSelected()) {
      status = isSelectable ? SelectableStatus.open : SelectableStatus.selected;
    }
  }

  String convertToWebp(String name) {
    return name.replaceAll(RegExp('[.](png|jpg|jpeg)'), '.webp');
  }
}
