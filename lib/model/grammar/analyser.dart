import 'package:cyoap_flutter/model/grammar/lexical_analyser.dart';
import 'package:cyoap_flutter/model/grammar/recursive_parser.dart';
import 'package:cyoap_flutter/model/grammar/semantic_analyser.dart';
import 'package:cyoap_flutter/model/grammar/token.dart';
import 'package:cyoap_flutter/model/grammar/value_type.dart';

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
    tokenList = lexicalAnalyser.changeToFunction(tokenList);
    return tokenList;
  }

  List<String> toByteCode(RecursiveUnit input){
    //input 을 받아서 bytecode로 변환, if는 goto문으로 작성.
    return input.toByteCode().where((e) => e.isNotEmpty).toList();
  }

  List<String> analyseMultiLine(String? codeInput, {String pos = ""}) {
    if (codeInput == null || codeInput.trim().isEmpty) return [];
    try {
      var out = semanticAnalyser.analyseLines(toTokenList(codeInput));
      return toByteCode(out!);
    } catch (e, stackTrace) {
      addError("$pos, $e", stackTrace);
    }
    return [];
  }

  List<String> analyseSingleLine(String? codeInput, {String pos = ""}) {
    if (codeInput == null || codeInput.trim().isEmpty) return [];
    try {
      var out = semanticAnalyser.analyseLine(toTokenList(codeInput));
      return toByteCode(out!);
    } catch (e, stackTrace) {
      addError("$pos, $e", stackTrace);
    }
    return [];
  }

  bool? run(List<String> unitList, {String pos = ""}) {
    if (unitList.isEmpty) return null;
    try{
      List<ValueType> stack = [];
      for(int line = 0; line < unitList.length; line++){
        var code = unitList[line];
        var spaceIndex = code.indexOf(" ");
        spaceIndex = spaceIndex == -1 ? code.length : spaceIndex;
        var opCode = code.substring(0, spaceIndex);
        var argument = spaceIndex < code.length ? code.substring(spaceIndex + 1, code.length) : null;
        if(opCode == "push"){
          stack.add(getValueTypeFromStringInput(argument!));
        }else if(opCode == "return"){
          var out = stack.removeLast().dataUnzip;
          return out as bool;
        }else if(opCode == "if_goto"){
          if(stack.removeLast().dataUnzip as bool){
            continue;
          }else{
            line += int.parse(argument!);
          }
        }else if(opCode == "goto"){
          line += int.parse(argument!);
        }else{
          var funcEnum = FunctionListEnum.getFunctionListEnum(opCode);
          var func = functionList.getFunction(funcEnum);
          if(func == null){
            addError("$pos, $opCode is not a function", StackTrace.current);
            return null;
          }
          //기본적으로 funcEnum.argumentLength 개의 인자를 사용함. code[1] 가 존재시 인자의 개수로 사용
          var argCount = funcEnum.argumentLength;
          if(argument != null && funcEnum.hasMultipleArgument){
            argCount = int.parse(argument);
          }
          List<ValueType> argumentList = [];
          for(int i = 0; i < argCount; i++){
            argumentList.add(stack.removeLast());
          }
          argumentList = argumentList.reversed.toList();
          ValueType? out = func(argumentList);
          if(out != null){
            stack.add(out);
          }
        }
      }
    }catch (e, stackTrace) {
      addError("$pos, $e", stackTrace);
    }
    return null;
  }

  void addError(String str, StackTrace stackTrace) {
    if(!errorList.contains(str)) {
      print("$str $stackTrace");
      errorList.add(str);
    }
  }
  void clearError() {
    errorList.clear();
  }
}
