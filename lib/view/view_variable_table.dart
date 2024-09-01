import 'package:cyoap_flutter/i18n.dart';
import 'package:cyoap_flutter/main.dart';
import 'package:cyoap_flutter/view/util/controller_adjustable_scroll.dart';
import 'package:cyoap_flutter/view/util/view_switch_label.dart';
import 'package:cyoap_flutter/viewModel/vm_variable_table.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/platform_system.dart';
import '../viewModel/edit/vm_design_setting.dart';
import '../viewModel/edit/vm_make_platform.dart';

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

class ViewPlayDrawer extends ConsumerStatefulWidget {
  const ViewPlayDrawer({
    super.key,
  });

  @override
  ConsumerState createState() => _ViewPlayDrawerState();
}

class _ViewPlayDrawerState extends ConsumerState<ViewPlayDrawer> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _controller.addListener(() {
      EasyDebounce.debounce('search', ConstList.debounceDuration, () {
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

class BottomDisplayedVariableWidget extends ConsumerWidget {
  const BottomDisplayedVariableWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var variableList = List<Widget>.empty(growable: true);
    for (var (name, valueTypeWrapper)
        in ref.watch(displayedVariablesProvider)) {
      if (valueTypeWrapper.visible) {
        name = valueTypeWrapper.displayName.isEmpty
            ? name
            : valueTypeWrapper.displayName;
        variableList.add(
          Chip(
            label: Text("$name   ${valueTypeWrapper.valueType.data.toString()}",
                style: ConstList.getFont(
                    ref.watch(platformDesignSettingProvider).variableFont)),
            padding: const EdgeInsets.all(0),
          ),
        );
      }
    }
    return SizedBox(
      height: 46,
      child: HorizontalScroll(
        itemBuilder: (BuildContext context, int index) {
          return variableList[index];
        },
        itemCount: variableList.length,
      ),
    );
  }
}

class VariableTiles extends ConsumerWidget {
  const VariableTiles({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var isVisibleHideVariable = ref.watch(isVisibleHideVariableProvider);
    var search = ref.watch(searchProvider);

    var variableList = List<Widget>.empty(growable: true);
    for (var key in ref.watch(vmVariableTableProvider).keys) {
      var values = ref.watch(vmVariableTableProvider)[key]!;
      if (isPlatformEditable) {
        if (isVisibleHideVariable ||
            (!isVisibleHideVariable && values.visible)) {
          if (search.isEmpty || (search.isNotEmpty && key.contains(search))) {
            variableList.add(ListTile(
              dense: true,
              title: Text(key),
              subtitle:
                  values.displayName.isEmpty ? null : Text(values.displayName),
              trailing: Text(values.valueType.type.name),
            ));
          }
        }
      } else if (ref.watch(isDebugModeProvider) || values.visible) {
        var name = values.displayName.isEmpty ? key : values.displayName;
        if (search.isEmpty || (search.isNotEmpty && key.contains(search))) {
          variableList.add(ListTile(
            dense: true,
            title: Text(name),
            subtitle: Text(values.valueType.data.toString()),
          ));
        }
      }
    }
    return ExpansionTile(
      title: Text('variable'.i18n),
      initiallyExpanded: true,
      children: [
        if (isPlatformEditable)
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
                onTap: () async {
                  if (e.pos.length > 1) {
                    if (ref.read(changeTabProvider) ==
                        tabList.indexOf("viewEditor")) {
                      await ref.read(changeTabProvider.notifier).home(context);
                      await Future.delayed(const Duration(milliseconds: 200));
                    }
                    // ref
                    //     .read(currentListviewTargetPosProvider.notifier)
                    //     .set(e.pos);
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
      initiallyExpanded: true,
      children: widgetList,
    );
  }
}
