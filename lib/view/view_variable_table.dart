import 'package:cyoap_flutter/i18n.dart';
import 'package:cyoap_flutter/main.dart';
import 'package:cyoap_flutter/view/util/controller_adjustable_scroll.dart';
import 'package:cyoap_flutter/view/util/view_switch_label.dart';
import 'package:cyoap_flutter/view/view_make.dart';
import 'package:cyoap_flutter/viewModel/vm_editor.dart';
import 'package:cyoap_flutter/viewModel/vm_variable_table.dart';
import 'package:easy_debounce/easy_debounce.dart';
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
  final ScrollController _scrollController = AdjustableScrollController();

  @override
  void initState() {
    _controller.addListener(() {
      EasyDebounce.debounce('search', const Duration(milliseconds: 500), () {
        ref.read(searchProvider.notifier).state = _controller.text;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    EasyDebounce.cancel('search');
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (!ConstList.isMobile())
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const ViewSaveIcons(),
              const ViewRefreshIcons(),
            ],
          ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: "search".i18n,
            ),
          ),
        ),
        Flexible(
          child: ListView(
            controller: _scrollController,
            children: [
              const VariableTiles(),
              const NodeTiles(),
            ],
          ),
        ),
        Column(
          children: [
            ListTile(
              onTap: () {
                ref
                    .read(changeTabProvider.notifier)
                    .changePageString('viewDesignSetting', context);
              },
              leading: const Icon(Icons.layers),
              title: Text('design_settings'.i18n),
            ),
            ListTile(
              leading: const Icon(Icons.image),
              title: Text('image_settings'.i18n),
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
              title: Text('project_settings'.i18n),
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
  final ScrollController _scrollController = AdjustableScrollController();

  @override
  void initState() {
    _controller.addListener(() {
      EasyDebounce.debounce('search', const Duration(milliseconds: 500), () {
        ref.read(searchProvider.notifier).state = _controller.text;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    EasyDebounce.cancel('search');
    _controller.dispose();
    _scrollController.dispose();
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
              decoration: InputDecoration(
                hintText: "search".i18n,
              ),
            ),
          ),
        Flexible(
          child: ListView(
            controller: _scrollController,
            children: [
              const VariableTiles(),
            ],
          ),
        ),
        Column(
          children: [
            ListTile(
              leading: Text('version'.i18n),
              title: Text(ConstList.version),
            ),
            ListTile(
              title: ViewSwitchLabel(
                () => ref
                    .read(isVisibleSourceProvider.notifier)
                    .update((state) => !state),
                ref.watch(isVisibleSourceProvider),
                label: 'show_image_source'.i18n,
              ),
            ),
            ListTile(
              title: ViewSwitchLabel(
                () => ref
                    .read(isDebugModeProvider.notifier)
                    .update((state) => !state),
                ref.watch(isDebugModeProvider),
                label: 'debug_mode'.i18n,
              ),
            ),
            const ViewChangeRotation()
          ],
        ),
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
              dense: true,
              title: Text(key),
              subtitle:
                  values.displayName.isEmpty ? null : Text(values.displayName),
              trailing: Text(values.valueType.type.name),
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
              label: Text("$name   ${values.valueType.data.toString()}",
                  style: ConstList.getFont(ref.watch(variableFontProvider))),
            ),
          );
        } else if (search.isEmpty ||
            (search.isNotEmpty && key.contains(search))) {
          variableList.add(ListTile(
            dense: true,
            title: Text(name),
            subtitle: Text(values.valueType.data.toString()),
          ));
        }
      }
    }
    if (asBottom) {
      return SizedBox(
        height: 48,
        child: HorizontalScroll(
          itemBuilder: (BuildContext context, int index) {
            return variableList[index];
          },
          itemCount: variableList.length,
        ),
      );
    }
    return ExpansionTile(
      title: Text('variable'.i18n),
      initiallyExpanded: true,
      children: [
        if (isEditable)
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 200, maxHeight: 25),
            child: ViewSwitchLabel(
              () {
                ref
                    .read(isVisibleHideVariableProvider.notifier)
                    .update((state) => !state);
              },
              isVisibleHideVariable,
              label: 'variable_show_hidden'.i18n,
            ),
          ),
        ...variableList
      ],
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
    for (var node in nodeList) {
      List<Widget> children = [];

      var nodeChildren = node.children;
      if (nodeChildren != null) {
        children = nodeChildren
            .where((element) =>
                search.isEmpty ||
                (search.isNotEmpty && element.name.contains(search)))
            .map(
              (e) => ListTile(
                dense: true,
                title: Text(e.name),
                onTap: () {
                  if (tabList[ref.watch(changeTabProvider)] == "viewEditor") {
                    var vmCodeEditor = ref.read(editorChangeProvider.notifier);
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
      title: Text('node'.i18n),
      children: widgetList,
    );
  }
}