import 'package:cyoap_core/choiceNode/pos.dart';
import 'package:cyoap_core/grammar/ast.dart';
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

  static CodeBlockBuild fromAst(AST unit) {
    if (unit.child.isEmpty) {
      return CodeBlock(code: unit.body.data);
    }
    var body = unit.body;
    if (body.isString && body.data == "doLines") {
      return CodeBlockSet(
        codeBlocks: unit.child.map((e) => fromAst(e)).toList(),
      );
    }
    if (body.isString && body.data == "if") {
      var block = CodeBlockIf(
        code: fromAst(unit.child[0]),
        childT: fromAst(unit.child[1]),
        childF: unit.child.length == 3 ? fromAst(unit.child[2]) : null,
      );
      return block;
    }
    if (body.isString && body.data == "for") {
      var variable = fromAst(unit.child[0].child[0]);
      var range = fromAst(unit.child[0].child[1]);
      return CodeBlockFor(
        code: variable.toString(),
        range: range.toString(),
        child: [
          ...?(fromAst(unit.child[1]) as CodeBlockSet?)?.child,
        ],
      );
    }
    if (body.isString && body.data == "to") {
      var block = CodeBlock(
        code:
            '${fromAst(unit.child[0]).toString()}..${fromAst(unit.child[1]).toString()}',
      );
      return block;
    }
    if (body.isString && (body.data == "loadVariable" || body.data == "in")) {
      return fromAst(unit.child[0]);
    }
    if (body.isString &&
        (body.data == "setGlobal" ||
            body.data == "setLocal" ||
            body.data == "setVariable")) {
      var setterType = body.data == "setGlobal"
          ? SetterType.setGlobal
          : body.data == "setLocal"
              ? SetterType.setLocal
              : SetterType.setVariable;
      var block = CodeBlockSetter(
        left: fromAst(unit.child[0]).toString(),
        right: fromAst(unit.child[1]).toString(),
        type: setterType,
      );
      return block;
    }
    if (body.isString) {
      //function
      var arg = unit.child.map((e) {
        var ast = fromAst(e);
        if (ast is! CodeBlockSet) {
          return ast;
        }
        return ast;
      }).toList();
      var function = body.data;
      if (unit.child.length == 1) {
        return CodeBlock(
          code: '${arg[0].toString()} $function',
        );
      }
      if (unit.child.length == 2) {
        return CodeBlock(
          code: '${arg[0].toString()} $function ${arg[1].toString()}',
        );
      }
      var code = arg.map((e) => e.toString()).join(" $function ");
      return CodeBlock(
        code: code,
      );
    }
    return CodeBlock(code: unit.toString());
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
  final CodeBlockBuild code;
  final List<CodeBlockBuild> childTrue = [];
  final List<CodeBlockBuild> childFalse = [];

  CodeBlockIf({
    CodeBlockBuild? code,
    CodeBlockBuild? childT,
    CodeBlockBuild? childF,
  }) : code = code ?? CodeBlock(code: '') {
    if (childT != null) {
      if (childT is CodeBlockSet) {
        childTrue.addAll(childT.child!);
      } else {
        childTrue.add(childT);
      }
    }
    if (childF != null) {
      if (childF is CodeBlockSet) {
        childFalse.addAll(childF.child!);
      } else {
        childFalse.add(childF);
      }
    }
  }

  @override
  String build() {
    String trueCode = '';
    String falseCode = '';
    trueCode = childTrue.map((e) => e.build()).join("\n");
    if (childFalse.isEmpty) {
      return """
      if($code){
        $trueCode
      }
      """;
    }
    falseCode = childFalse.map((e) => e.build()).join("\n");
    return """
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
    } else if (type == SetterType.setGlobal) {
      super.code = '{r create} {b global} $left as $right';
    } else {
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
