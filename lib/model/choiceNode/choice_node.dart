import 'package:cyoap_flutter/model/grammar/recursive_parser.dart';
import 'package:cyoap_flutter/model/variable_db.dart';
import 'package:english_words/english_words.dart';

import '../grammar/analyser.dart';
import '../grammar/value_type.dart';
import 'generable_parser.dart';

class ChoiceNodeBase extends GenerableParser{
  //grid 단위로 설정
  int x;
  int y;
  int width; //-1 = 무한대
  int height;
  bool isCard;
  String title;
  String contentsString;
  String imageString;
  RecursiveUnit? conditionClickableRecursive;
  RecursiveUnit? conditionVisibleRecursive;
  List<RecursiveUnit>? executeCodeRecursive;
  String conditionClickableString = '';
  String conditionVisibleString = '';
  String executeCodeString = '';
  bool select = false;
  bool isSelectable = true;
  bool isSelectableCheck = true;

  ChoiceNodeBase(this.x, this.y, this.width, this.height, this.isCard,
      this.title, this.contentsString, this.imageString);

  ChoiceNodeBase.origin(this.width, this.height, this.isCard, this.title,
      this.contentsString, this.imageString)
      : x = 0,
        y = 0;

  ChoiceNodeBase.noTitle(this.width, this.height, this.isCard,
      this.contentsString, this.imageString)
      : x = 0,
        y = 0,
        title = '' {
    for (int i = 0; i < 2; i++) {
      title += WordPair.random().asPascalCase;
    }
  } //랜덤 문자로 제목 중복 방지

  int getType() {
    if (imageString.isEmpty) {
      return 0;
    }
    if (contentsString.isEmpty) {
      return 1;
    }
    return 2;
  }

  Map<String, dynamic> toJson() =>
      {
        'x': x,
        'y': y,
        'width': width,
        'height': height,
        'isCard': isCard,
        'isSelectable': isSelectable,
        'title': title,
        'contentsString': contentsString,
        'imageString': imageString,
        'conditionClickableRecursive': conditionClickableRecursive,
        'conditionVisibleRecursive': conditionVisibleRecursive,
        'executeCodeRecursive': executeCodeRecursive,
        'conditionClickableString': conditionClickableString,
        'conditionVisibleString': conditionVisibleString,
        'executeCodeString': executeCodeString,
      };

  ChoiceNodeBase.fromJson(Map<String, dynamic> json)
      : x = json['x'],
        y = json['y'],
        width = json['width'],
        height = json['height'],
        isCard = json['isCard'],
        isSelectable = json['isSelectable'],
        title = json['title'],
        contentsString = json['contentsString'],
        imageString = json['imageString'],
        conditionClickableString = json['conditionClickableString'],
        conditionVisibleString = json['conditionVisibleString'],
        executeCodeString = json['executeCodeString'] {
    if (json['conditionClickableRecursive'] == null) {
      conditionClickableRecursive = null;
    } else {
      conditionClickableRecursive =
          getClassFromJson(json['conditionClickableRecursive']);
    }
    if (json['conditionVisibleRecursive'] == null) {
      conditionVisibleRecursive = null;
    } else {
      conditionVisibleRecursive =
          getClassFromJson(json['conditionVisibleRecursive']);
    }

    if (json['executeCodeRecursive'] == null) {
      executeCodeRecursive = null;
    } else {
      executeCodeRecursive =
          List.generate((json['executeCodeRecursive'] as List).length, (index) {
        return getClassFromJson((json['executeCodeRecursive'] as List)[index]);
      });
    }
  }

  void selectNode() {
    select = !select;
    VariableDataBase.instance
        .setValue('${title.trim()}:select', ValueTypeWrapper(ValueType(select), false, true));
  }

  void selectNodeWithValue(bool s) {
    select = s;
    VariableDataBase.instance
        .setValue('${title.trim()}:select', ValueTypeWrapper(ValueType(select), false, true));
  }

  bool isSelectableWithCheck() {
    return isSelectable && isSelectableCheck;
  }

  @override
  void generateParser() {
    var conditionClickableRecursiveParsed =
        Analyser.analyseCodes(conditionClickableString);
    var conditionVisibleRecursiveParsed =
        Analyser.analyseCodes(conditionVisibleString);
    var executeCodeRecursiveParsed = Analyser.analyseCodes(executeCodeString);

    conditionClickableRecursive = conditionClickableRecursiveParsed.isNotEmpty
        ? conditionClickableRecursiveParsed[0]
        : null;
    conditionVisibleRecursive = conditionVisibleRecursiveParsed.isNotEmpty
        ? conditionVisibleRecursiveParsed[0]
        : null;
    executeCodeRecursive = executeCodeRecursiveParsed;
  }

  @override
  void initValueTypeWrapper() {
    VariableDataBase.instance.setValue(title.replaceAll(" ", ""),
        ValueTypeWrapper(ValueType(select), false, true));
  }
}
