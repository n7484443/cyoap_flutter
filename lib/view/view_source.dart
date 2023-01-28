import 'package:cyoap_flutter/main.dart';
import 'package:cyoap_flutter/view/util/controller_adjustable_scroll.dart';
import 'package:cyoap_flutter/view/util/view_image_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../viewModel/vm_make_platform.dart';
import '../viewModel/vm_source.dart';

class ViewSource extends ConsumerStatefulWidget {
  const ViewSource({
    super.key,
  });

  @override
  ConsumerState createState() => _ViewSourceState();
}

class _ViewSourceState extends ConsumerState<ViewSource> {
  ScrollController? _controller;

  @override
  void initState() {
    _controller = AdjustableScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var data = ref.watch(vmSourceProvider);
    var deleteList = ref.watch(deleteImageListProvider);

    Widget icon;
    if (!ref.watch(deleteModeProvider)) {
      icon = Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Delete images from a project',
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
            tooltip: 'Undelete an image',
            onPressed: () {
              ref.read(deleteImageListProvider.notifier).update((state) => []);
              ref.read(deleteModeProvider.notifier).update((state) => false);
            },
          ),
          IconButton(
            icon: const Icon(Icons.check),
            tooltip: 'Delete images from a project',
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
        body: CustomScrollView(
          slivers: [
            SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    var name = data[index];
                    return Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(4)),
                      ),
                      color: deleteList.contains(name)
                          ? Theme.of(context).colorScheme.secondaryContainer
                          : null,
                      child: Column(
                        children: [
                          Stack(children: [
                            Align(
                              alignment: Alignment.center,
                              child: Text(name),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Visibility(
                                visible: ref.watch(deleteModeProvider),
                                child: IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    ref
                                        .read(vmSourceProvider.notifier)
                                        .checkRemove(name);
                                  },
                                ),
                              ),
                            ),
                          ]),
                          Expanded(
                            child: ViewImageLoading(name),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              textAlign: TextAlign.start,
                              decoration: const InputDecoration(
                                hintText: '출처를 여기에 적어주세요!',
                                alignLabelWithHint: true,
                              ),
                              controller: ref
                                  .watch(textEditingControllerProvider(name)),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  childCount: data.length,
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: ConstList.isSmallDisplay(context) ? 2 : 3)),
          ],
          controller: _controller,
        ),
      ),
      onWillPop: () async {
        return false;
      },
    );
  }
}
