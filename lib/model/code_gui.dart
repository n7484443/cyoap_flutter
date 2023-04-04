import 'package:cyoap_core/choiceNode/pos.dart';

class CodeBlock {
  Pos pos;
  String code;

  CodeBlock({required this.code, int index = 0}) : pos = Pos(data: [index]);

  String build() {
    return "\n$code";
  }

  void update(Pos parent, int index) {
    pos = parent.addLast(index);
  }
}

class CodeBlockIf extends CodeBlock {
  List<CodeBlock> childTrue = [];
  List<CodeBlock> childFalse = [];

  CodeBlockIf(
      {required super.code,
      required List<CodeBlock> childTrue,
      required List<CodeBlock> childFalse}) {
    for (int i = 0; i < childTrue.length; i++) {
      this.childTrue.add(childTrue[i]..pos = pos.addLast(i));
    }
    for (int i = 0; i < childFalse.length; i++) {
      this
          .childFalse
          .add(childFalse[i]..pos = pos.addLast(childTrue.length + i));
    }
  }

  @override
  String build() {
    var childTrueCode = childTrue.map((e) => e.build()).join("\n");
    var childFalseCode = childFalse.map((e) => e.build()).join("\n");
    return """
    \n
    if $code {
      $childTrueCode
    } else {
      $childFalseCode
    }
    """;
  }

  @override
  void update(Pos parent, int index) {
    pos = parent.addLast(index);
    for (int i = 0; i < childTrue.length; i++) {
      childTrue[i].update(pos, i);
    }
    for (int i = 0; i < childFalse.length; i++) {
      childFalse[i].update(pos, childTrue.length + i);
    }
  }
}

class CodeBlockFor extends CodeBlock {
  List<CodeBlock> child = [];
  String range;

  CodeBlockFor(
      {required super.code,
      required this.range,
      required List<CodeBlock> codeBlock}) {
    for (int i = 0; i < codeBlock.length; i++) {
      child.add(codeBlock[i]..pos = pos.addLast(i));
    }
  }

  @override
  String build() {
    var childCode = child.map((e) => e.build()).join("\n");
    return """
    \n
    for($code in $range) {
      $childCode
    }
    """;
  }

  @override
  void update(Pos parent, int index) {
    pos = parent.addLast(index);
    for (int i = 0; i < child.length; i++) {
      child[i].update(pos, i);
    }
  }
}
