import 'package:cyoap_core/design_setting.dart';
import 'package:cyoap_flutter/i18n.dart';
import 'package:cyoap_flutter/main.dart';
import 'package:cyoap_flutter/view/util/controller_adjustable_scroll.dart';
import 'package:cyoap_flutter/view/util/view_image_loading.dart';
import 'package:cyoap_flutter/view/util/view_image_selector.dart';
import 'package:cyoap_flutter/view/util/view_options.dart';
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

    var designSetting = ref.watch(platformDesignSettingProvider);
    return PopScope(
      canPop: false,
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
        body: Padding(
          padding: const EdgeInsets.all(ConstList.paddingHuge),
          child: Column(children: [
            Row(
              children: [
                Expanded(
                  child: CustomDropdownButton<ImageAttribute>(
                    label: 'background_image_batch_option'.i18n,
                    value: ref
                        .watch(platformDesignSettingProvider)
                        .backgroundAttribute,
                    items: ImageAttribute.values
                        .map((e) =>
                            DropdownMenuItem(value: e, child: Text(e.name)))
                        .toList(),
                    onChanged: (ImageAttribute? t) {
                      if (t != null) {
                        ref.read(platformDesignSettingProvider.notifier).state =
                            designSetting.copyWith(backgroundAttribute: t);
                      }
                    },
                  ),
                ),
                if(!ConstList.isMobile())const Spacer(),
              ],
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
      ),
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
    var designSetting = ref.watch(platformDesignSettingProvider);
    return InkWell(
      onDoubleTap: () {
        if (ref.read(backgroundCurrentStateProvider) == widget.index) {
          ref.read(backgroundCurrentStateProvider.notifier).state = -1;
          ref.read(platformDesignSettingProvider.notifier).state =
              designSetting.copyWith(backgroundImage: null);
        } else {
          ref.read(backgroundCurrentStateProvider.notifier).state =
              widget.index;
          ref.read(platformDesignSettingProvider.notifier).state =
              designSetting.copyWith(
                  backgroundImage:
                      ref.read(imageListStateProvider)[widget.index]);
        }
      },
      child: Card(
        shape: ref.watch(backgroundCurrentStateProvider) == widget.index
            ? const RoundedRectangleBorder(
                side: BorderSide(
                  color: Colors.red,
                  width: 2,
                ),
                borderRadius: BorderRadius.all(Radius.circular(4)),
              )
            : null,
        color: deleteList.contains(name)
            ? Theme.of(context).colorScheme.secondaryContainer
            : null,
        child: Column(
          children: [
            Expanded(
              child: ViewImageLoading(name),
            ),
            Text(
              name,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            const Divider(height: 2),
            Padding(
              padding: const EdgeInsets.all(ConstList.paddingSmall),
              child: SizedBox(
                height: 24,
                child: TextField(
                  textAlign: TextAlign.start,
                  decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.fromLTRB(2.0, 1.0, 2.0, 11.0),
                    hintText: 'source_hint'.i18n,
                    alignLabelWithHint: true,
                    border: InputBorder.none,
                  ),
                  maxLines: 1,
                  controller: _textEditingController,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
