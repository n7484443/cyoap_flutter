import 'package:cyoap_flutter/main.dart';
import 'package:cyoap_flutter/model/grammar/value_type.dart';
import 'package:cyoap_flutter/view/util/view_switch_label.dart';
import 'package:cyoap_flutter/viewModel/vm_global_setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../viewModel/vm_make_platform.dart';

class ViewInitialValueEditDialog extends ConsumerWidget {
  final int index;

  const ViewInitialValueEditDialog(
    this.index, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(editIndex.notifier).state = index;
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
                controller: ref.watch(globalSettingNameTextEditingProvider),
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
                controller: ref.watch(globalSettingValueTextEditingProvider),
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
                    ref.watch(globalSettingDisplayNameTextEditingProvider),
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
                        .read(globalSettingVisibleSwitchProvider.notifier)
                        .update((state) => !state),
                    ref.watch(globalSettingVisibleSwitchProvider),
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
            ref.read(vmGlobalSettingProvider.notifier).editInitialValue(index);
            Navigator.pop(context);
          },
        )
      ],
      scrollable: true,
    );
  }
}

class ViewGlobalSetting extends ConsumerWidget {
  const ViewGlobalSetting({Key? key}) : super(key: key);

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
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            ref
                .read(changeTabProvider.notifier)
                .changePageString('viewFontSource', context);
          },
        ),
        IconButton(
          icon: const Icon(Icons.save),
          onPressed: () {
            ref.read(vmGlobalSettingProvider.notifier).save();
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
                border: Border.all(width: 2, color: Colors.lightBlueAccent),
              ),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: ConstList.isSmallDisplay(context) ? 2 : 4,
                  crossAxisSpacing: 2,
                  mainAxisExtent: 60,
                  mainAxisSpacing: 2,
                ),
                itemBuilder: (BuildContext context, int index) {
                  var key =
                      ref.watch(vmGlobalSettingProvider.notifier).getKey(index);
                  return ListTile(
                    onTap: () {
                      showDialog(
                          builder: (BuildContext context) =>
                              ViewInitialValueEditDialog(index),
                          context: context);
                    },
                    title: Text(key),
                    subtitle: Text(ref
                        .watch(vmGlobalSettingProvider)[key]!
                        .valueType
                        .data
                        .toString()),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        ref
                            .read(vmGlobalSettingProvider.notifier)
                            .deleteInitialValue(index);
                      },
                    ),
                  );
                },
                itemCount: ref.watch(vmGlobalSettingProvider).length,
              ),
            ),
          ),
          TextButton(
            child: const Text('초기값 추가'),
            onPressed: () {
              ref.read(vmGlobalSettingProvider.notifier).addInitialValue(
                  'point', ValueTypeWrapper(ValueType(0), visible: true));
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
