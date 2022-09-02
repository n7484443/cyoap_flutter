import 'dart:convert';
import 'dart:typed_data';

import 'package:cyoap_flutter/model/image_db.dart';
import 'package:cyoap_flutter/viewModel/vm_code_editor.dart';
import 'package:cyoap_flutter/viewModel/vm_draggable_nested_map.dart';
import 'package:cyoap_flutter/viewModel/vm_source.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/choiceNode/choice_node.dart';

final nodeEditorTargetProvider = StateProvider.autoDispose<ChoiceNode>((ref) {
  return ChoiceNode.empty();
});

final isCardSwitchProvider = StateProvider.autoDispose<bool>(
    (ref) => ref.watch(nodeEditorTargetProvider).isCard);
final isRoundSwitchProvider = StateProvider.autoDispose<bool>(
    (ref) => ref.watch(nodeEditorTargetProvider).isRound);
final hideTitleProvider = StateProvider.autoDispose<bool>(
    (ref) => ref.watch(nodeEditorTargetProvider).hideTitle);
final maximizingImageSwitchProvider = StateProvider.autoDispose<bool>(
    (ref) => ref.watch(nodeEditorTargetProvider).maximizingImage);
final imagePositionProvider = StateProvider.autoDispose<int>(
    (ref) => ref.watch(nodeEditorTargetProvider).imagePosition);
final nodeModeProvider = StateProvider.autoDispose<ChoiceNodeMode>(
    (ref) => ref.watch(nodeEditorTargetProvider).choiceNodeMode);

final titleControllerProvider =
    Provider.autoDispose<TextEditingController>((ref) {
  var controller =
      TextEditingController(text: ref.watch(nodeEditorTargetProvider).title);
  controller.addListener(() {
    ref.read(changeProvider.notifier).needUpdate();
  });
  ref.onDispose(() => controller.dispose());
  return controller;
});
final maximumProvider = Provider.autoDispose<TextEditingController>((ref) {
  var controller = TextEditingController(
      text: ref.read(nodeEditorTargetProvider).maximumStatus.toString());
  controller.addListener(() {
    ref.read(changeProvider.notifier).needUpdate();
  });
  ref.onDispose(() => controller.dispose());
  return controller;
});
final quillEditorProvider = Provider<QuillController>((ref) {
  QuillController controller;
  if (ref.read(nodeEditorTargetProvider).contentsString.isEmpty) {
    controller = QuillController.basic();
  } else {
    controller = QuillController(
        document: Document.fromJson(
            jsonDecode(ref.read(nodeEditorTargetProvider).contentsString)),
        selection: const TextSelection.collapsed(offset: 0));
  }
  controller.addListener(() {
    ref.read(changeProvider.notifier).needUpdate();
  });
  ref.onDispose(() => controller.dispose());
  return controller;
});

final imageSourceProvider = StateProvider.autoDispose<String>((ref) => "");

final imageListStateProvider =
    StateNotifierProvider.autoDispose<ImageListStateNotifier, List<String>>(
        (ref) => ImageListStateNotifier(ref));

class ImageListStateNotifier extends StateNotifier<List<String>> {
  Ref ref;

  ImageListStateNotifier(this.ref) : super(ImageDB().imageList);

  Future<String> addImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      withData: true,
      allowedExtensions: ['png', 'jpg', 'jpeg', 'gif', 'webp', 'bmp'],
      type: FileType.custom,
    );
    String name = '';
    if (result != null) {
      name = result.files.single.name;
      ref
          .read(lastImageProvider.notifier)
          .update((state) => result.files.single.bytes);
      ref.read(changeProvider.notifier).state = true;
    }
    return name;
  }

  Future<void> addImageToList(String name, {Uint8List? data}) async {
    ImageDB().uploadImages(name, data ?? ref.read(lastImageProvider)!);
    ref.read(nodeEditorTargetProvider).imageString = name;
    ref.read(imageStateProvider.notifier).state = ImageDB().getImageIndex(name);
    ref.read(draggableNestedMapChangedProvider.notifier).state = true;
    ref.read(changeProvider.notifier).state = true;
    ref.read(lastImageProvider.notifier).update((state) => null);
    ref.invalidate(vmSourceProvider);
    state = [...ImageDB().imageList];
  }
}

final imageStateProvider = StateProvider.autoDispose<int>((ref) =>
    ImageDB().getImageIndex(ref.read(nodeEditorTargetProvider).imageString));

final changeProvider =
    StateNotifierProvider<ChangeNotifier, bool>((ref) => ChangeNotifier(ref));

class ChangeNotifier extends StateNotifier<bool> {
  Ref ref;

  ChangeNotifier(this.ref) : super(false);

  void needUpdate() {
    state = true;
  }

  void update() {
    state = false;
  }

  void save() {
    ref.read(nodeEditorTargetProvider).recursiveStatus.conditionClickableString =
        ref.read(controllerClickableProvider).text;
    ref.read(nodeEditorTargetProvider).recursiveStatus.conditionVisibleString =
        ref.read(controllerVisibleProvider).text;
    ref.read(nodeEditorTargetProvider).recursiveStatus.executeCodeString =
        ref.read(controllerExecuteProvider).text;
    ref.read(nodeEditorTargetProvider).title =
        ref.read(titleControllerProvider).text;
    ref.read(nodeEditorTargetProvider).contentsString =
        jsonEncode(ref.read(quillEditorProvider).document.toDelta().toJson());
    ref.read(nodeEditorTargetProvider).imageString =
        ImageDB().getImageName(ref.read(imageStateProvider));
    try {
      ref.read(nodeEditorTargetProvider).maximumStatus =
          int.parse(ref.read(maximumProvider).text);
    } catch (e) {
      ref.read(nodeEditorTargetProvider).maximumStatus = 0;
    }
    ref.read(nodeEditorTargetProvider).maximizingImage =
        ref.read(maximizingImageSwitchProvider);
    ref.read(nodeEditorTargetProvider).isRound =
        ref.read(isRoundSwitchProvider);
    ref.read(nodeEditorTargetProvider).isCard = ref.read(isCardSwitchProvider);
    ref.read(nodeEditorTargetProvider).imagePosition =
        ref.read(imagePositionProvider);
    ref.read(nodeEditorTargetProvider).hideTitle = ref.read(hideTitleProvider);
    ref.read(nodeEditorTargetProvider).choiceNodeMode =
        ref.read(nodeModeProvider);

    ref.read(draggableNestedMapChangedProvider.notifier).state = true;
    state = false;
  }
}

final lastImageProvider = StateProvider<Uint8List?>((ref) => null);
