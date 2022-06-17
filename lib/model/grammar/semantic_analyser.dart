import 'package:cyoap_flutter/model/grammar/analyser_const.dart';
import 'package:cyoap_flutter/model/grammar/recursive_parser.dart';
import 'package:cyoap_flutter/model/grammar/token.dart';
import 'package:cyoap_flutter/model/grammar/value_type.dart';

import 'analyser.dart';

class SemanticAnalyser {
  RecursiveUnit parserNull = RecursiveData(ValueType.none());
  RecursiveUnit parserComma = RecursiveData(ValueType.comma());
  RecursiveUnit parserEnd = RecursiveData(ValueType.comma());

  RecursiveUnit loopRecursive(List<Token> tokens) {
    var motherUnit = RecursiveParser(ValueType.none());
    List<RecursiveUnit> stack = List.empty(growable: true);
    while (tokens.isNotEmpty) {
      print("token : $tokens stack : $stack");
      var token = tokens.removeAt(0);
      switch (token.type) {
        case AnalyserConst.functionEnd | AnalyserConst.functionComma:
          if (stack.length == 1) {
            motherUnit.add(stack.removeLast());
          } else {
            var t = stack.removeLast();
            stack.last.childNode.add(t);
          }
          break;
        case AnalyserConst.function:
          stack.add(RecursiveParser(ValueType(token.data)));
          break;
        case AnalyserConst.variableLet:
          stack.add(RecursiveParser(
              ValueType(Analyser().functionList.funcSetGlobal)));
          break;
        case AnalyserConst.variableVar:
          stack.add(
              RecursiveParser(ValueType(Analyser().functionList.funcSetLocal)));
          break;
        case AnalyserConst.variableName:
          stack.add(RecursiveParser(
              ValueType(Analyser().functionList.funcSetVariable)));
          break;
        case AnalyserConst.functionUnspecified:
          var functionParser = RecursiveParser(ValueType(token.data));
          var before = stack.removeLast();
          functionParser.childNode.add(before);
          stack.add(functionParser);
          break;
        default:
          if (stack.last.value.data ==
              Analyser().functionList.funcSetVariable) {
            stack.last.childNode
                .add(RecursiveData(ValueType(VariableUnit(token.dataString))));
          } else {
            stack.last.childNode.add(RecursiveData(ValueType(token.data)));
          }
          break;
      }
    }

    return motherUnit;
  }

  RecursiveUnit analyseLines(List<Token> analysedData) {
    if (analysedData.isEmpty) return parserNull;
    return loopRecursive(analysedData);
  }
}
