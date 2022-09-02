import 'dart:convert';
import 'dart:typed_data';

import 'package:cyoap_flutter/model/editor.dart';
import 'package:cyoap_flutter/model/image_db.dart';
import 'package:cyoap_flutter/viewModel/vm_code_editor.dart';
import 'package:cyoap_flutter/viewModel/vm_draggable_nested_map.dart';
import 'package:cyoap_flutter/viewModel/vm_source.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/choiceNode/choice_node.dart';

final nodeEditorTargetProvider =
    StateProvider.autoDispose<ChoiceNode>((ref) => NodeEditor().target ?? ChoiceNode.empty());

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

final titleProvider = Provider.autoDispose<TextEditingController>((ref) {
  var controller =
      TextEditingController(text: ref.read(nodeEditorTargetProvider).title);
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
    NodeEditor().target?.imageString = name;
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
  Document? document;
  Ref ref;

  ChangeNotifier(this.ref) : super(false);

  void needUpdate() {
    state = true;
  }

  void update() {
    state = false;
  }

  void save() {
    ref.watch(vmCodeEditorProvider).save();
    NodeEditor().target?.title = ref.read(titleProvider).text;
    NodeEditor().target?.contentsString =
        jsonEncode(document!.toDelta().toJson());
    NodeEditor().target?.imageString =
        ImageDB().getImageName(ref.read(imageStateProvider));
    try {
      NodeEditor().target?.maximumStatus =
          int.parse(ref.read(maximumProvider).text);
    } catch (e) {
      NodeEditor().target?.maximumStatus = 0;
    }
    NodeEditor().target?.maximizingImage =
        ref.read(maximizingImageSwitchProvider);
    NodeEditor().target?.isRound = ref.read(isRoundSwitchProvider);
    NodeEditor().target?.isCard = ref.read(isCardSwitchProvider);
    NodeEditor().target?.imagePosition = ref.read(imagePositionProvider);
    NodeEditor().target?.hideTitle = ref.read(hideTitleProvider);
    NodeEditor().target?.choiceNodeMode = ref.read(nodeModeProvider);

    ref.read(draggableNestedMapChangedProvider.notifier).state = true;
    state = false;
  }
}

final lastImageProvider = StateProvider<Uint8List?>((ref) => null);
