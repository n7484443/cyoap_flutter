import 'package:cyoap_core/choiceNode/pos.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'code_gui.freezed.dart';

class CodePosSet{
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

  Type toCodeBlock() {
    switch (this) {
      case CodeBlockType.ifBlock:
        return CodeBlockIf;
      case CodeBlockType.forBlock:
        return CodeBlockFor;
      case CodeBlockType.conditionBlock:
        return CodeBlock;
      case CodeBlockType.codeBlock:
        return CodeBlock;
    }
  }
}

mixin CodeBlockBuild {
  String build();

  List<CodeBlockBuild>? get child;
}

@freezed
class CodeBlockSet with _$CodeBlockSet, CodeBlockBuild {
  const factory CodeBlockSet({
    @Default([]) List<CodeBlockBuild> codeBlocks,
    @Default(null) CodeBlockBuild? parentCodeBlock,
  }) = _CodeBlockSet;

  const CodeBlockSet._();

  @override
  String build() {
    return codeBlocks.map((e) => e.build()).join("\n");
  }

  @override
  List<CodeBlockBuild>? get child => codeBlocks;
}

@freezed
class CodeBlock with _$CodeBlock, CodeBlockBuild {
  const factory CodeBlock({
    @Default('') String code,
    @Default(null) CodeBlockBuild? parentCodeBlock,
  }) = _CodeBlock;

  const CodeBlock._();

  @override
  String build() {
    return "\n$code";
  }

  @override
  List<CodeBlockBuild>? get child => null;
}

@freezed
class CodeBlockIf with _$CodeBlockIf, CodeBlockBuild {
  const factory CodeBlockIf({
    @Default('') String code,
    @Default(null) CodeBlockBuild? parentCodeBlock,
    @Default([]) List<CodeBlockBuild> childTrue,
    @Default([]) List<CodeBlockBuild> childFalse,
  }) = _CodeBlockIf;

  const CodeBlockIf._();

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
  List<CodeBlockBuild>? get child => [...childTrue, ...childFalse];
}

@freezed
class CodeBlockFor with _$CodeBlockFor, CodeBlockBuild {
  const factory CodeBlockFor({
    @Default('') String code,
    @Default('') String range,
    @Default(null) CodeBlockBuild? parentCodeBlock,
    @Default([]) List<CodeBlockBuild> childFor,
  }) = _CodeBlockFor;

  const CodeBlockFor._();

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
