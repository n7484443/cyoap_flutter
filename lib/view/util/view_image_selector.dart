import 'dart:math';

import 'package:cyoap_flutter/i18n.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  final String Function(WidgetRef, int) imageName;
  final bool isRemovable;
  final void Function(WidgetRef, int)? removeFunction;

  const ViewImageDraggable(
      {required this.addImageFunction,
      required this.widgetBuilder,
      required this.widgetLength,
      required this.imageName,
      this.isRemovable = false,
      this.removeFunction,
      super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    widgetBuilderEdit(ref, index) {
      return Stack(children: [
        Positioned(
            top: 0,
            right: 0,
            left: 0,
            bottom: 0,
            child: widgetBuilder(ref, index)),
        Positioned(
          top: 0,
          right: 0,
          child: IconButton(
            icon: const Icon(Icons.crop),
            onPressed: () {
              openImageEditor(ref, context, imageName(ref, index),
                  change: true);
            },
          ),
        ),
        if (isRemovable)
          Positioned(
            top: 0,
            left: 0,
            child: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                if (removeFunction != null) {
                  removeFunction!(ref, index);
                }
              },
            ),
          ),
      ]);
    }

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
              child: ViewImageSelector(
                  widgetBuilder: widgetBuilderEdit,
                  widgetLength: widgetLength)),
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
            const Spacer(),
            Slider(
              value: ref.watch(shownImageNumProvider).toDouble(),
              min: 3,
              max: 8,
              onChanged: (double value) {
                ref.read(shownImageNumProvider.notifier).state = value.toInt();
              },
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
              child: ViewImageSelector(
                  widgetBuilder: widgetBuilderEdit, widgetLength: widgetLength),
            ),
          ),
        )
      ],
    );
  }

  void openImageEditor(WidgetRef ref, BuildContext context, String name,
      {bool change = false}) {
    if (name != '') {
      if (change) {
        ref
            .read(imageProvider.notifier)
            .update((state) => (name, ImageDB().getImage(name)!));
        ref
            .read(changeTabProvider.notifier)
            .changePageString('viewImageEditor', context);
        addImageFunction(ref, name);
      } else {
        var defaultName = name;
        while (ImageDB().imageList.contains(name) ||
            ImageDB()
                .imageList
                .contains(name.replaceAll(ImageDB.regCheckImage, ".webp"))) {
          name = defaultName + Random().nextInt(999999).toString();
        }
        showDialog<(bool, String)>(
          builder: (_) => ImageSourceDialog(name),
          context: context,
          barrierDismissible: false,
        ).then((value) {
          getPlatformFileSystem.addSource(name, value?.$2 ?? '');
          if (value?.$1 ?? false) {
            ref
                .read(imageProvider.notifier)
                .update((state) => (name, ref.watch(lastImageProvider)!));
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
            (BuildContext context, int index) =>
                widget.widgetBuilder(ref, index),
            childCount: widget.widgetLength(ref),
          ),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: ref.watch(shownImageNumProvider),
            crossAxisSpacing: 3.0,
            mainAxisSpacing: 3.0,
          ),
        ),
      ],
    );
  }
}
