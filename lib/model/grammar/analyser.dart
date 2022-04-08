import 'package:cyoap_flutter/model/grammar/lexical_analyser.dart';
import 'package:cyoap_flutter/model/grammar/recursive_parser.dart';
import 'package:cyoap_flutter/model/grammar/semantic_analyser.dart';

import 'function_list.dart';
import 'token.dart';

class Analyser {
  Analyser._init() {
    functionList.init();
  }
  static final Analyser _instance = Analyser._init();

  factory Analyser(){
    return _instance;
  }

  LexicalAnalyser lexicalAnalyser = LexicalAnalyser();
  SyntaxAnalyser syntaxAnalyser = SyntaxAnalyser();
  SemanticAnalyser semanticAnalyser = SemanticAnalyser();
  Functions functionList = Functions();

  List<RecursiveUnit> analyse(String codeInput) {
    List<RecursiveUnit> recursiveList = List.empty(growable: true);
    var codes = codeInput.split('\n');
    for (var code in codes) {
      try{
        if (code.isEmpty) {
          continue;
        }
        var tokens = lexicalAnalyser.analyze(code);
        if (syntaxAnalyser.checkSyntax(tokens)) {
          var t = semanticAnalyser.compile(tokens);
          recursiveList.add(t);
        }
      }catch(e){
        print('something wrong in $code');
      }
    }
    return recursiveList;
  }

  static List<RecursiveUnit> analyseCodes(String codeInput) {
    return _instance.analyse(codeInput);
  }
}

class SyntaxAnalyser {
  bool checkSyntax(List<Token> tokens) {
    return true;
  }
}
