import 'package:cyoap_flutter/viewModel/vm_editor.dart';
import 'package:cyoap_flutter/viewModel/vm_image_editor.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuple/tuple.dart';

import '../viewModel/vm_make_platform.dart';

class ViewImageEditor extends ConsumerWidget {
  const ViewImageEditor({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: const ViewImageEditorContents(),
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(icon: Icon(Icons.close), label: "자유"),
          NavigationDestination(icon: Icon(Icons.aspect_ratio), label: "4:3"),
          NavigationDestination(icon: Icon(Icons.aspect_ratio), label: "3:2"),
          NavigationDestination(icon: Icon(Icons.aspect_ratio), label: "16:9"),
          NavigationDestination(icon: Icon(Icons.aspect_ratio), label: "1:1"),
          NavigationDestination(icon: Icon(Icons.crop_rotate), label: "회전"),
        ],
        selectedIndex: ref.watch(imageCropIndexProvider),
        onDestinationSelected: (index) {
          if (index != 5) {
            ref.read(imageCropIndexProvider.notifier).state = index;
          }
          switch (index) {
            case 0:
              ref.read(imageCropRatioProvider.notifier).state = null;
              break;
            case 1:
              ref.read(imageCropRatioProvider.notifier).state =
                  const Tuple2(4, 3);
              break;
            case 2:
              ref.read(imageCropRatioProvider.notifier).state =
                  const Tuple2(3, 2);
              break;
            case 3:
              ref.read(imageCropRatioProvider.notifier).state =
                  const Tuple2(16, 9);
              break;
            case 4:
              ref.read(imageCropRatioProvider.notifier).state =
                  const Tuple2(1, 1);
              break;
            case 5:
              var data = ref.read(imageCropRatioProvider);
              if (data != null) {
                ref.read(imageCropRatioProvider.notifier).state =
                    Tuple2(data.item2, data.item1);
              }
              break;
          }
        },
      ),
    );
  }
}

class ViewImageEditorContents extends ConsumerWidget {
  const ViewImageEditorContents({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var data = ref.watch(imageCropRatioProvider);
    return Column(
      children: [
        Flexible(
          child: ExtendedImage.memory(
            ref.watch(imageProvider)!.item2,
            fit: BoxFit.contain,
            mode: ExtendedImageMode.editor,
            extendedImageEditorKey: ref.watch(globalEditorKeyProvider),
            initEditorConfigHandler: (ExtendedImageState? state) {
              return EditorConfig(
                  maxScale: 4.0,
                  hitTestSize: 20.0,
                  cropRectPadding: const EdgeInsets.all(10.0),
                  cropAspectRatio:
                      data == null ? null : data.item1 / data.item2,
                  initCropRectType: InitCropRectType.imageRect,
                  editActionDetailsIsChanged: (EditActionDetails? details) {});
            },
          ),
        ),
        FloatingActionButton(
          child: const Icon(Icons.crop),
          onPressed: () async {
            ref.read(lastImageProvider.notifier).update((state) => null);
            ref
                .read(imageListStateProvider.notifier)
                .addImageToList(ref.read(imageProvider)!.item1,
                    data: await ref.read(cropImageProvider.future))
                .then((value) =>
                    ref.read(changeTabProvider.notifier).back(context));
          },
        ),
      ],
    );
  }
}