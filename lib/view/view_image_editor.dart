import 'package:cyoap_flutter/viewModel/vm_editor.dart';
import 'package:cyoap_flutter/viewModel/vm_image_editor.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../viewModel/vm_make_platform.dart';

class ViewImageEditor extends ConsumerWidget {
  const ViewImageEditor({Key? key}) : super(key: key);

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
                  initCropRectType: InitCropRectType.imageRect,
                  editActionDetailsIsChanged: (EditActionDetails? details) {});
            },
          ),
        ),
        FloatingActionButton(
          child: const Icon(Icons.crop),
          onPressed: () async {
            ref.read(lastImageProvider.notifier).update((state) => null);
            ref.read(imageStateProvider.notifier)
                .addImageCrop(ref.read(imageProvider)!.item1,
                    await ref.read(cropImageProvider.future))
                .then((value) =>
                    ref.read(changeTabProvider.notifier).back(context));
          },
        ),
      ],
    );
  }
}
