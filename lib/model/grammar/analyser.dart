import 'package:cyoap_flutter/model/grammar/lexical_analyser.dart';
import 'package:cyoap_flutter/model/grammar/recursive_parser.dart';
import 'package:cyoap_flutter/model/grammar/semantic_analyser.dart';

import 'function_list.dart';
import 'token.dart';

class Analyser{
  static Analyser instance = Analyser();
  LexicalAnalyser lexicalAnalyser = LexicalAnalyser();
  SyntaxAnalyser syntaxAnalyser = SyntaxAnalyser();
  SemanticAnalyser semanticAnalyser = SemanticAnalyser();
  FunctionList functionList = FunctionList();

  List<RecursiveUnit> analyse(String codeInput){
    List<RecursiveUnit> recursiveList = List.empty(growable: true);
    var codes = codeInput.split('\n');
    for(var code in codes){
      var tokens = lexicalAnalyser.analyze(code);
      if(syntaxAnalyser.checkSyntax(tokens)){
        recursiveList.add(semanticAnalyser.compile(tokens));
      }
    }
    return recursiveList;
  }
  static List<RecursiveUnit> analyseCodes(String codeInput){
    return instance.analyse(codeInput);
  }
}

class SyntaxAnalyser {
  bool checkSyntax(List<Token> tokens){
    return true;
  }
}