import 'package:cyoap_flutter/model/grammar/lexical_analyser.dart';
import 'package:cyoap_flutter/model/grammar/recursive_parser.dart';
import 'package:cyoap_flutter/model/grammar/semantic_analyser.dart';
import 'package:cyoap_flutter/model/grammar/token.dart';

import 'function_list.dart';

class Analyser {
  Analyser._init() {
    functionList.init();
  }

  static final Analyser _instance = Analyser._init();

  factory Analyser() {
    return _instance;
  }

  LexicalAnalyser lexicalAnalyser = LexicalAnalyser();
  SemanticAnalyser semanticAnalyser = SemanticAnalyser();
  Functions functionList = Functions();

  List<RecursiveUnit> analyse(String codeInput) {
    List<RecursiveUnit> recursiveList = List.empty(growable: true);
    var codes = codeInput.split('\n');
    var tokenList = List<Token>.empty(growable: true);
    for (var code in codes) {
      if (code.trim().isEmpty) {
        continue;
      }
      tokenList.addAll(lexicalAnalyser.analyse(code));
    }

    var t = semanticAnalyser.analyseLines(tokenList);
    if(t != null){
      recursiveList.add(t);
    }
    /*
    try {
      var t = semanticAnalyser.analyseLines(tokenList);
      if(t != null){
        recursiveList.add(t);
      }
    } catch (e) {
      print(e);
      //e.printError(info: 'something wrong in $codes');
    }*/
    return recursiveList;
  }

  void run(List<RecursiveUnit>? unitList) {
    if (unitList == null) return;
    for (var unit in unitList) {
      unit.unzip();
    }
  }

  dynamic check(RecursiveUnit? unitList) {
    if (unitList == null) return null;
    return unitList.unzip().dataUnzip();
  }

  List<RecursiveUnit> analyseCodes(String codeInput) {
    return _instance.analyse(codeInput);
  }
}
