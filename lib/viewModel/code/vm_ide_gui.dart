import 'package:cyoap_core/choiceNode/pos.dart';
import 'package:cyoap_core/grammar/analyser.dart';
import 'package:cyoap_core/grammar/recursive_parser.dart';
import 'package:cyoap_flutter/viewModel/code/vm_ide.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/code_gui.dart';

final codeBlockProvider =
    ChangeNotifierProvider.autoDispose<CodeBlockChangeNotifier>((ref) {
  return CodeBlockChangeNotifier(ref);
});

class CodeBlockChangeNotifier extends ChangeNotifier {
  CodeBlockSet state;
  Ref ref;

  CodeBlockChangeNotifier(this.ref) : state = CodeBlockSet(codeBlocks: []) {
    var ast = Analyser()
        .toAst(ref.read(controllerIdeProvider).document.toPlainText());
    updateFromAst(ast);
  }

  void updatePos() {
    state.updatePos(const Pos(data: [0]));
    notifyListeners();
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
    if (from.equalExceptLast(to)) {
      var index = from.last;
      var toIndex = to.last;
      if (index < toIndex) {
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

  void updateFromAst(RecursiveUnit? unit) {
    if (unit == null) {
      return;
    }
    state = CodeBlockType.fromAst(unit) as CodeBlockSet;
    notifyListeners();
  }
}

final codeBlockPosProvider = StateProvider<Pos?>((ref) {
  return null;
});
