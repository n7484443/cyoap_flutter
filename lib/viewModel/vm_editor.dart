import 'dart:convert';
import 'dart:typed_data';

import 'package:cyoap_flutter/model/editor.dart';
import 'package:cyoap_flutter/model/image_db.dart';
import 'package:cyoap_flutter/model/platform_system.dart';
import 'package:cyoap_flutter/viewModel/vm_draggable_nested_map.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/choiceNode/choice_node.dart';

final nodeEditorTargetProvider =
    StateProvider.autoDispose<ChoiceNode>((ref) => NodeEditor().target);

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

final contentEditProvider = Provider.autoDispose<QuillController>((ref) {
  var controller = QuillController(
      document: Document.fromJson(
          jsonDecode(ref.read(nodeEditorTargetProvider).contentsString)),
      selection: const TextSelection.collapsed(offset: 0));
  controller.addListener(() {
    ref.read(changeProvider.notifier).setUpdated();
  });
  ref.onDispose(() {
    controller.dispose();
  });
  return controller;
});

final titleProvider = StateProvider.autoDispose<String>(
    (ref) => ref.watch(nodeEditorTargetProvider).title);
final maximumProvider = StateProvider.autoDispose<String>(
    (ref) => ref.watch(nodeEditorTargetProvider).maximumStatus.toString());
final imageSourceProvider = StateProvider.autoDispose<String>((ref) => "");

final imageStateProvider =
    StateNotifierProvider.autoDispose<ImageStateNotifier, int>(
        (ref) => ImageStateNotifier(ref));

class ImageStateNotifier extends StateNotifier<int> {
  Ref ref;

  ImageStateNotifier(this.ref)
      : super(ImageDB()
            .getImageIndex(ref.read(nodeEditorTargetProvider).imageString));

  void setIndex(int index) {
    if (state == index) {
      state = -1;
    } else {
      state = index;
    }
    ref.read(changeProvider.notifier).state = true;
  }

  int getImageLength() {
    return ImageDB().imageList.length;
  }

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

  Future<void> addImageCrop(String name, Uint8List data) async {
    ImageDB().uploadImages(name, data);
    NodeEditor().target.imageString = name;
    state = ImageDB().getImageIndex(name);
    ref.read(draggableNestedMapChangedProvider.notifier).state = true;
    ref.read(changeProvider.notifier).state = true;
    ref.read(lastImageProvider.notifier).update((state) => null);
  }

  void addImageSource(String name) {
    getPlatformFileSystem.addSource(name, ref.read(imageSourceProvider));
  }
}

final changeProvider =
    StateNotifierProvider<ChangeNotifier, bool>((ref) => ChangeNotifier(ref));

class ChangeNotifier extends StateNotifier<bool> {
  Ref ref;
  ChangeNotifier(this.ref) : super(false);

  void setUpdated() {
    state = true;
  }

  void update() {
    state = false;
  }

  void save() {
    NodeEditor().target.title = ref.read(titleProvider);
    NodeEditor().target.contentsString =
        jsonEncode(ref.read(contentEditProvider).document.toDelta().toJson());
    NodeEditor().target.imageString =
        ImageDB().getImageName(ref.read(imageStateProvider));
    try {
      NodeEditor().target.maximumStatus = int.parse(ref.read(maximumProvider));
    } catch (e) {
      NodeEditor().target.maximumStatus = 0;
    }
    NodeEditor().target.maximizingImage =
        ref.read(maximizingImageSwitchProvider);
    NodeEditor().target.isRound = ref.read(isRoundSwitchProvider);
    NodeEditor().target.isCard = ref.read(isCardSwitchProvider);
    NodeEditor().target.imagePosition = ref.read(imagePositionProvider);
    NodeEditor().target.hideTitle = ref.read(hideTitleProvider);
    NodeEditor().target.choiceNodeMode = ref.read(nodeModeProvider);

    ref.read(draggableNestedMapChangedProvider.notifier).state = true;
    state = false;
  }
}

final lastImageProvider = StateProvider<Uint8List?>((ref) => null);
