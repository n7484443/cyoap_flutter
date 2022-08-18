import 'package:cyoap_flutter/view/util/view_image_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../viewModel/vm_make_platform.dart';
import '../viewModel/vm_source.dart';

class ViewSource extends ConsumerWidget {
  const ViewSource({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var controller = ref.watch(vmSourceProvider);
    var deleteList = ref.watch(deleteImageListProvider);
    var widget = ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        var name = controller[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: Theme.of(context).colorScheme.outline,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(12)),
            ),
            color: deleteList.contains(name) ? Theme.of(context).colorScheme.secondaryContainer : null,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: ViewImageLoading(name),
                ),
                Flexible(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(name),
                        TextField(
                          textAlign: TextAlign.start,
                          decoration: const InputDecoration(
                            hintText: '출처를 여기에 적어주세요!',
                            alignLabelWithHint: true,
                          ),
                          controller:
                              ref.watch(textEditingControllerProvider(name)),
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: ref.watch(deleteModeProvider),
                  child: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      ref.read(vmSourceProvider.notifier).checkRemove(name);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
      itemCount: controller.length,
    );

    Widget icon;
    if (!ref.watch(deleteModeProvider)) {
      icon = Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: '프로젝트에서 이미지 삭제',
            onPressed: () {
              ref.read(deleteModeProvider.notifier).update((state) => true);
            },
          ),
        ],
      );
    } else {
      icon = Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(Icons.close),
            tooltip: '이미지 삭제 취소',
            onPressed: () {
              ref.read(deleteImageListProvider.notifier).update((state) => []);
              ref.read(deleteModeProvider.notifier).update((state) => false);
            },
          ),
          IconButton(
            icon: const Icon(Icons.check),
            tooltip: '프로젝트에서 이미지 삭제',
            onPressed: () {
              ref.read(vmSourceProvider.notifier).remove();
              ref.read(deleteModeProvider.notifier).update((state) => false);
            },
          ),
        ],
      );
    }

    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              ref.read(changeTabProvider.notifier).back(context);
            },
          ),
          title: icon,
        ),
        body: widget,
      ),
      onWillPop: () async {
        return false;
      },
    );
  }
}
