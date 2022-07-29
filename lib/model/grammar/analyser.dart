import 'package:cyoap_flutter/model/grammar/lexical_analyser.dart';
import 'package:cyoap_flutter/model/grammar/recursive_parser.dart';
import 'package:cyoap_flutter/model/grammar/semantic_analyser.dart';
import 'package:cyoap_flutter/model/grammar/token.dart';

import 'analyser_const.dart';
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

  List<Token> toTokenList(String codeInput) {
    var codes = codeInput.split('\n');
    var tokenList = List<Token>.empty(growable: true);
    for (var code in codes) {
      if (code.trim().isEmpty) {
        continue;
      }
      tokenList.addAll(
          lexicalAnalyser.analyse(code.replaceAll(RegExp(r"//.*"), "")));
      tokenList.add(Token(AnalyserConst.lineEnd));
    }
    tokenList = lexicalAnalyser.changeToSet(tokenList);
    return tokenList;
  }

  RecursiveUnit? analyse(String codeInput) {
    try {
      return semanticAnalyser.analyseLines(toTokenList(codeInput));
    } catch (e) {
      print(e);
    }
    return null;
  }

  RecursiveUnit? analyseSingleLine(String codeInput) {
    try {
      return semanticAnalyser.analyseLine(toTokenList(codeInput));
    } catch (e) {
      print(e);
    }
    return null;
  }

  void run(RecursiveUnit? unitList) {
    if (unitList == null) return;
    try {
      unitList.unzip();
    } catch (e) {
      print(e);
    }
  }

  dynamic check(RecursiveUnit? unitList) {
    if (unitList == null) return null;
    try {
      return unitList.unzip().dataUnzip();
    } catch (e) {
      print(e);
    }
  }

  RecursiveUnit? analyseCodes(String codeInput) {
    return _instance.analyse(codeInput);
  }
}
