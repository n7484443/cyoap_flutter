import 'package:cyoap_core/choiceNode/choice.dart';
import 'package:cyoap_flutter/view/code/view_ide.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../viewModel/code/vm_ide.dart';
import '../../viewModel/edit/vm_editor.dart';

class ViewIdeNode extends ConsumerWidget {
  final Choice choice;

  const ViewIdeNode({super.key, required this.choice});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget editor;
    if (!kReleaseMode) {
      editor = SimpleCodeEditor(
        choiceType: ChoiceType.node,
        choice: ref.watch(nodeEditorTargetProvider),
      );
    } else {
      editor = ViewIde(
        choiceType: ChoiceType.node,
        choice: ref.watch(nodeEditorTargetProvider),
      );
    }
    return editor;
  }
}
