import 'package:cyoap_core/grammar/value_type.dart';
import 'package:cyoap_flutter/i18n.dart';
import 'package:cyoap_flutter/main.dart';
import 'package:cyoap_flutter/view/util/view_switch_label.dart';
import 'package:cyoap_flutter/viewModel/vm_project_setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';

import '../viewModel/vm_make_platform.dart';

class ViewInitialValueEditDialog extends ConsumerWidget {
  final int index;

  const ViewInitialValueEditDialog(
    this.index, {
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: Text("change_data".i18n),
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Flexible(
              flex: 4,
              child: TextField(
                maxLines: 1,
                maxLength: 50,
                controller:
                    ref.watch(projectSettingNameTextEditingProvider(index)),
                decoration: InputDecoration(
                  label: Text('variable'.i18n),
                ),
                textAlign: TextAlign.right,
              ),
            ),
            const Spacer(),
            Flexible(
              flex: 4,
              child: TextField(
                maxLines: 1,
                maxLength: 50,
                controller:
                    ref.watch(projectSettingValueTextEditingProvider(index)),
                decoration: InputDecoration(
                  label: Text('variable_init'.i18n),
                ),
                textAlign: TextAlign.right,
              ),
            ),
            const Spacer(),
            Flexible(
              flex: 4,
              child: TextField(
                maxLines: 1,
                maxLength: 50,
                controller: ref
                    .watch(projectSettingDisplayNameTextEditingProvider(index)),
                decoration: InputDecoration(
                  label: Text('variable_notation'.i18n),
                ),
                textAlign: TextAlign.right,
              ),
            ),
            const Spacer(),
            Flexible(
              flex: 4,
              child: Column(
                children: [
                  ViewSwitchLabel(
                    () => ref
                        .read(
                            projectSettingVisibleSwitchProvider(index).notifier)
                        .update((state) => !state),
                    ref.watch(projectSettingVisibleSwitchProvider(index)),
                    label: 'variable_show'.i18n,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      actions: [
        TextButton(
          child: Text('cancel'.i18n),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: Text('save'.i18n),
          onPressed: () {
            var after = ValueTypeWrapper(
                getValueTypeFromStringInput(ref
                    .read(projectSettingValueTextEditingProvider(index))
                    .text),
                visible: ref.read(projectSettingVisibleSwitchProvider(index)),
                displayName: ref
                    .read(projectSettingDisplayNameTextEditingProvider(index))
                    .text);
            var name =
                ref.read(projectSettingNameTextEditingProvider(index)).text;
            ref
                .read(valueTypeWrapperListProvider.notifier)
                .editInitialValue(index, name, after);
            Navigator.pop(context);
          },
        )
      ],
      scrollable: true,
    );
  }
}

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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              flex: 18,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 2),
                ),
                child: ReorderableGridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: ConstList.isSmallDisplay(context) ? 2 : 4,
                    crossAxisSpacing: 2,
                    mainAxisExtent: 60,
                    mainAxisSpacing: 2,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    var target = ref
                        .watch(valueTypeWrapperListProvider.notifier)
                        .getEditTarget(index)!;
                    var visible = target.$2.visible;
                    return ListTile(
                      key: Key(target.$1),
                      //If not visible, it will be colored blue
                      tileColor: visible ? Colors.lightBlue : null,
                      onTap: () {
                        showDialog(
                            builder: (BuildContext context) =>
                                ViewInitialValueEditDialog(index),
                            context: context);
                      },
                      title: Text(target.$1,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(color: visible ? Colors.white : null),
                          overflow: TextOverflow.ellipsis,
                          softWrap: false),
                      subtitle: Text(target.$2.valueType.data.toString(),
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: visible ? Colors.white : null),
                          overflow: TextOverflow.ellipsis,
                          softWrap: false),
                      trailing: IconButton(
                        icon: Icon(Icons.delete,
                            color: visible ? Colors.white : null),
                        onPressed: () {
                          ref
                              .read(valueTypeWrapperListProvider.notifier)
                              .deleteInitialValue(index);
                        },
                      ),
                    );
                  },
                  itemCount: ref.watch(valueTypeWrapperListProvider).length,
                  onReorder: (int oldIndex, int newIndex) {
                    ref
                        .read(valueTypeWrapperListProvider.notifier)
                        .reorder(oldIndex, newIndex);
                  },
                ),
              ),
            ),
            TextButton(
              child: Text('variable_add'.i18n),
              onPressed: () {
                ref.read(valueTypeWrapperListProvider.notifier).addInitialValue(
                    'point', ValueTypeWrapper(ValueType.int(0)));
              },
            )
          ],
        ),
      ),
    );
  }
}
