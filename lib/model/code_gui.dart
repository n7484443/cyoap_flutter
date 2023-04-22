import 'package:cyoap_core/choiceNode/pos.dart';
import 'package:cyoap_core/grammar/recursive_parser.dart';
import 'package:cyoap_core/grammar/value_type.dart';
import 'package:cyoap_flutter/util/icc_file_parsing.dart';

class CodePosSet {
  Pos pos;
  List<CodePosSet>? codePosSets;

  CodePosSet({
    required this.pos,
    this.codePosSets,
  });
}

enum CodeBlockType {
  ifBlock(name: 'if'),
  forBlock(name: 'for'),
  conditionBlock(name: 'condition'),
  setBlock(name: 'set'),
  codeBlock(name: 'code');

  const CodeBlockType({required this.name});

  final String name;

  CodeBlockBuild Function() toCodeBlock() {
    switch (this) {
      case CodeBlockType.ifBlock:
        return () => CodeBlockIf();
      case CodeBlockType.forBlock:
        return () => CodeBlockFor();
      case CodeBlockType.conditionBlock:
        return () => CodeBlock();
      case CodeBlockType.setBlock:
        return () => CodeBlockSetter();
      case CodeBlockType.codeBlock:
        return () => CodeBlock();
    }
  }

  static List<CodeBlockBuild>? fromAst(RecursiveUnit unit) {
    if (unit is RecursiveData) {
      return [CodeBlock(code: unit.body.data)];
    }
    unit = unit as RecursiveFunction;
    var body = unit.body;
    if (body.type.isString && body.data == "doLines") {
      return unit.child
          .expand<CodeBlockBuild>((e) => fromAst(e) ?? [])
          .toList();
    }
    if (body.type.isString && body.data == "if") {
      var block = CodeBlockIf(
        code: fromAst(unit.child[0])?.first.toString() ?? '',
        childT: [
          ...?fromAst(unit.child[1]),
        ],
        childF: [
          ...?fromAst(unit.child[2]),
        ],
      );
      return [block];
    }
    if (body.type.isString && body.data == "for") {
      var variable = fromAst(unit.child[0].child[0]);
      var range = fromAst(unit.child[0].child[1]);
      var block = CodeBlockFor(
        code: variable?.first.toString() ?? '',
        range: range?.first.toString() ?? '',
        child: [
          ...?fromAst(unit.child[1]),
        ],
      );
      return [block];
    }
    if (body.type.isString && body.data == "to") {
      var block = CodeBlock(
        code:
            '${fromAst(unit.child[0])?.first.toString()}..${fromAst(unit.child[1])?.first.toString()}',
      );
      return [block];
    }
    if (body.type.isString &&
        (body.data == "loadVariable" || body.data == "in")) {
      return fromAst(unit.child[0]);
    }
    if (body.type.isString &&
        (body.data == "setGlobal" ||
            body.data == "setLocal" ||
            body.data == "setVariable")) {
      var setterType = body.data == "setGlobal"
          ? SetterType.setGlobal
          : body.data == "setLocal"
              ? SetterType.setLocal
              : SetterType.setVariable;
      var block = CodeBlockSetter(
        left: fromAst(unit.child[0])?.first.toString(),
        right: fromAst(unit.child[1])?.first.toString(),
        type: setterType,
      );
      return [block];
    }
    if (body.type.isString) {
      var block = CodeBlock(
          code:
              '${fromAst(unit.child[0])?.first.toString()} ${body.data} ${fromAst(unit.child[0])?.first.toString()}');
      return [block];
    }
    return [CodeBlock(code: unit.toString())];
  }
}

abstract class CodeBlockBuild {
  String build();

  List<CodeBlockBuild>? get child;

  CodeBlockBuild? parent;
  Pos? pos;

  CodeBlockBuild search(Pos pos) {
    if (pos.isEmpty) {
      return this;
    }
    int first = pos.first;
    return child![first].search(pos.removeFirst());
  }

  void add(CodeBlockBuild codeBlock, {bool option = true}) {
    child?.add(codeBlock);
    codeBlock.parent = this;
  }

  CodeBlockBuild? remove(int index) {
    return child?.removeAt(index);
  }

  void updatePos(Pos pos) {
    this.pos = pos;
    if (child != null) {
      for (int i = 0; i < child!.length; i++) {
        child![i].updatePos(pos.addLast(i));
      }
    }
  }

  String getKey() {
    return generateRandomString(10);
  }
}

class CodeBlockSet extends CodeBlockBuild {
  List<CodeBlockBuild> codeBlocks = [];

  CodeBlockSet({
    List<CodeBlockBuild>? codeBlocks,
  }) {
    this.codeBlocks.addAll(codeBlocks ?? []);
  }

  @override
  String build() {
    return codeBlocks.map((e) => e.build()).join("\n");
  }

  @override
  List<CodeBlockBuild>? get child => codeBlocks;
}

class CodeBlock extends CodeBlockBuild {
  String code;

  CodeBlock({
    this.code = '',
  });

  @override
  String build() {
    return code;
  }

  @override
  List<CodeBlockBuild>? get child => null;

  @override
  String toString() {
    return code;
  }
}

class CodeBlockIf extends CodeBlockBuild {
  final String code;
  final List<CodeBlockBuild> childTrue = [];
  final List<CodeBlockBuild> childFalse = [];

  CodeBlockIf({
    this.code = '',
    List<CodeBlockBuild>? childT,
    List<CodeBlockBuild>? childF,
  }) {
    if (childT != null) {
      childTrue.addAll(childT);
    }
    if (childF != null) {
      childFalse.addAll(childF);
    }
  }

  @override
  String build() {
    String trueCode = '';
    String falseCode = '';
    trueCode = childTrue.map((e) => e.build()).join("\n");
    falseCode = childFalse.map((e) => e.build()).join("\n");
    return """
    \n
    if($code){
      $trueCode
    } else {
      $falseCode
    }
    """;
  }

  @override
  void add(CodeBlockBuild codeBlock, {bool option = true}) {
    if (option) {
      childTrue.add(codeBlock);
    } else {
      childFalse.add(codeBlock);
    }
    codeBlock.parent = this;
  }

  @override
  CodeBlockBuild? remove(int index) {
    if (index < childTrue.length) {
      return childTrue.removeAt(index);
    }
    return childFalse.removeAt(index - childTrue.length);
  }

  @override
  List<CodeBlockBuild>? get child => [...childTrue, ...childFalse];
}

class CodeBlockFor extends CodeBlockBuild {
  final String code;
  final String range;
  final List<CodeBlockBuild> childFor = [];

  CodeBlockFor({
    this.code = '',
    this.range = '',
    List<CodeBlockBuild>? child,
  }) {
    if (child != null) {
      childFor.addAll(child);
    }
  }

  @override
  String build() {
    var childCode = childFor.map((e) => e.build()).join("\n");
    return """
    \n
    for($code in $range) {
      $childCode
    }
    """;
  }

  @override
  List<CodeBlockBuild>? get child => childFor;
}

enum SetterType { setGlobal, setLocal, setVariable }

class CodeBlockSetter extends CodeBlock {
  final String? left;
  final SetterType type;
  final String? right;

  CodeBlockSetter({
    this.left,
    this.type = SetterType.setVariable,
    this.right,
  }) {
    if (type == SetterType.setVariable) {
      super.code = '{r set} $left as $right';
    }else if (type == SetterType.setGlobal) {
      super.code = '{r create} {b global} $left as $right';
    }else{
      super.code = '{r create} {b local} $left as $right';
    }
  }

  @override
  String build() {
    if (type == SetterType.setVariable) {
      return '$left = $right';
    }
    if (type == SetterType.setGlobal) {
      return 'let $left = $right';
    }
    return 'var $left = $right';
  }
}
