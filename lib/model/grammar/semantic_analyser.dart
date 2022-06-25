import 'package:cyoap_flutter/model/grammar/analyser_const.dart';
import 'package:cyoap_flutter/model/grammar/recursive_parser.dart';
import 'package:cyoap_flutter/model/grammar/token.dart';
import 'package:cyoap_flutter/model/grammar/value_type.dart';

class SemanticAnalyser {
  static const int blockEndSign = -1;
  static const int functionEndSign = -2;

  ///-1:block end
  void abstractSyntaxTreeAnalyse(RecursiveUnit mother, List<Token> tokens) {
    RecursiveUnit pointer = mother;
    for (var pos = 0; pos < tokens.length; pos++) {
      var token = tokens[pos];
      switch (token.type) {
        case AnalyserConst.functionUnspecified:
          RecursiveFunction sub = RecursiveFunction(ValueType(token.data));
          var deleted = pointer.child.removeLast();
          pointer.add(sub);
          if (token.data == "setLocal" ||
              token.data == "setGlobal" ||
              token.data == "setVariable") {
            sub.add(RecursiveData(deleted.child[0].body));
          } else {
            sub.add(deleted);
          }
          pointer = sub;
          break;
        case AnalyserConst.blockStart:
          RecursiveFunction sub = RecursiveFunction(ValueType("doLines"));
          pointer.add(sub);
          pointer = sub;
          break;
        case AnalyserConst.blockEnd:
          while (pointer.body.data != "if") {
            pointer = pointer.parent!;
          }
          if (!(pos + 1 < tokens.length &&
              tokens[pos + 1].type == AnalyserConst.functionElse)) {
            pointer = pointer.parent!;
          }
          break;
        case AnalyserConst.functionElse:
          break;
        case AnalyserConst.functionIf:
          RecursiveFunction sub = RecursiveFunction(ValueType("if"));
          pointer.add(sub);
          pointer = sub;
          break;
        case AnalyserConst.function:
          RecursiveFunction sub = RecursiveFunction(ValueType(token.data));
          pointer.add(sub);
          pointer = sub;
          break;
        case AnalyserConst.functionStart:
          break;
        case AnalyserConst.functionEnd:
          pointer = pointer.parent!;
          break;
        case AnalyserConst.functionComma:
          break;
        case AnalyserConst.variableName:
          RecursiveUnit out = RecursiveFunction(ValueType("loadVariable"));
          out.add(RecursiveData(ValueType(token.dataString)));
          pointer.add(out);
          break;
        case AnalyserConst.lineEnd:
          while (pointer.body.data != "doLines" &&
              pointer.body.data != "condition") {
            pointer = pointer.parent!;
          }
          break;
        default:
          var sub = RecursiveData(ValueType(token.data));
          pointer.add(sub);
          break;
      }

      // print("mother : $mother");
      // print("pointer : $pointer");
      // print("token : $token");
      // print("");
    }
  }

  RecursiveUnit? analyseLines(List<Token> analysedData) {
    if (analysedData.isEmpty) return null;
    RecursiveUnit mother = RecursiveFunction(ValueType("doLines"));
    abstractSyntaxTreeAnalyse(mother, analysedData);
    return mother;
  }

  RecursiveUnit? analyseLine(List<Token> analysedData) {
    if (analysedData.isEmpty) return null;
    RecursiveUnit mother = RecursiveFunction(ValueType("condition"));
    abstractSyntaxTreeAnalyse(mother, analysedData);
    return mother;
  }
}
