import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/code_gui.dart';

final codeBlockProvider = StateProvider<List<CodeBlock>>((ref) {
  return [
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
            CodeBlockFor(code: 'a', range: '1..3', codeBlock: [
              CodeBlock(code: 'let a = 3'),
            ]),
          ],
          childFalse: [],
        )
      ],
      childFalse: [],
    ),
    CodeBlock(code: 'let t = 3'),
    CodeBlockFor(code: 'a', range: '1..3', codeBlock: [
      CodeBlock(code: 'let a = 3'),
    ]),
    CodeBlockFor(code: 'a', range: '1..3', codeBlock: [
      CodeBlock(code: 'let a = 3'),
    ]),
    CodeBlockFor(code: 'a', range: '1..3', codeBlock: [
      CodeBlock(code: 'let a = 3'),
    ]),
    CodeBlockFor(code: 'a', range: '1..3', codeBlock: [
      CodeBlock(code: 'let a = 3'),
    ]),
    CodeBlockFor(code: 'a', range: '1..3', codeBlock: [
      CodeBlock(code: 'let a = 3'),
    ]),
  ];
});
