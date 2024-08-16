import 'package:cyoap_core/grammar/value_type.dart';
import 'package:cyoap_flutter/i18n.dart';
import 'package:cyoap_flutter/main.dart';
import 'package:cyoap_flutter/view/util/controller_adjustable_scroll.dart';
import 'package:cyoap_flutter/view/util/view_switch_label.dart';
import 'package:cyoap_flutter/viewModel/edit/vm_project_setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../viewModel/edit/vm_make_platform.dart';

class ViewProjectSetting extends ConsumerWidget {
  const ViewProjectSetting({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var appbarWidget = AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          ref.read(changeTabProvider.notifier).home(context);
        },
      ),
      actions: [
        if (ConstList.isMobile())
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              ref.read(valueTypeWrapperListProvider.notifier).save();
            },
          )
      ],
    );
    return Scaffold(
      appBar: appbarWidget,
      body: const Padding(
        padding: EdgeInsets.all(8.0),
        child: ViewGlobalVariableEditor(),
      ),
    );
  }
}

class ViewGlobalVariableEditor extends ConsumerStatefulWidget {
  const ViewGlobalVariableEditor({super.key});

  @override
  ConsumerState createState() => _ViewGlobalVariableEditorState();
}

class _ViewGlobalVariableEditorState
    extends ConsumerState<ViewGlobalVariableEditor> {
  AdjustableScrollController controller = AdjustableScrollController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var currentIndex = ref.watch(currentEditGlobalVariableProvider);
    var filterType = ref.watch(globalVariableFilterProvider);
    var filteredList = ref.watch(globalVariableFilteredListProvider);
    var iconList = [
      FittedBox(
        child: IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            ref.read(valueTypeWrapperListProvider.notifier).addInitialValue(
                'point',
                ValueTypeWrapper(valueType: getValueTypeFromDynamicInput(0)));
          },
        ),
      ),
      const Spacer(),
      FittedBox(
        child: IconButton(
          icon: const Icon(Icons.arrow_upward),
          onPressed: () {
            if (currentIndex == null) {
              return;
            }
            var indexFiltered = filteredList.indexOf(currentIndex);
            if (indexFiltered > 0) {
              var newIndex = filteredList[indexFiltered - 1];
              ref
                  .read(valueTypeWrapperListProvider.notifier)
                  .swap(currentIndex, newIndex);
              ref.read(currentEditGlobalVariableProvider.notifier).state =
                  newIndex;
            }
          },
        ),
      ),
      FittedBox(
        child: IconButton(
          icon: const Icon(Icons.arrow_downward),
          onPressed: () {
            if (currentIndex == null) {
              return;
            }
            var indexFiltered = filteredList.indexOf(currentIndex);
            if (indexFiltered < filteredList.length - 1) {
              var newIndex = filteredList[indexFiltered + 1];
              ref
                  .read(valueTypeWrapperListProvider.notifier)
                  .swap(currentIndex, newIndex);
              ref.read(currentEditGlobalVariableProvider.notifier).state =
                  newIndex;
            }
          },
        ),
      ),
      const Spacer(),
      FittedBox(
        child: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            if (currentIndex == null) {
              return;
            }
            ref.read(currentEditGlobalVariableProvider.notifier).state = null;
            ref
                .read(valueTypeWrapperListProvider.notifier)
                .deleteInitialValue(currentIndex);
          },
        ),
      ),
    ];
    var children = [
      Expanded(
        flex: 2,
        child: Scrollbar(
          thumbVisibility: true,
          controller: controller,
          child: CustomScrollView(
            controller: controller,
            slivers: [
              SliverAppBar(
                floating: false,
                pinned: true,
                snap: false,
                title: Text(
                  'project_variable'.i18n,
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                toolbarHeight: 45,
                centerTitle: true,
                leadingWidth: 65,
                leading: MenuBar(
                  children: [
                    SubmenuButton(
                      menuChildren: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text("filter".i18n),
                              const SizedBox(
                                width: 20,
                              ),
                              IconButton(
                                icon: const Icon(Icons.visibility),
                                onPressed: () {
                                  ref
                                      .read(
                                          globalVariableFilterProvider.notifier)
                                      .state = FilterType.showVisible;
                                },
                                isSelected:
                                    filterType == FilterType.showVisible,
                              ),
                              IconButton(
                                icon: const Icon(Icons.visibility_off),
                                onPressed: () {
                                  ref
                                      .read(
                                          globalVariableFilterProvider.notifier)
                                      .state = FilterType.hideVisible;
                                },
                                isSelected:
                                    filterType == FilterType.hideVisible,
                              ),
                              IconButton(
                                icon: const Icon(Icons.filter_list_off),
                                onPressed: () {
                                  ref
                                      .read(
                                          globalVariableFilterProvider.notifier)
                                      .state = FilterType.showAll;
                                },
                                isSelected: filterType == FilterType.showAll,
                              ),
                            ],
                          ),
                        ),
                      ],
                      child: const Icon(Icons.tune),
                    )
                  ],
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    index = filteredList[index];
                    return Card(
                      elevation: 0.0,
                      child: ListTile(
                        title: Text(
                          ref.watch(valueTypeWrapperListProvider)[index].$1,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        subtitle: Text(
                            '${ref.watch(valueTypeWrapperListProvider)[index].$2.valueType}\n${ref.watch(valueTypeWrapperListProvider)[index].$2.displayName}    ${ref.watch(valueTypeWrapperListProvider)[index].$2.valueType.type}'),
                        onTap: () {
                          ref
                              .read(currentEditGlobalVariableProvider.notifier)
                              .state = index;
                        },
                        selected: currentIndex == index,
                        selectedTileColor:
                            Theme.of(context).colorScheme.inversePrimary,
                        dense: true,
                        trailing: ref
                                    .watch(
                                        valueTypeWrapperListProvider.notifier)
                                    .getEditTargetValueTypeWrapper(index)
                                    ?.visible ??
                                false
                            ? const Icon(Icons.visibility)
                            : null,
                      ),
                    );
                  },
                  childCount: filteredList.length,
                ),
              ),
            ],
          ),
        ),
      ),
      ConstList.isSmallDisplay(context)
          ? const Divider()
          : const VerticalDivider(width: 40),
      ConstList.isSmallDisplay(context)
          ? SizedBox(
              height: 44,
              child: Row(
                children: iconList,
              ),
            )
          : SizedBox(
              width: 44,
              child: Column(
                children: iconList,
              ),
            ),
      ConstList.isSmallDisplay(context)
          ? const Divider()
          : const VerticalDivider(width: 40),
      const Expanded(
        flex: 3,
        child: ViewGlobalVariableInnerEditor(),
      )
    ];
    if (ConstList.isSmallDisplay(context)) {
      return Column(
        children: children,
      );
    }
    return Row(
      children: children,
    );
  }
}

class ViewGlobalVariableInnerEditor extends ConsumerStatefulWidget {
  const ViewGlobalVariableInnerEditor({super.key});

  @override
  ConsumerState createState() => _ViewGlobalVariableInnerEditorState();
}

class _ViewGlobalVariableInnerEditorState
    extends ConsumerState<ViewGlobalVariableInnerEditor> {
  AdjustableScrollController controller = AdjustableScrollController();
  int index = 1;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var currentIndex = ref.watch(currentEditGlobalVariableProvider);
    if (currentIndex == null) {
      return const SizedBox();
    }
    var currentEditValueList = ref.watch(valueTypeWrapperListProvider);
    var (_, currentEditValue) =
        currentEditValueList[currentIndex];
    return Scrollbar(
      thumbVisibility: true,
      controller: controller,
      child: ListView(
        controller: controller,
        children: [
          ViewSwitchLabel(
            () {
              ref.read(valueTypeWrapperListProvider.notifier).editInitialValue(
                  currentIndex,
                  value: currentEditValue.copyWith(
                      visible: !currentEditValue.visible));
            },
            currentEditValue.visible,
            label: 'variable_show'.i18n,
          ),
          TextField(
            maxLines: 1,
            maxLength: 50,
            controller: ref.watch(projectSettingNameTextEditingProvider),
            decoration: InputDecoration(
              label: Text('variable'.i18n),
            ),
            textAlign: TextAlign.right,
          ),
          TextField(
            maxLines: 1,
            maxLength: 50,
            controller: ref.watch(projectSettingValueTextEditingProvider),
            decoration: InputDecoration(
              label: Text('variable_init'.i18n),
            ),
            textAlign: TextAlign.right,
          ),
          TextField(
            maxLines: 1,
            maxLength: 50,
            controller: ref.watch(projectSettingDisplayNameTextEditingProvider),
            decoration: InputDecoration(
              label: Text('variable_notation'.i18n),
            ),
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }
}
