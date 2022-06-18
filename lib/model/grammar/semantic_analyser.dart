import 'package:cyoap_flutter/model/grammar/analyser_const.dart';
import 'package:cyoap_flutter/model/grammar/recursive_parser.dart';
import 'package:cyoap_flutter/model/grammar/token.dart';
import 'package:cyoap_flutter/model/grammar/value_type.dart';

import 'analyser.dart';

class SemanticAnalyser {
  RecursiveUnit parserNull = RecursiveData(ValueType.none());
  RecursiveUnit parserComma = RecursiveData(ValueType.comma());
  RecursiveUnit parserEnd = RecursiveData(ValueType.comma());

  ///-1:block end
  int recursiveAnalyse(
      RecursiveUnit parent, List<Token> tokens, int posFromParent) {
    var pos = posFromParent;
    if (pos >= tokens.length) {
      return -1;
    }
    var token = tokens[pos];
    switch (token.type) {
      case AnalyserConst.functionIf:
      case AnalyserConst.function:
      case AnalyserConst.blockStart:
        RecursiveFunction sub;
        if (token.type == AnalyserConst.blockStart) {
          sub = RecursiveFunction(ValueType(Analyser().functionList.doLines));
        } else {
          sub = RecursiveFunction(ValueType(token.data));
          pos++;
        }
        parent.add(sub);
        while (true) {
          var outPos = recursiveAnalyse(sub, tokens, pos + 1);
          if (outPos == -1) {
            pos++;
            break;
          }
          pos = outPos;
        }
        break;
      case AnalyserConst.functionComma:
        pos++;
        break;
      case AnalyserConst.blockEnd:
      case AnalyserConst.functionEnd:
        return -1;
      case AnalyserConst.variableName:
        var out = RecursiveFunction(ValueType(Analyser().functionList.funcLoadVariable));
        out.add(RecursiveData(ValueType(token.dataString)));
        parent.add(out);
        break;
      case AnalyserConst.functionUnspecified:
        var out = parent.child.removeLast();
        var subParent = RecursiveFunction(ValueType(token.data));
        subParent.add(out);
        while (true) {
          var outPos = recursiveAnalyse(subParent, tokens, pos + 1);
          if (outPos == -1) {
            pos++;
            break;
          }
          pos = outPos;
        }
        parent.add(subParent);
        break;
      case AnalyserConst.functionElse:
        break;
      default:
        parent.add(RecursiveData(ValueType(token.data)));
        break;
    }
    return pos;
  }

  RecursiveUnit analyseLines(List<Token> analysedData) {
    if (analysedData.isEmpty) return parserNull;
    var parent = RecursiveFunction(ValueType(Analyser().functionList.doLines));
    recursiveAnalyse(parent, analysedData, 0);
    return parent;
  }
}
