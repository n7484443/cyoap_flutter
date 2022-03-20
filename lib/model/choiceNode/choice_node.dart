import 'package:cyoap_flutter/model/choiceNode/recursive_status.dart';
import 'package:cyoap_flutter/model/grammar/recursive_parser.dart';
import 'package:cyoap_flutter/model/variable_db.dart';
import 'package:english_words/english_words.dart';

import '../grammar/analyser.dart';
import '../grammar/value_type.dart';
import 'generable_parser.dart';

enum SelectableStatus {
  //isSelectable가 false 인 경우에는 selected와 hide 두가지로 사용
  selected, //선택된 상태
  hide, //숨긴 상태
  open, //선택 가능한 상태
  closed, //약간 흐릿하면서 선택 불가능한 상태
}

extension SelectableStatusExtension on SelectableStatus {
  bool isSelected() {
    return this == SelectableStatus.selected;
  }

  bool isPointerInteractive(bool isSelectable) {
    if (isSelectable) {
      return this == SelectableStatus.selected || this == SelectableStatus.open;
    }
    return false;
  }

  bool isNotSelected() {
    return !isSelected();
  }

  SelectableStatus reverseSelected(bool isSelectable) {
    if (isSelectable) {
      return this == SelectableStatus.selected
          ? SelectableStatus.open
          : SelectableStatus.selected;
    } else {
      return this == SelectableStatus.selected
          ? SelectableStatus.hide
          : SelectableStatus.selected;
    }
  }
}

class ChoiceNodeBase extends GenerableParserAndPosition {
  //grid 단위로 설정
  int x;
  @override
  int get currentPos => x;

  int width; //-1 = 무한대
  int height; //0 == 1/2
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
  bool isSelectable = true;
  SelectableStatus status = SelectableStatus.open;
  RecursiveStatus recursiveStatus = RecursiveStatus();
  List<ChoiceNodeBase> children = List.empty(growable: true);

  ChoiceNodeBase(this.x, this.width, this.height, this.isCard,
      this.title, this.contentsString, this.imageString);

  ChoiceNodeBase.origin(this.width, this.height, this.isCard, this.title,
      this.contentsString, this.imageString)
      : x = 0;

  ChoiceNodeBase.noTitle(this.width, this.height, this.isCard,
      this.contentsString, this.imageString)
      : x = 0,
        title = '' {
    for (int i = 0; i < 2; i++) {
      title += WordPair.random().asPascalCase;
    }
  } //랜덤 문자로 제목 중복 방지

  String convertToWebp(String name) {
    return name.replaceAll(RegExp('[.](png|jpg|jpeg)'), '.webp');
  }

  @override
  Map<String, dynamic> toJson() => {
        'x': x,
        'width': width,
        'height': height,
        'isCard': isCard,
        'isSelectable': isSelectable,
        'title': title,
        'contentsString': contentsString,
        'imageString': convertToWebp(imageString),
        'conditionClickableRecursive': conditionClickableRecursive,
        'conditionVisibleRecursive': conditionVisibleRecursive,
        'executeCodeRecursive': executeCodeRecursive,
        'conditionClickableString': conditionClickableString,
        'conditionVisibleString': conditionVisibleString,
        'executeCodeString': executeCodeString,
      };

  ChoiceNodeBase.fromJson(Map<String, dynamic> json)
      : x = json['x'],
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
    status = status.reverseSelected(isSelectable);
    updateSelectValueTypeWrapper();
  }

  void updateSelectValueTypeWrapper() {
    VariableDataBase.instance.setValue('${title.trim()}:select',
        ValueTypeWrapper(ValueType(status.isSelected()), false, true));
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
        ValueTypeWrapper(ValueType(status.isSelected()), false, true));
    if (status.isNotSelected()) {
      status = isSelectable ? SelectableStatus.open : SelectableStatus.selected;
    }
  }
}
