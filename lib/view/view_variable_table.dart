import 'dart:ui';

import 'package:cyoap_flutter/main.dart';
import 'package:cyoap_flutter/view/util/view_switch_label.dart';
import 'package:cyoap_flutter/viewModel/vm_editor.dart';
import 'package:cyoap_flutter/viewModel/vm_variable_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/platform_system.dart';
import '../viewModel/vm_design_setting.dart';
import '../viewModel/vm_make_platform.dart';

class ViewChangeRotation extends ConsumerWidget {
  const ViewChangeRotation({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!ConstList.isRotatable(context)) return const SizedBox.shrink();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
          onPressed: () {
            if (MediaQuery.of(context).orientation == Orientation.portrait) {
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
            if (MediaQuery.of(context).orientation == Orientation.portrait) {
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
      ],
    );
  }
}

class ViewEditDrawer extends ConsumerStatefulWidget {
  const ViewEditDrawer({
    super.key,
  });

  @override
  ConsumerState createState() => _ViewEditDrawerState();
}

class _ViewEditDrawerState extends ConsumerState<ViewEditDrawer> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    _controller.addListener(() {
      ref.read(searchProvider.notifier).state = _controller.text;
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _controller,
            decoration: const InputDecoration(
              hintText: "검색",
            ),
          ),
        ),
        const Flexible(
          child: ViewSearchTable(),
        ),
        Column(
          children: [
            ListTile(
              onTap: () {
                ref
                    .read(changeTabProvider.notifier)
                    .changePageString('viewDesignSetting', context);
              },
              leading: const Icon(Icons.settings),
              title: const Text('디자인 설정'),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('이미지 설정'),
              onTap: () => ref
                  .read(changeTabProvider.notifier)
                  .changePageString("viewSource", context),
            ),
            ListTile(
              onTap: () {
                ref
                    .read(changeTabProvider.notifier)
                    .changePageString('viewProjectSetting', context);
              },
              leading: const Icon(Icons.settings),
              title: const Text('전역 설정'),
            ),
            const ViewChangeRotation(),
          ],
        ),
      ],
    );
  }
}

class ViewPlayDrawer extends ConsumerStatefulWidget {
  const ViewPlayDrawer({
    super.key,
  });

  @override
  ConsumerState createState() => _ViewPlayDrawerState();
}

class _ViewPlayDrawerState extends ConsumerState<ViewPlayDrawer> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    _controller.addListener(() {
      ref.read(searchProvider.notifier).state = _controller.text;
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (ref.watch(isDebugModeProvider))
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: "검색",
              ),
            ),
          ),
        const Flexible(
          child: ViewSearchTable(),
        ),
        Column(
          children: [
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
            const ViewChangeRotation()
          ],
        ),
      ],
    );
  }
}

class ViewSearchTable extends ConsumerWidget {
  const ViewSearchTable({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      children: [
        const VariableTiles(),
        const NodeTiles(),
      ],
    );
  }
}

class VariableTiles extends ConsumerWidget {
  final bool asBottom;

  const VariableTiles({
    this.asBottom = false,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var isVisibleHideVariable = ref.watch(isVisibleHideVariableProvider);
    var search = ref.watch(searchProvider);

    var variableList = List<Widget>.empty(growable: true);
    for (var key in ref.watch(vmVariableTableProvider).keys) {
      var values = ref.watch(vmVariableTableProvider)[key]!;

      if (isEditable) {
        if (isVisibleHideVariable ||
            (!isVisibleHideVariable && values.visible)) {
          if (search.isEmpty || (search.isNotEmpty && key.contains(search))) {
            variableList.add(ListTile(
              title: Text(key),
              subtitle:
                  values.displayName.isEmpty ? null : Text(values.displayName),
              trailing: Text(values.valueType.data.runtimeType.toString()),
              onTap: () {
                if (ref.watch(changeTabProvider) == 2) {
                  var vmCodeEditor = ref.read(editorChangeProvider.notifier);
                  if (vmCodeEditor.lastFocus != null) {
                    vmCodeEditor.insertText(
                        vmCodeEditor.lastFocus!, key.trim());
                  }
                }
              },
            ));
          }
        }
      } else if (ref.watch(isDebugModeProvider) || values.visible) {
        var name = values.displayName.isEmpty ? key : values.displayName;
        if (asBottom) {
          variableList.add(
            Chip(
              label: Text("$name  ${values.valueType.data.toString()}",
                  style: ConstList.getFont(ref.watch(variableFontProvider))),
            ),
          );
        } else if (search.isEmpty ||
            (search.isNotEmpty && key.contains(search))) {
          variableList.add(ListTile(
            title: Text(name),
            subtitle: Text(values.valueType.data.toString()),
          ));
        }
      }
    }
    if (asBottom) {
      return ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
        }),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              spacing: 10,
              children: variableList,
            ),
          ),
        ),
      );
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
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var search = ref.watch(searchProvider);
    var nodeList = ref.watch(checkListNotifierProvider);
    var widgetList = List<Widget>.empty(growable: true);
    var iconCheckBox = const Icon(Icons.check_box);
    var iconCheckBoxBlank = const Icon(Icons.check_box_outline_blank);
    for (var node in nodeList) {
      List<Widget> children = [];

      var nodeChildren = node.children;
      if (nodeChildren != null) {
        if (isEditable) {
          children = nodeChildren
              .where((element) =>
                  search.isEmpty ||
                  (search.isNotEmpty && element.name.contains(search)))
              .map(
                (e) => ListTile(
                  title: Text(e.name),
                  onTap: () {
                    if (tabList[ref.watch(changeTabProvider)] == "viewEditor") {
                      var vmCodeEditor =
                          ref.read(editorChangeProvider.notifier);
                      if (vmCodeEditor.lastFocus != null) {
                        vmCodeEditor.insertText(vmCodeEditor.lastFocus!,
                            e.name.replaceAll(" ", "").trim());
                      }
                    } else if (e.pos.length > 1) {
                      ref.read(nodeEditorTargetPosProvider.notifier).state =
                          e.pos;
                      ref
                          .read(changeTabProvider.notifier)
                          .changePageString("viewEditor", context);
                    }
                  },
                ),
              )
              .toList();
        } else {
          children = nodeChildren
              .where((element) =>
                  search.isEmpty ||
                  (search.isNotEmpty && element.name.contains(search)))
              .map(
                (e) => ListTile(
                  title: Text(e.name),
                  trailing:
                      (e.check ?? false) ? iconCheckBox : iconCheckBoxBlank,
                ),
              )
              .toList();
        }
      }
      if (children.isNotEmpty) {
        widgetList.add(
          ExpansionTile(
            title: Text(node.name),
            children: children,
          ),
        );
      }
    }
    return ExpansionTile(
      title: const Text('노드'),
      children: widgetList,
    );
  }
}
