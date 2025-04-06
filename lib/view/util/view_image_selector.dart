import 'dart:math';
import 'dart:typed_data';

import 'package:cyoap_flutter/i18n.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:super_drag_and_drop/super_drag_and_drop.dart';

import '../../main.dart';
import '../../model/image_db.dart';
import '../../viewModel/edit/vm_editor.dart';
import '../../viewModel/edit/vm_image_editor.dart';
import '../../viewModel/edit/vm_make_platform.dart';
import '../edit/view_editor.dart';

class ViewImageDraggable extends ConsumerWidget {
  final void Function(WidgetRef, String) addImageFunction;
  final Widget Function(WidgetRef, int) widgetBuilder;
  final int Function(WidgetRef) widgetLength;
  final String Function(WidgetRef, int) imageName;
  final bool isRemovable;
  final void Function(WidgetRef, int)? removeFunction;

  const ViewImageDraggable(
      {required this.addImageFunction, required this.widgetBuilder, required this.widgetLength, required this.imageName, this.isRemovable = false, this.removeFunction, super.key});

  void addImage(BuildContext context, WidgetRef ref) async {
    List<PlatformFile>? platformFileList = await ref.read(imageListStateProvider.notifier).addImage();
    if (platformFileList == null) {
      return;
    }
    for (var file in platformFileList) {
      if (file.bytes == null) {
        continue;
      }
      addImageToDatabase(ref, file.name, file.bytes!);
    }
    if (platformFileList.length == 1) {
      var file = platformFileList.single;
      var name = file.name;
      ref.read(lastImageProvider.notifier).update((state) => file.bytes);
      openImageEditor(ref, context, name, justOpen: false);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    widgetBuilderEdit(ref, index) {
      return Stack(children: [
        Positioned(top: 0, right: 0, left: 0, bottom: 0, child: widgetBuilder(ref, index)),
        Positioned(
          top: 0,
          right: 0,
          child: IconButton(
            icon: const Icon(Icons.crop),
            onPressed: () {
              openImageEditor(ref, context, imageName(ref, index), justOpen: true);
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
            onPressed: () => addImage(context, ref),
            child: Text('add_image'.i18n),
          ),
          Expanded(child: ViewImageSelector(widgetBuilder: widgetBuilderEdit, widgetLength: widgetLength)),
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
              onPressed: () => addImage(context, ref),
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
          child: Card(
            color: ref.watch(editorImageDragDropColorProvider) ? Theme.of(context).highlightColor : null,
            child: DropRegion(
              formats: [...Formats.standardFormats]
                ..remove(Formats.plainText)
                ..remove(Formats.htmlText)
                ..remove(Formats.uri)
                ..remove(Formats.fileUri),
              onDropOver: (DropOverEvent event) async {
                return DropOperation.copy;
              },
              onPerformDrop: (PerformDropEvent event) async {
                var items = event.session.items;
                for (var item in items) {
                  var nameFuture = item.dataReader?.getSuggestedName();
                  if (nameFuture == null) {
                    continue;
                  }
                  var name = await nameFuture;
                  if (name == null) {
                    continue;
                  }
                  item.dataReader!.getFile(null, (file) async {
                    var fileName = file.fileName ?? Random().nextInt(10000000).toString();
                    if (!ImageDB.regCheckImage.hasMatch(fileName)) {
                      return;
                    }
                    var fileData = await file.readAll();
                    addImageToDatabase(ref, fileName, fileData);
                    if (items.length == 1) {
                      openImageEditor(ref, context, fileName, justOpen: false);
                    }
                    file.close();
                  });
                }
              },
              onDropEnter: (DropEvent event) {
                ref.read(editorImageDragDropColorProvider.notifier).state = true;
              },
              onDropLeave: (DropEvent event) {
                ref.read(editorImageDragDropColorProvider.notifier).state = false;
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ViewImageSelector(widgetBuilder: widgetBuilderEdit, widgetLength: widgetLength),
              ),
            ),
          ),
        )
      ],
    );
  }

  void addImageToDatabase(WidgetRef ref, String name, Uint8List data) {
    if (name == '') {
      return;
    }
    ref.read(lastImageProvider.notifier).update((state) => data);
    var defaultName = name;
    while (ImageDB().imageList.contains(name) || ImageDB().imageList.contains(name.replaceAll(ImageDB.regCheckImage, ".webp"))) {
      name = defaultName + Random().nextInt(999999).toString();
    }
    ref.read(imageListStateProvider.notifier).addImageToList(name);
  }

  void openImageEditor(WidgetRef ref, BuildContext context, String name, {required bool justOpen}) async {
    if (!justOpen) {
      var value = await showDialog<(bool, String)>(
        builder: (_) => ImageSourceDialog(name),
        context: context,
        barrierDismissible: false,
      );
      if (!(value?.$1 ?? false)) {
        return;
      }
    }
    ref.read(imageProvider.notifier).update((state) => (name, ImageDB().getImage(name)!));
    ref.read(changeTabProvider.notifier).changePageString('viewImageEditor', context);
    addImageFunction(ref, name);
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
    _controller = ScrollController();
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
            crossAxisCount: ref.watch(shownImageNumProvider),
            crossAxisSpacing: 3.0,
            mainAxisSpacing: 3.0,
          ),
        ),
      ],
    );
  }
}
