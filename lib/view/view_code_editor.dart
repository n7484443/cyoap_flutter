import 'package:cyoap_flutter/model/choiceNode/choice_node.dart';
import 'package:cyoap_flutter/view/util/view_switch_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../viewModel/vm_code_editor.dart';
import '../viewModel/vm_editor.dart';
import '../viewModel/vm_make_platform.dart';

class ViewCodeEditor extends ConsumerWidget {
  const ViewCodeEditor({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vmCodeEditor = ref.watch(vmCodeEditorProvider);
    final isOccupySpaceButton = ref.watch(isOccupySpaceButtonProvider);

    return WillPopScope(
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Visibility(
                  visible: ref.watch(nodeEditorTargetProvider).isSelectableMode,
                  child: Focus(
                    onFocusChange: (bool hasFocus) => vmCodeEditor.lastFocus =
                        ref.watch(controllerClickableProvider),
                    child: TextField(
                      controller: ref.watch(controllerClickableProvider),
                      textAlign: TextAlign.left,
                      decoration: const InputDecoration(hintText: '실행 조건'),
                    ),
                  ),
                ),
                Visibility(
                  visible: ref.watch(nodeModeProvider) != ChoiceNodeMode.onlyCode,
                  child: Focus(
                    onFocusChange: (bool hasFocus) => vmCodeEditor.lastFocus =
                        ref.watch(controllerVisibleProvider),
                    child: TextField(
                      controller: ref.watch(controllerVisibleProvider),
                      textAlign: TextAlign.left,
                      decoration: const InputDecoration(
                          hintText: '보이는 조건(true일 때 보임, 비어있을 시 true)'),
                    ),
                  ),
                ),
                Expanded(
                  child: Focus(
                    onFocusChange: (bool hasFocus) => vmCodeEditor.lastFocus =
                        ref.watch(controllerExecuteProvider),
                    child: TextField(
                      controller: ref.watch(controllerExecuteProvider),
                      textAlign: TextAlign.left,
                      scrollController: ScrollController(),
                      maxLines: null,
                      expands: true,
                      decoration: const InputDecoration(
                        hintText: '선택 시 시행 코드',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Column(
              children: [
                ViewSwitchLabel(
                      () {
                    ref.watch(nodeEditorTargetProvider).isOccupySpace = !isOccupySpaceButton;
                    ref
                        .read(isOccupySpaceButtonProvider.notifier)
                        .update((value) => value = !value);
                  },
                  isOccupySpaceButton,
                  label: '숨김 시 공간 차지',
                ),
              ],
            ),
          ),
        ],
      ),
      onWillPop: () async {
        ref.read(changeTabProvider.notifier).back(context);
        return false;
      },
    );
  }
}
