import 'dart:typed_data';

import 'package:cyoap_core/choiceNode/choice_node.dart';
import 'package:cyoap_core/choiceNode/pos.dart';
import 'package:cyoap_flutter/model/image_db.dart';
import 'package:cyoap_flutter/model/platform_system.dart';
import 'package:cyoap_flutter/viewModel/vm_draggable_nested_map.dart';
import 'package:cyoap_flutter/viewModel/vm_source.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../util/platform_specified_util/webp_converter.dart';

final nodeEditorTargetPosProvider = StateProvider<Pos?>((ref) {
  return null;
});

final nodeEditorTargetProvider =
    ChangeNotifierProvider<NodeEditorTargetNotifier>((ref) {
  var pos = ref.watch(nodeEditorTargetPosProvider);
  if (pos == null) {
    return NodeEditorTargetNotifier(ChoiceNode.empty(), ref);
  }
  return NodeEditorTargetNotifier(getPlatform.getChoiceNode(pos)!.clone(), ref);
});

class NodeEditorTargetNotifier extends ChangeNotifier {
  ChoiceNode node;
  Ref ref;

  NodeEditorTargetNotifier(this.node, this.ref);

  void update() {
    var pos = ref.watch(nodeEditorTargetPosProvider);
    if (pos == null) {
      node = ChoiceNode.empty();
    } else {
      node = getPlatform.getChoiceNode(pos)?.clone() ?? ChoiceNode.empty();
    }
    notifyListeners();
  }
}

final nodeEditorDesignProvider =
    StateProvider.autoDispose<ChoiceNodeOption>((ref) {
  ref.listenSelf((previous, ChoiceNodeOption next) {
    ref.read(nodeEditorTargetProvider).node.choiceNodeOption = next;
    ref.read(editorChangeProvider.notifier).needUpdate();
  });
  return ref.watch(nodeEditorTargetProvider).node.choiceNodeOption;
});

final nodeModeProvider = StateProvider.autoDispose<ChoiceNodeMode>((ref) {
  ref.listenSelf((previous, ChoiceNodeMode next) {
    ref.read(nodeEditorTargetProvider).node.choiceNodeMode = next;
    if (next == ChoiceNodeMode.onlyCode) {
      ref
          .read(nodeEditorTargetProvider.notifier)
          .node
          .recursiveStatus
          .conditionClickableCode = [];
      ref
          .read(nodeEditorTargetProvider.notifier)
          .node
          .recursiveStatus
          .conditionVisibleCode = [];
      ref
          .read(nodeEditorTargetProvider.notifier)
          .node
          .recursiveStatus
          .conditionClickableString = null;
      ref
          .read(nodeEditorTargetProvider.notifier)
          .node
          .recursiveStatus
          .conditionVisibleString = null;
    }
    ref.read(editorChangeProvider.notifier).needUpdate();
  });
  return ref.watch(nodeEditorTargetProvider).node.choiceNodeMode;
});
final nodeTitleProvider = StateProvider.autoDispose<String>(
    (ref) => ref.watch(nodeEditorTargetProvider).node.title);

final maximumProvider = Provider.autoDispose<TextEditingController>((ref) {
  var node = ref.watch(nodeEditorTargetProvider).node;
  var controller = TextEditingController(text: node.maximumStatus.toString());
  controller.addListener(() {
    ref.read(nodeEditorTargetProvider).node.maximumStatus =
        int.tryParse(controller.text) ?? 0;
    ref.read(editorChangeProvider.notifier).needUpdate();
  });
  ref.onDispose(() => controller.dispose());
  return controller;
});

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
      ref.read(editorChangeProvider.notifier).state = true;
    }
    return name;
  }

  Future<void> addImageToList(String name, {Uint8List? data}) async {
    var before = data ?? ref.read(lastImageProvider)!;
    var out = await WebpConverter.instance!.convert(before, name);

    ImageDB().uploadImages(out.item1, out.item2);
    ref.read(imageStateProvider.notifier).state =
        ImageDB().getImageIndex(out.item1);
    ref.read(draggableNestedMapChangedProvider.notifier).state = true;
    ref.read(editorChangeProvider.notifier).state = true;
    ref.read(lastImageProvider.notifier).update((state) => null);
    ref.invalidate(vmSourceProvider);
    state = [...ImageDB().imageList];
  }
}

final imageStateProvider = StateProvider.autoDispose<int>((ref) {
  ref.listenSelf((previous, int index) {
    ref.read(nodeEditorTargetProvider).node.imageString =
        ImageDB().getImageName(index);
    ref.read(editorChangeProvider.notifier).needUpdate();
  });
  return ImageDB()
      .getImageIndex(ref.read(nodeEditorTargetProvider).node.imageString);
});

final editorChangeProvider = StateNotifierProvider<EditorChangeNotifier, bool>(
    (ref) => EditorChangeNotifier(ref));

class EditorChangeNotifier extends StateNotifier<bool> {
  Ref ref;

  EditorChangeNotifier(this.ref) : super(false);

  void needUpdate() {
    state = true;
  }

  void update() {
    state = false;
  }

  void save() {
    var pos = ref.read(nodeEditorTargetPosProvider)!;
    var origin = getPlatform.getChoiceNode(pos)!;
    var changed = ref.read(nodeEditorTargetProvider).node;
    origin.title = changed.title;
    origin.contentsString = changed.contentsOriginalString;
    origin.maximumStatus = changed.maximumStatus;
    origin.choiceNodeMode = changed.choiceNodeMode;
    origin.imageString = changed.imageString;
    origin.recursiveStatus = changed.recursiveStatus;
    origin.choiceNodeOption = ref.read(nodeEditorDesignProvider);
    ref.read(draggableNestedMapChangedProvider.notifier).state = true;
    state = false;
    refreshLine(ref, pos.first);
  }
}

final lastImageProvider = StateProvider<Uint8List?>((ref) => null);

final editorImageDragDropColorProvider =
    StateProvider.autoDispose<Color>((ref) => Colors.black12);

final textColorProvider = StateProvider<Color>((ref) {
  return Colors.black;
});