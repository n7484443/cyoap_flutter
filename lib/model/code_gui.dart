import 'package:cyoap_core/choiceNode/pos.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'code_gui.freezed.dart';

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
      case CodeBlockType.codeBlock:
        return () => CodeBlock();
    }
  }
}

mixin CodeBlockBuild {
  String build();

  List<CodeBlockBuild>? get child;

  CodeBlockBuild? parent;
  Pos? pos;

  CodeBlockBuild search(Pos pos) {
    if (pos.isEmpty) {
      return this;
    }
    return child![pos.first].search(pos.removeFirst());
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
}

@unfreezed
class CodeBlockSet with _$CodeBlockSet, CodeBlockBuild {
  factory CodeBlockSet({
    @Default([]) final List<CodeBlockBuild> codeBlocks,
  }) = _CodeBlockSet;

  CodeBlockSet._();

  @override
  String build() {
    return codeBlocks.map((e) => e.build()).join("\n");
  }

  @override
  List<CodeBlockBuild>? get child => codeBlocks;
}

@unfreezed
class CodeBlock with _$CodeBlock, CodeBlockBuild {
  factory CodeBlock({
    @Default('') String code,
  }) = _CodeBlock;

  CodeBlock._();

  @override
  String build() {
    return "\n$code";
  }

  @override
  List<CodeBlockBuild>? get child => null;
}

class CodeBlockIf with CodeBlockBuild {
  final String code;
  final List<CodeBlockBuild> childTrue = [];
  final List<CodeBlockBuild> childFalse = [];
  CodeBlockIf({
    this.code = '',
    List<CodeBlockBuild>? childT,
    List<CodeBlockBuild>? childF,
  }){
    if(childT != null){
      childTrue.addAll(childT);
    }
    if(childF != null){
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
    if $code {
      $trueCode
    } else {
      $falseCode
    }
    """;
  }

  @override
  void add(CodeBlockBuild codeBlock, {bool option = true}) {
    if(option){
      childTrue.add(codeBlock);
    }else{
      childFalse.add(codeBlock);
    }
    codeBlock.parent = this;
  }

  @override
  CodeBlockBuild? remove(int index) {
    if(index < childTrue.length){
      return childTrue.removeAt(index);
    }
    return childFalse.removeAt(index - childTrue.length);
  }

  @override
  List<CodeBlockBuild>? get child => [...childTrue, ...childFalse];
}

class CodeBlockFor with CodeBlockBuild {
  final String code;
  final String range;
  final List<CodeBlockBuild> childFor = [];
  CodeBlockFor({
    this.code = '',
    this.range = '',
    List<CodeBlockBuild>? child,
  }){
    if(child != null){
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
