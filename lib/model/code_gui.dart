import 'package:cyoap_core/choiceNode/pos.dart';

class CodeBlock {
  Pos pos;
  String code;

  CodeBlock({required this.code, int index = 0}) : pos = Pos(data: [index]);

  String build() {
    return "\n$code";
  }
}

class CodeBlockIf extends CodeBlock {
  List<CodeBlock> childTrue = [];
  List<CodeBlock> childFalse = [];

  CodeBlockIf(
      {required super.code,
      required List<CodeBlock> childTrue,
      required List<CodeBlock> childFalse}) {
    for (int i = 0; i < childFalse.length; i++) {
      this.childFalse.add(childFalse[i]..pos = pos.addLast(i));
    }
    for (int i = 0; i < childTrue.length; i++) {
      this.childTrue.add(childTrue[i]..pos = pos.addLast(i));
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
}

class CodeBlockFor extends CodeBlock {
  List<CodeBlock> child = [];
  String range;

  CodeBlockFor(
      {required super.code,
      required this.range,
      required List<CodeBlock> codeBlock}) {
    for (int i = 0; i < codeBlock.length; i++) {
      this.child.add(codeBlock[i]..pos = pos.addLast(i));
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
}
