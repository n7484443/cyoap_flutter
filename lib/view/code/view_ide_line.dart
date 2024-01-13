import 'package:cyoap_flutter/view/code/view_ide.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../viewModel/vm_editor.dart';
import '../../viewModel/vm_make_platform.dart';

class ViewIdeLine extends ConsumerWidget {
  const ViewIdeLine({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print(1);
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
        body: ViewIde(
          isChoiceNode: false,
          choice: ref.watch(lineEditorTargetProvider),
        ),
      ),
    );
  }
}
