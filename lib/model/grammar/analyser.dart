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
  List<String> errorList = [];

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

  RecursiveUnit? analyseMultiLine(String? codeInput, {String pos = ""}) {
    if (codeInput == null) return null;
    try {
      return semanticAnalyser.analyseLines(toTokenList(codeInput));
    } catch (e) {
      addError("$pos, $e");
    }
    return null;
  }

  RecursiveUnit? analyseSingleLine(String? codeInput, {String pos = ""}) {
    if (codeInput == null) return null;
    try {
      return semanticAnalyser.analyseLine(toTokenList(codeInput));
    } catch (e) {
      addError("$pos, $e");
    }
    return null;
  }

  void run(RecursiveUnit? unitList, {String pos = ""}) {
    if (unitList == null) return;
    try {
      unitList.unzip();
    } catch (e) {
      addError("$pos, $e");
    }
  }

  dynamic check(RecursiveUnit? unitList, {String pos = ""}) {
    if (unitList == null) return null;
    try {
      return unitList.unzip().dataUnzip();
    } catch (e) {
      addError("$pos, $e");
    }
  }

  void addError(String str) {
    if(!errorList.contains(str)) {
      print(str);
      errorList.add(str);
    }
  }
  void clearError() {
    errorList.clear();
  }
}
