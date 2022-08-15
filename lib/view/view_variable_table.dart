import 'package:cyoap_flutter/main.dart';
import 'package:cyoap_flutter/view/util/view_switch_label.dart';
import 'package:cyoap_flutter/viewModel/vm_variable_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/platform_system.dart';
import '../viewModel/vm_code_editor.dart';
import '../viewModel/vm_make_platform.dart';

class ViewVariable extends ConsumerWidget {
  const ViewVariable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Widget> widgetList;
    if (isEditable) {
      widgetList = [
        ListTile(
          onTap: () {
            ref
                .read(vmMakePlatformProvider.notifier)
                .changePageString('viewDesignSetting', context);
          },
          leading: const Icon(Icons.settings),
          title: const Text('디자인 설정'),
        ),
        ListTile(
          leading: const Icon(Icons.settings),
          title: const Text('이미지 설정'),
          onTap: () => ref
              .read(vmMakePlatformProvider.notifier)
              .changePageString("viewSource", context),
        ),
        ListTile(
          onTap: () {
            ref
                .read(vmMakePlatformProvider.notifier)
                .changePageString('viewGlobalSetting', context);
          },
          leading: const Icon(Icons.settings),
          title: const Text('전역 설정'),
        ),
      ];
    } else {
      widgetList = [
        ListTile(
          leading: const Text('버전'),
          title: Text(ConstList.version),
        ),
        ListTile(
          title: ViewSwitchLabel(
            () => ref
                .read(isVisibleSourceProvider.notifier)
                .update((state) => !state),
            ref.watch(isVisibleSourceProvider),
            label: '출처 보기',
          ),
        ),
        ListTile(
          title: ViewSwitchLabel(
            () => ref
                .read(isDebugModeProvider.notifier)
                .update((state) => !state),
            ref.watch(isDebugModeProvider),
            label: '디버그 모드 활성화',
          ),
        ),
        if (ConstList.isSmallDisplay(context))
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            IconButton(
              onPressed: () {
                if (MediaQuery.of(context).orientation ==
                    Orientation.portrait) {
                  SystemChrome.setPreferredOrientations(
                      [DeviceOrientation.landscapeLeft]);
                } else {
                  SystemChrome.setPreferredOrientations([
                    DeviceOrientation.portraitUp,
                    DeviceOrientation.landscapeRight,
                    DeviceOrientation.landscapeLeft
                  ]);
                }
              },
              icon: const Icon(Icons.rotate_right),
            ),
            IconButton(
              onPressed: () {
                if (MediaQuery.of(context).orientation ==
                    Orientation.portrait) {
                  SystemChrome.setPreferredOrientations(
                      [DeviceOrientation.landscapeRight]);
                } else {
                  SystemChrome.setPreferredOrientations([
                    DeviceOrientation.portraitUp,
                    DeviceOrientation.landscapeRight,
                    DeviceOrientation.landscapeLeft
                  ]);
                }
              },
              icon: const Icon(Icons.rotate_left),
            ),
          ]),
      ];
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: ListView(
            controller: ScrollController(),
            children: [
              const VariableTiles(),
              const NodeTiles(),
            ],
          ),
        ),
        Column(
          children: widgetList,
        ),
      ],
    );
  }
}

class VariableTiles extends ConsumerWidget {
  const VariableTiles({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var isVisibleHideVariable = ref.watch(isVisibleHideVariableProvider);

    var variableList = List<Widget>.empty(growable: true);
    for (var key in ref.watch(vmVariableTableProvider).keys) {
      var values = ref.watch(vmVariableTableProvider)[key]!;

      if (isEditable) {
        if (isVisibleHideVariable ||
            (!isVisibleHideVariable && values.visible)) {
          variableList.add(ListTile(
            title: Text(key),
            subtitle:
                values.displayName.isEmpty ? null : Text(values.displayName),
            trailing: Text(values.valueType.data.runtimeType.toString()),
            onTap: () {
              if (ref.watch(vmMakePlatformProvider) == 2) {
                var vmCodeEditor = ref.read(vmCodeEditorProvider);
                if (vmCodeEditor.lastFocus != null) {
                  vmCodeEditor.insertText(vmCodeEditor.lastFocus!, key.trim());
                }
              }
            },
          ));
        }
      } else if (ref.watch(isDebugModeProvider) || values.visible) {
        var name = values.displayName.isEmpty ? key : values.displayName;
        variableList.add(ListTile(
          title: Text(name),
          trailing: Text(values.valueType.data.toString()),
        ));
      }
    }
    return ExpansionTile(
      title: const Text('변수'),
      subtitle: isEditable
          ? ViewSwitchLabel(
              () {
                ref
                    .read(isVisibleHideVariableProvider.notifier)
                    .update((state) => !state);
              },
              isVisibleHideVariable,
              label: '숨겨진 변수 보기',
            )
          : null,
      initiallyExpanded: true,
      children: variableList,
    );
  }
}

class NodeTiles extends ConsumerWidget {
  const NodeTiles({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var nodeList = ref.watch(checkListNotifierProvider);
    var widgetList = List<Widget>.empty(growable: true);
    var iconCheckBox = const Icon(Icons.check_box);
    var iconCheckBoxBlank = const Icon(Icons.check_box_outline_blank);
    for (var node in nodeList) {
      if (isEditable) {
        widgetList.add(ExpansionTile(
          title: Text(node.name),
          children: node.children == null
              ? []
              : node.children!
                  .map((e) => ListTile(
                        title: Text(e.name),
                        onTap: () {
                          if (ref.watch(vmMakePlatformProvider) == 2) {
                            var vmCodeEditor = ref.read(vmCodeEditorProvider);
                            if (vmCodeEditor.lastFocus != null) {
                              vmCodeEditor.insertText(vmCodeEditor.lastFocus!,
                                  e.name.replaceAll(" ", "").trim());
                            }
                          }
                        },
                      ))
                  .toList(),
        ));
      } else {
        widgetList.add(ExpansionTile(
          title: Text(node.name),
          children: node.children == null
              ? []
              : node.children!
                  .map((e) => ListTile(
                        title: Text(e.name),
                        trailing: (e.check ?? false)
                            ? iconCheckBox
                            : iconCheckBoxBlank,
                      ))
                  .toList(),
        ));
      }
    }
    return ExpansionTile(
      title: const Text('노드'),
      children: widgetList,
    );
  }
}
