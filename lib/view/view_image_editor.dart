import 'package:cyoap_flutter/viewModel/vm_editor.dart';
import 'package:cyoap_flutter/viewModel/vm_image_editor.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
        ],
        selectedIndex: ref.watch(imageCropIndexProvider),
        onDestinationSelected: (index) {
          ref.read(imageCropIndexProvider.notifier).state = index;
          switch (index) {
            case 0:
              ref.read(imageCropRatioProvider.notifier).state = null;
              break;
            case 1:
              ref.read(imageCropRatioProvider.notifier).state = 4 / 3;
              break;
            case 2:
              ref.read(imageCropRatioProvider.notifier).state = 3 / 2;
              break;
            case 3:
              ref.read(imageCropRatioProvider.notifier).state = 16 / 9;
              break;
            case 4:
              ref.read(imageCropRatioProvider.notifier).state = 1;
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
                  cropAspectRatio: ref.watch(imageCropRatioProvider),
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
