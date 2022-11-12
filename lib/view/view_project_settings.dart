import 'package:cyoap_core/grammar/value_type.dart';
import 'package:cyoap_flutter/main.dart';
import 'package:cyoap_flutter/view/util/view_switch_label.dart';
import 'package:cyoap_flutter/viewModel/vm_project_setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      title: const Text("데이터 변경"),
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Flexible(
              flex: 4,
              child: TextField(
                maxLines: 1,
                maxLength: 50,
                controller: ref.watch(projectSettingNameTextEditingProvider(index)),
                decoration: const InputDecoration(
                  label: Text('변수명'),
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
                controller: ref.watch(projectSettingValueTextEditingProvider(index)),
                decoration: const InputDecoration(
                  label: Text('변수 초기값'),
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
                    ref.watch(projectSettingDisplayNameTextEditingProvider(index)),
                decoration: const InputDecoration(
                  label: Text('변수 표기명'),
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
                        .read(projectSettingVisibleSwitchProvider(index).notifier)
                        .update((state) => !state),
                    ref.watch(projectSettingVisibleSwitchProvider(index)),
                    label: '플레이시 표시',
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      actions: [
        TextButton(
          child: const Text('취소'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: const Text('저장'),
          onPressed: () {
            var after = ValueTypeWrapper(
                getValueTypeFromStringInput(
                    ref.read(projectSettingValueTextEditingProvider(index)).text),
                visible: ref.read(projectSettingVisibleSwitchProvider(index)),
                displayName:
                ref.read(projectSettingDisplayNameTextEditingProvider(index)).text);
            var name = ref.read(projectSettingNameTextEditingProvider(index)).text;
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
          ref.read(changeTabProvider.notifier).back(context);
        },
      ),
      actions: [
        if(ConstList.isMobile())
        IconButton(
          icon: const Icon(Icons.save),
          onPressed: () {
            ref.read(valueTypeWrapperListProvider.notifier).save();
          },
        )
      ],
    );

    var initialValueList = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(
            flex: 18,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(width: 2),
              ),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: ConstList.isSmallDisplay(context) ? 2 : 4,
                  crossAxisSpacing: 2,
                  mainAxisExtent: 60,
                  mainAxisSpacing: 2,
                ),
                itemBuilder: (BuildContext context, int index) {
                  var key = ref
                      .watch(valueTypeWrapperListProvider.notifier)
                      .getKey(index);
                  var data = ref.watch(valueTypeWrapperListProvider)[key]!;
                  var visible = data.visible;
                  return ListTile(
                    //보이지 않을 경우 푸른색으로
                    tileColor:
                    visible
                            ? Colors.blue
                            : null,
                    onTap: () {
                      showDialog(
                          builder: (BuildContext context) =>
                              ViewInitialValueEditDialog(index),
                          context: context);
                    },
                    title: Text(key, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: visible ? Colors.white : null)),
                    subtitle: Text(data.valueType
                        .data
                        .toString(), style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: visible ? Colors.white : null)),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: visible ? Colors.white : null),
                      onPressed: () {
                        ref
                            .read(valueTypeWrapperListProvider.notifier)
                            .deleteInitialValue(index);
                      },
                    ),
                  );
                },
                itemCount: ref.watch(valueTypeWrapperListProvider).length,
              ),
            ),
          ),
          TextButton(
            child: const Text('초기값 추가'),
            onPressed: () {
              ref.read(valueTypeWrapperListProvider.notifier).addInitialValue(
                  'point', ValueTypeWrapper(ValueType.int(0), visible: true));
            },
          )
        ],
      ),
    );

    return Scaffold(
      appBar: appbarWidget,
      body: initialValueList,
    );
  }
}
