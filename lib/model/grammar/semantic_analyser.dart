import 'analyser_const.dart';
import 'recursive_parser.dart';
import 'token.dart';
import 'value_type.dart';

import 'analyser.dart';

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
          RecursiveFunction sub = RecursiveFunction(ValueType.string(token.data));
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
          RecursiveFunction sub = RecursiveFunction(const ValueType.string("doLines"));
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
          RecursiveFunction sub = RecursiveFunction(const ValueType.string("if"));
          pointer.add(sub);
          pointer = sub;
          break;
        case AnalyserConst.function:
          RecursiveFunction sub = RecursiveFunction(ValueType.string(token.data));
          pointer.add(sub);
          pointer = sub;
          break;
        case AnalyserConst.functionStart:
          break;
        case AnalyserConst.functionEnd:
          pointer = pointer.parent!;
          break;
        case AnalyserConst.functionComma:
          while (!Analyser().functionList.hasFunction(pointer.body.data) ||
              Analyser()
                  .functionList
                  .isUnspecifiedFunction(pointer.body.data)) {
            pointer = pointer.parent!;
          }
          break;
        case AnalyserConst.variableName:
          RecursiveUnit out = RecursiveFunction(const ValueType.string("loadVariable"));
          out.add(RecursiveData(ValueType.string(token.dataString)));
          pointer.add(out);
          break;
        case AnalyserConst.lineEnd:
          while (pointer.body.data != "doLines" &&
              pointer.body.data != "returnCondition") {
            pointer = pointer.parent!;
          }
          break;
        default:
          var sub = RecursiveData(getValueTypeFromDynamicInput(token.data));
          pointer.add(sub);
          break;
      }
    }
  }

  RecursiveUnit optimizeTree(RecursiveUnit mother) {
    RecursiveUnit output = mother;
    List<RecursiveUnit> needVisit = List.from([mother], growable: true);
    while (needVisit.isNotEmpty) {
      var pointer = needVisit.removeAt(0);
      if (pointer.body.data == "doLines" && pointer.child.length == 1) {
        var replace = pointer.child.first;
        if (pointer.parent != null) {
          var parentChildList = pointer.parent!.child;
          var pos = parentChildList.indexOf(pointer);
          if (pos != -1) {
            parentChildList[pos] = replace;
            replace.parent = pointer.parent;
            needVisit.add(replace);
          }
        } else {
          output = replace;
          replace.parent = null;
        }
      } else {
        for (var child in pointer.child) {
          needVisit.add(child);
        }
      }
    }
    return output;
  }

  RecursiveUnit? analyseLines(List<Token> analysedData) {
    if (analysedData.isEmpty) return null;
    RecursiveUnit mother = RecursiveFunction(const ValueType.string("doLines"));
    abstractSyntaxTreeAnalyse(mother, analysedData);
    return optimizeTree(mother);
  }

  RecursiveUnit? analyseLine(List<Token> analysedData) {
    if (analysedData.isEmpty) return null;
    RecursiveUnit mother = RecursiveFunction(const ValueType.string("returnCondition"));
    abstractSyntaxTreeAnalyse(mother, analysedData);
    return mother;
  }
}
