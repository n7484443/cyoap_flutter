import 'package:cyoap_flutter/i18n.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuple/tuple.dart';

import '../../main.dart';
import '../../model/image_db.dart';
import '../../model/platform_system.dart';
import '../../viewModel/vm_editor.dart';
import '../../viewModel/vm_image_editor.dart';
import '../../viewModel/vm_make_platform.dart';
import '../view_editor.dart';
import 'controller_adjustable_scroll.dart';

class ViewImageDraggable extends ConsumerWidget {
  final void Function(WidgetRef, String) addImageFunction;
  final Widget Function(WidgetRef, int) widgetBuilder;
  final int Function(WidgetRef) widgetLength;

  const ViewImageDraggable(
      {required this.addImageFunction,
      required this.widgetBuilder,
        required this.widgetLength,
      super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!ConstList.isDesktop()) {
      return Column(
        children: [
          TextButton(
            onPressed: () {
              ref
                  .read(imageListStateProvider.notifier)
                  .addImage()
                  .then((name) => openImageEditor(ref, context, name));
            },
            child: Text('add_image'.i18n),
          ),
          Expanded(
              child: ViewImageSelector(widgetBuilder: widgetBuilder, widgetLength: widgetLength)),
        ],
      );
    }
    return Column(
      children: [
        Row(
          children: [
            Text(
              'add_image_description'.i18n,
            ),
            TextButton(
              onPressed: () {
                ref
                    .read(imageListStateProvider.notifier)
                    .addImage()
                    .then((name) => openImageEditor(ref, context, name));
              },
              child: Text('add_image'.i18n),
            ),
          ],
        ),
        Expanded(
          child: DropTarget(
            onDragDone: (detail) async {
              for (var file in detail.files) {
                var fileName = file.name;
                if (!ImageDB.regCheckImage.hasMatch(fileName)) {
                  continue;
                }
                var fileData = await file.readAsBytes();
                ref
                    .read(lastImageProvider.notifier)
                    .update((state) => fileData);
                ref.read(editorChangeProvider.notifier).needUpdate();
                openImageEditor(ref, context, fileName);
                break;
              }
            },
            onDragEntered: (detail) {
              ref.read(editorImageDragDropColorProvider.notifier).state =
                  Colors.lightBlueAccent;
            },
            onDragExited: (detail) {
              ref.read(editorImageDragDropColorProvider.notifier).state =
                  Colors.black12;
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                    color: ref.watch(editorImageDragDropColorProvider),
                    width: 5),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(4.0),
              child: ViewImageSelector(widgetBuilder: widgetBuilder, widgetLength: widgetLength),
            ),
          ),
        )
      ],
    );
  }

  void openImageEditor(WidgetRef ref, BuildContext context, String name) {
    if (name != '') {
      showDialog<Tuple2<bool, String>>(
        builder: (_) => ImageSourceDialog(name),
        context: context,
        barrierDismissible: false,
      ).then((value) {
        getPlatformFileSystem.addSource(name, value?.item2 ?? '');
        if (value?.item1 ?? false) {
          ref
              .read(imageProvider.notifier)
              .update((state) => Tuple2(name, ref.watch(lastImageProvider)!));
          ref
              .read(changeTabProvider.notifier)
              .changePageString('viewImageEditor', context);
        } else {
          ref.read(imageListStateProvider.notifier).addImageToList(name);
        }
        addImageFunction(ref, name);
      });
    }
  }
}

class ViewImageSelector extends ConsumerStatefulWidget {
  final Widget Function(WidgetRef, int) widgetBuilder;
  final int Function(WidgetRef) widgetLength;

  const ViewImageSelector({
    required this.widgetBuilder,
    required this.widgetLength,
    super.key,
  });

  @override
  ConsumerState createState() => _ViewImageSelectorState();
}

class _ViewImageSelectorState extends ConsumerState<ViewImageSelector> {
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
    return CustomScrollView(
      controller: _controller,
      slivers: [
        SliverGrid(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) => widget.widgetBuilder(ref, index),
            childCount: widget.widgetLength(ref),
          ),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: ConstList.isSmallDisplay(context) ? 2 : 4,
            crossAxisSpacing: 3.0,
            mainAxisSpacing: 3.0,
          ),
        ),
      ],
    );
  }
}
