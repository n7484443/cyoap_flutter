import 'package:cyoap_flutter/model/grammar/analyser_const.dart';
import 'package:cyoap_flutter/model/grammar/recursive_parser.dart';
import 'package:cyoap_flutter/model/grammar/token.dart';
import 'package:cyoap_flutter/model/grammar/value_type.dart';

import 'analyser.dart';

class SemanticAnalyser {
  RecursiveUnit parserNull = RecursiveData(ValueType.none());
  RecursiveUnit parserComma = RecursiveData(ValueType.comma());
  RecursiveUnit parserEnd = RecursiveData(ValueType.comma());

  RecursiveUnit compile(List<Token> tokens) {
    return analyseLines(tokens);
  }

  List<Token> tokens = List.empty(growable: true);

  RecursiveUnit recursiveCreate(RecursiveUnit motherUnit) {
    if (tokens.isEmpty) {
      return parserEnd;
    }
    var t = tokens.removeAt(0);
    switch (t.type) {
      case AnalyserConst.functionStart:
        while (true) {
          var inner = recursiveCreate(motherUnit);
          if (inner == parserComma) {
            continue;
          } else if (inner == parserEnd) {
            break;
          }
          motherUnit.add(inner);
        }
        return motherUnit;
      case AnalyserConst.functionEnd:
        return parserEnd;
      case AnalyserConst.function:
        var funcParser = RecursiveParser(ValueType(t.data));
        return recursiveCreate(funcParser);
      case AnalyserConst.functionComma:
        return parserComma;
      default:
        RecursiveData newParser;
        if (t.type == AnalyserConst.variableName) {
          newParser = RecursiveData(ValueType(VariableUnit(t.dataString)));
        } else {
          newParser = RecursiveData(ValueType(t.data));
        }

        if (tokens.isNotEmpty) {
          var tokenAfter = tokens[0];
          if (tokenAfter.type == AnalyserConst.functionUnspecified) {
            tokens.removeAt(0);
            var functionParser = RecursiveParser(ValueType(tokenAfter.data));
            var v = recursiveCreate(functionParser);
            functionParser.add(newParser);
            functionParser.add(v);
            return functionParser;
          }
        }
        return newParser;
    }
  }

  void init() {
    tokens.clear();
  }

  RecursiveUnit analyseLines(List<Token> analysedData) {
    if (analysedData.isEmpty) return parserNull;
    init();

    if (analysedData[0].dataString == "if" &&
        analysedData[0].type == AnalyserConst.function) {
      List<int> comma = [0, 0];
      for (int i = 0; i < analysedData.length; i++) {
        if (analysedData[i].type == AnalyserConst.functionComma) {
          if (comma[0] == 0) {
            comma[0] = i;
          } else {
            comma[1] = i;
            break;
          }
        }
      }
      List<Token> listCheck = analysedData.sublist(2, comma[0]);
      List<Token> listTrue = analysedData.sublist(comma[0] + 1, comma[1]);
      List<Token> listFalse =
          analysedData.sublist(comma[1] + 1, analysedData.length - 1);

      return RecursiveParser(ValueType(analysedData[0].data))
        ..add(analyseLines(listCheck))
        ..add(analyseLines(listTrue))
        ..add(analyseLines(listFalse));
    }
    int equalPos = -1;
    for (int i = 0; i < analysedData.length; i++) {
      if (analysedData[i].dataString == '=') {
        equalPos = i;
        break;
      }
    }

    RecursiveParser parser = RecursiveParser(ValueType.none());
    if (equalPos == -1) {
      tokens.addAll(analysedData);
      return recursiveCreate(parser);
    }
    tokens.addAll(analysedData.sublist(equalPos + 1));
    var parserAns = recursiveCreate(parser);

    if (analysedData[equalPos - 1].type == AnalyserConst.variableName) {
      var createGlobal = equalPos == 2 ? analysedData[0].type == AnalyserConst.variableLet : null;
      var recursive = RecursiveData(
          ValueType(VariableUnit(analysedData[equalPos - 1].dataString)));
      return RecursiveParser(ValueType(Analyser().functionList.funcSet), createAsGlobal: createGlobal)
        ..add(recursive)
        ..add(parserAns);
    }
    throw Error();
  }
}
