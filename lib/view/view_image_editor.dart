import 'package:cyoap_flutter/i18n.dart';
import 'package:cyoap_flutter/viewModel/vm_choice_node.dart';
import 'package:cyoap_flutter/viewModel/vm_editor.dart';
import 'package:cyoap_flutter/viewModel/vm_image_editor.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../viewModel/vm_draggable_nested_map.dart';
import '../viewModel/vm_make_platform.dart';

class ViewImageEditor extends ConsumerWidget {
  const ViewImageEditor({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: const ViewImageEditorContents(),
      appBar: AppBar(
        title: ref.watch(imageCropIndexProvider) == 0
            ? Center(
                child: SizedBox(
                  width: 300,
                  height: 25,
                  child: Row(
                    children: [
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: TextField(
                            textAlign: TextAlign.center,
                            controller: ref.watch(textFieldWidthRatioProvider),
                            decoration: const InputDecoration(
                              hintText: 'Width Ratio',
                            ),
                          ),
                        ),
                      ),
                      const FittedBox(
                        child: Text(
                          ':',
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: TextField(
                            textAlign: TextAlign.center,
                            controller: ref.watch(textFieldHeightRatioProvider),
                            decoration: const InputDecoration(
                              hintText: 'Height Ratio',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : null,
      ),
      bottomNavigationBar: NavigationBar(
        destinations: [
          NavigationDestination(
              icon: const Icon(Icons.close), label: "crop_ratio_free".i18n),
          const NavigationDestination(
              icon: Icon(Icons.aspect_ratio), label: "4:3"),
          const NavigationDestination(
              icon: Icon(Icons.aspect_ratio), label: "3:2"),
          const NavigationDestination(
              icon: Icon(Icons.aspect_ratio), label: "16:9"),
          const NavigationDestination(
              icon: Icon(Icons.aspect_ratio), label: "1:1"),
          NavigationDestination(
              icon: const Icon(Icons.crop_rotate), label: "crop_rotate".i18n),
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
                  const (4, 3);
              break;
            case 2:
              ref.read(imageCropRatioProvider.notifier).state =
                  const (3, 2);
              break;
            case 3:
              ref.read(imageCropRatioProvider.notifier).state =
                  const (16, 9);
              break;
            case 4:
              ref.read(imageCropRatioProvider.notifier).state =
                  const (1, 1);
              break;
            case 5:
              var data = ref.read(imageCropRatioProvider);
              if (data != null) {
                ref.read(imageCropRatioProvider.notifier).state =
                    (data.$2, data.$1);
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
    if (data == null || data.$1 == null || data.$2 == null) {
      data = null;
    }
    var image = ref.watch(imageProvider);
    if (image == null) {
      return const SizedBox.shrink();
    }
    return Column(
      children: [
        Flexible(
          child: ExtendedImage.memory(
            image.$2,
            fit: BoxFit.contain,
            mode: ExtendedImageMode.editor,
            extendedImageEditorKey: ref.watch(globalEditorKeyProvider),
            initEditorConfigHandler: (ExtendedImageState? state) {
              return EditorConfig(
                  maxScale: 4.0,
                  hitTestSize: 20.0,
                  cropRectPadding: const EdgeInsets.all(10.0),
                  cropAspectRatio:
                      data == null ? null : data.$1! / data.$2!,
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
                .addImageToList(image.$1,
                    data: await ref.read(cropImageProvider.future))
                .then((value) {
              var pos = ref.read(nodeEditorTargetPosProvider);
              if (pos != null) {
                ref.read(choiceNodeStatusProvider(pos)).node?.imageString =
                    image.$1;
              }
              ref.read(vmDraggableNestedMapProvider).refresh();
              ref.read(changeTabProvider.notifier).home(context);
            });
          },
        ),
      ],
    );
  }
}
