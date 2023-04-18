import 'package:cyoap_core/choiceNode/pos.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/code_gui.dart';

final codeBlockProvider = ChangeNotifierProvider<CodeBlockChangeNotifier>((ref) {
  return CodeBlockChangeNotifier(ref);
});

class CodeBlockChangeNotifier extends ChangeNotifier {
  CodeBlockSet state;
  Ref ref;

  CodeBlockChangeNotifier(this.ref)
      : state = CodeBlockSet(
          codeBlocks: [
            CodeBlock(code: 'let t = 3'),
            CodeBlockIf(
              code: 'test == 3',
              childT: [
                CodeBlock(code: 'let t = 3'),
                CodeBlock(code: 'let a = 3'),
                CodeBlockIf(
                  code: 'test == 3',
                  childT: [
                    CodeBlock(code: 'let t = 3'),
                    CodeBlockFor(code: 'a', range: '1..3', child: [
                      CodeBlock(code: 'let a = 3'),
                    ]),
                  ],
                  childF: [],
                )
              ],
              childF: [],
            ),
            CodeBlock(code: 'let t = 3'),
            CodeBlockFor(code: 'a', range: '1..3', child: [
              CodeBlock(code: 'let a = 3'),
            ]),
            CodeBlockFor(code: 'a', range: '1..3', child: [
              CodeBlock(code: 'let a = 3'),
            ]),
            CodeBlockFor(code: 'a', range: '2..5', child: [
              CodeBlock(code: 'let a = 3'),
            ]),
            CodeBlockFor(code: 'a', range: '1..3', child: [
              CodeBlock(code: 'let a = 3'),
            ]),
            CodeBlockFor(code: 'a', range: '1..3', child: [
              CodeBlock(code: 'let a = 3'),
            ]),
          ],
        );
  void updatePos(){
    state.updatePos(const Pos(data: [0]));
  }
  void addBlock(Pos pos, CodeBlockBuild codeBlock, {bool option = true}) {
    searchBlock(pos).add(codeBlock, option: option);
    updatePos();
    notifyListeners();
  }

  CodeBlockBuild? removeBlock(Pos pos) {
    var removed = searchBlock(pos.removeLast()).remove(pos.last);
    updatePos();
    notifyListeners();
    return removed;
  }

  void moveBlock(Pos from, Pos to) {
    if(from.equalExceptLast(to)){
      var index = from.last;
      var toIndex = to.last;
      if(index < toIndex){
        toIndex--;
      }
      to = to.removeLast().addLast(toIndex);
    }
    var removed = removeBlock(from);
    if (removed != null) {
      addBlock(to, removed);
    }
  }

  CodeBlockBuild searchBlock(Pos pos) {
    return state.search(pos);
  }
}

final codeBlockPosProvider = StateProvider<Pos?>((ref) {
  return null;
});
