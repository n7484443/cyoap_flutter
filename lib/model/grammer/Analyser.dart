import 'AnalyzerConst.dart';
import 'LexicalAnalyser.dart';
import 'ParsingUnit.dart';
import 'Recursive_Parser.dart';
import 'ValueType.dart';
import 'VariableDataBase.dart';

class RecursiveSet {
  RecursiveParser parser;
  int i;

  RecursiveSet(this.parser, this.i);
}

class Analyser{
  static final Analyser instance = Analyser();
  RecursiveParser parserNull = RecursiveParser();
  RecursiveParser parserComma = RecursiveParser();

  static Analyser getInstance() {
    return instance;
  }

  /*
     * 문자 입력->텍스트와 문법을 분리 {} 내부에 문법 사용. 즉, 실제 사용 가능한 것은 [], () 정도.
     */
  List<String> parserLines(String str) {
    return str.split("\n").toList();
  }

  RecursiveSet create_parser(int i, List<ParsingUnit> data,
      RecursiveParser motherParser) {
    if (i >= data.length) return RecursiveSet(motherParser, i);
    switch (data[i].type) {
      case AnalyzerConst.function_start :
        while (true) {
          var inner = create_parser(i + 1, data, motherParser);
          i = inner.i;
          var inner_parser = inner.parser;
          if (inner_parser == parserComma) {
            i++;
            continue;
          } else if (inner_parser == parserNull) {
            break;
          }

          motherParser.add(inner_parser);
        }
        return RecursiveSet(motherParser, i);
      case AnalyzerConst.function_end:
        return RecursiveSet(parserNull, i);
      case AnalyzerConst.function:
        RecursiveParser func_parser = RecursiveParser();
        func_parser.value = ValueType(types.functions);
        func_parser.value.setData(data[i].data);
        return create_parser(i + 1, data, func_parser);
      case AnalyzerConst.function_comma:
        i++;
        return RecursiveSet(parserComma, i);
      default :
        RecursiveParser new_parser = RecursiveParser();
        if (data[i].type == AnalyzerConst.variable_name) {
          new_parser.value = ValueType(
              VariableDataBase.getInstance().getValue(data[i].data));
        } else {
          new_parser.value = ValueType(
              LexicalAnalyzer.getInstance().getTypeFromInt(data[i]));
          new_parser.value.setData(data[i].data);
        }

        RecursiveParser function_parser = RecursiveParser();

        if (data.length >= i + 2) {
          if (data[i + 1].type == AnalyzerConst.function_unspecified) {
            function_parser.value = ValueType(types.functions);
            function_parser.value.data = data[i + 1].data;
            function_parser.add(new_parser);
            var v = create_parser(i + 2, data, function_parser);
            i = v.i;
            function_parser.add(v.parser);
            return RecursiveSet(function_parser, i);
          }
        }

        return RecursiveSet(new_parser, i);
    }
  }

  void analyseLines(List<ParsingUnit> analysed_data) {
    if (analysed_data.isEmpty) return;
    RecursiveParser parser = RecursiveParser();

    if (analysed_data[0].data == "if" &&
        analysed_data[0].type == AnalyzerConst.function) {
      var comma = [0, 0];
      for (int i = 0; i < analysed_data.length; i++) {
        if (analysed_data[i].type == AnalyzerConst.function_comma) {
          if (comma[0] == 0) {
            comma[0] = i;
          } else {
            comma[1] = i;
            break;
          }
        }
      }
      var list_check = analysed_data.sublist(2, comma[0]);
      var list_true = analysed_data.sublist(
          comma[0] + 1, comma[1]);
      var list_false = analysed_data.sublist(
          comma[1] + 1, analysed_data.length - 1);


      var parser_ans = create_parser(0, list_check, parser);
      bool check = parser_ans.parser.unzip().getData();
      if (check) {
        analyseLines(list_true);
      } else {
        analyseLines(list_false);
      }
      return;
    }
    int equalPos = -1;
    for (int i = 0; i < analysed_data.length; i++) {
      if (analysed_data[i].type == AnalyzerConst.equal) {
        equalPos = i;
        break;
      }
    }

    if (equalPos == -1) {
      throw Exception("something wrong!");
    }
    var parser_ans = create_parser(equalPos + 1, analysed_data, parser);

    if (analysed_data[equalPos - 1].type == AnalyzerConst.variable_name) {
      String name = analysed_data[equalPos - 1].data;
      var dataAnswer = parser_ans.parser.unzip();
      VariableDataBase.getInstance().setValue(name, dataAnswer);
    }
  }

  bool analyseConditional(List<ParsingUnit> analysed_data) {
    if (analysed_data.isEmpty) {
      throw Exception("something wrong!");
    }
    RecursiveParser parser = RecursiveParser();

    var parser_ans = create_parser(0, analysed_data, parser);

    var t = parser_ans.parser.unzip().getData();
    if (t is bool) {
      return (bool) t;
    } else {
      throw Exception("something wrong!");
    }
  }

  void analyseList(List<String> str_list) {
    for (var str in str_list) {
      analyseLines(LexicalAnalyzer.getInstance().analyze(str));
    }
    print("all parsing end\n");
  }

  bool analyseConditional(String str) {
    return analyseConditional(LexicalAnalyzer.getInstance().analyze(str));
  }
}