import 'package:cyoap_core/design_setting.dart';
import 'package:cyoap_flutter/i18n.dart';
import 'package:cyoap_flutter/view/util/controller_adjustable_scroll.dart';
import 'package:cyoap_flutter/view/util/view_image_loading.dart';
import 'package:cyoap_flutter/view/util/view_image_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/platform_system.dart';
import '../viewModel/vm_design_setting.dart';
import '../viewModel/vm_editor.dart';
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
    Widget icon;
    if (!ref.watch(deleteModeProvider)) {
      icon = Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'remove_image'.i18n,
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
            tooltip: 'remove_image_undo'.i18n,
            onPressed: () {
              ref.read(deleteImageListProvider.notifier).update((state) => []);
              ref.read(deleteModeProvider.notifier).update((state) => false);
            },
          ),
          IconButton(
            icon: const Icon(Icons.check),
            tooltip: 'remove_image'.i18n,
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
              ref.read(changeTabProvider.notifier).home(context);
            },
          ),
          title: icon,
        ),
        body: Column(children: [
          DropdownButtonFormField<ImageAttribute>(
            decoration: InputDecoration(labelText: 'background_image'.i18n),
            items: ImageAttribute.values
                .map((e) => DropdownMenuItem(value: e, child: Text(e.name)))
                .toList(),
            onChanged: (ImageAttribute? t) {
              if (t != null) {
                ref
                    .read(backgroundAttributeProvider.notifier)
                    .update((state) => t);
              }
            },
            value: ref.watch(backgroundAttributeProvider),
          ),
          Expanded(
            child: ViewImageDraggable(
              addImageFunction: (ref, name) {},
              widgetBuilder: (ref, index) => ViewSourceItem(index: index),
              widgetLength: (ref) => ref.watch(vmSourceProvider).length,
              imageName: (ref, index) => ref.read(vmSourceProvider)[index],
              isRemovable: ref.watch(deleteModeProvider),
              removeFunction: (ref, index) =>
                  ref.read(vmSourceProvider.notifier).checkRemove(index),
            ),
          ),
        ]),
      ),
      onWillPop: () async {
        return false;
      },
    );
  }
}

class ViewSourceItem extends ConsumerStatefulWidget {
  final int index;

  const ViewSourceItem({
    required this.index,
    super.key,
  });

  @override
  ConsumerState createState() => _ViewSourceItemState();
}

class _ViewSourceItemState extends ConsumerState<ViewSourceItem> {
  TextEditingController? _textEditingController;

  @override
  void initState() {
    var name = ref.read(vmSourceProvider)[widget.index];
    _textEditingController = TextEditingController();
    if (getPlatformFileSystem.hasSource(name)) {
      _textEditingController?.text =
          getPlatformFileSystem.getSource(name) ?? '';
    }
    _textEditingController?.addListener(() {
      getPlatformFileSystem.addSource(name, _textEditingController?.text ?? '');
    });
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var name = ref.watch(vmSourceProvider)[widget.index];
    var deleteList = ref.watch(deleteImageListProvider);
    return InkWell(
      onDoubleTap: () {
        if (ref.read(backgroundCurrentStateProvider) == widget.index) {
          ref.read(backgroundCurrentStateProvider.notifier).state = -1;
          ref.read(backgroundProvider.notifier).state = null;
        } else {
          ref.read(backgroundCurrentStateProvider.notifier).state =
              widget.index;
          ref.read(backgroundProvider.notifier).state =
              ref.read(imageListStateProvider)[widget.index];
        }
        ref.read(editorChangeProvider.notifier).needUpdate();
      },
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: ref.watch(backgroundCurrentStateProvider) == widget.index
                ? Colors.red
                : Theme.of(context).colorScheme.outline,
            width: 4,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(4)),
        ),
        color: deleteList.contains(name)
            ? Theme.of(context).colorScheme.secondaryContainer
            : null,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            children: [
              Expanded(
                child: ViewImageLoading(name),
              ),
              Text(name),
              const Divider(),
              SizedBox(
                height: 24,
                child: TextField(
                  textAlign: TextAlign.start,
                  decoration: InputDecoration(
                    hintText: 'source_hint'.i18n,
                    alignLabelWithHint: true,
                  ),
                  controller: _textEditingController,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
