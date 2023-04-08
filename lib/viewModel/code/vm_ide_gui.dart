import 'package:cyoap_core/choiceNode/pos.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/code_gui.dart';

final codeBlockProvider = StateProvider<CodeBlockSet>((ref) {
  return const CodeBlockSet(
    codeBlocks: [
      CodeBlock(code: 'let t = 3'),
      CodeBlockIf(
        code: 'test == 3',
        childTrue: [
          CodeBlock(code: 'let t = 3'),
          CodeBlock(code: 'let a = 3'),
          CodeBlockIf(
            code: 'test == 3',
            childTrue: [
              CodeBlock(code: 'let t = 3'),
              CodeBlockFor(code: 'a', range: '1..3', childFor: [
                CodeBlock(code: 'let a = 3'),
              ]),
            ],
            childFalse: [],
          )
        ],
        childFalse: [],
      ),
      CodeBlock(code: 'let t = 3'),
      CodeBlockFor(code: 'a', range: '1..3', childFor: [
        CodeBlock(code: 'let a = 3'),
      ]),
      CodeBlockFor(code: 'a', range: '1..3', childFor: [
        CodeBlock(code: 'let a = 3'),
      ]),
      CodeBlockFor(code: 'a', range: '2..5', childFor: [
        CodeBlock(code: 'let a = 3'),
      ]),
      CodeBlockFor(code: 'a', range: '1..3', childFor: [
        CodeBlock(code: 'let a = 3'),
      ]),
      CodeBlockFor(code: 'a', range: '1..3', childFor: [
        CodeBlock(code: 'let a = 3'),
      ]),
    ],
  );
});

final codeBlockPosProvider = StateProvider<CodePosSet>((ref) {
  return CodePosSet(pos: const Pos(data: []));
});
