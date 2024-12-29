import 'package:cyoap_flutter/view/code/view_ide.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../viewModel/code/vm_ide.dart';
import '../../viewModel/edit/vm_editor.dart';
import '../../viewModel/edit/vm_make_platform.dart';

class ViewIdeLine extends ConsumerWidget {
  const ViewIdeLine({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget editor;
    if(!kReleaseMode){
      editor = SimpleCodeEditor(
        choiceType: ChoiceType.line,
        choice: ref.watch(lineEditorTargetProvider),
      );
    }else{
      editor = ViewIde(
        choiceType: ChoiceType.line,
        choice: ref.watch(lineEditorTargetProvider),
      );
    }
    return PopScope(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              ref.read(changeTabProvider.notifier).home(context);
            },
          ),
        ),
        body: editor,
      ),
    );
  }
}
