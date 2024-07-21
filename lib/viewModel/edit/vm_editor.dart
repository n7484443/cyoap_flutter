import 'dart:typed_data';

import 'package:cyoap_core/choiceNode/choice_line.dart';
import 'package:cyoap_core/choiceNode/choice_node.dart';
import 'package:cyoap_core/choiceNode/pos.dart';
import 'package:cyoap_flutter/model/image_db.dart';
import 'package:cyoap_flutter/model/platform_system.dart';
import 'package:cyoap_flutter/viewModel/choice/vm_choice.dart';
import 'package:cyoap_flutter/viewModel/edit/vm_draggable_nested_map.dart';
import 'package:cyoap_flutter/viewModel/edit/vm_source.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../main.dart';
import '../../util/platform_specified_util/webp_converter.dart';

part 'vm_editor.g.dart';

final editEndProvider = StateProvider<bool>((ref) {
  ref.listenSelf((previous, next) {
    if (next) {
      ref.read(draggableNestedMapChangedProvider.notifier).state = true;
      var pos = (ref.read(nodeEditorTargetPosProvider) ??
          ref.read(lineEditorTargetPosProvider))!;
      ref.read(choiceStatusProvider(pos)).refreshParent();
    }
  });
  return false;
});

final nodeEditorTargetPosProvider = StateProvider<Pos?>((ref) {
  return null;
});

@riverpod
class NodeEditorTarget extends _$NodeEditorTarget {
  @override
  ChoiceNode build() {
    var pos = ref.watch(nodeEditorTargetPosProvider);
    if (pos == null) {
      return ChoiceNode.empty();
    }
    return getPlatform.getChoiceNode(pos)!;
  }

  void setState(ChoiceNode Function(ChoiceNode) func) {
    state = func(state);
  }
}

final lineEditorTargetPosProvider = StateProvider<Pos?>((ref) {
  return null;
});

@riverpod
class LineEditorTarget extends _$LineEditorTarget {
  @override
  ChoiceLine build() {
    var pos = ref.watch(lineEditorTargetPosProvider);
    if (pos == null) {
      return ChoiceLine();
    }
    return getPlatform.getChoice(pos) as ChoiceLine;
  }

  void setState(ChoiceLine Function(ChoiceLine) func) {
    state = func(state);
  }
}

final nodeEditorDesignProvider =
    StateProvider.autoDispose<ChoiceNodeOption>((ref) {
  ref.listenSelf((previous, ChoiceNodeOption next) {
    ref.read(nodeEditorTargetProvider.notifier).setState((node) {
      node.choiceNodeOption = next;
      return node;
    });
  });
  return ref.watch(nodeEditorTargetProvider).choiceNodeOption;
});

final nodeModeProvider = StateProvider.autoDispose<ChoiceNodeMode>((ref) {
  ref.listenSelf((previous, ChoiceNodeMode next) {
    ref.read(nodeEditorTargetProvider.notifier).setState((node) {
      node.choiceNodeMode = next;
      return node;
    });
    if (next == ChoiceNodeMode.onlyCode) {
      ref.read(nodeEditorTargetProvider.notifier).setState((node) {
        node.conditionalCodeHandler.conditionClickableCode = [];
        return node;
      });
      ref.read(nodeEditorTargetProvider.notifier).setState((node) {
        node.conditionalCodeHandler.conditionVisibleCode = [];
        return node;
      });
      ref.read(nodeEditorTargetProvider.notifier).setState((node) {
        node.conditionalCodeHandler.conditionClickableString = null;
        return node;
      });
      ref.read(nodeEditorTargetProvider.notifier).setState((node) {
        node.conditionalCodeHandler.conditionVisibleString = null;
        return node;
      });
    }
  });
  return ref.watch(nodeEditorTargetProvider).choiceNodeMode;
});
final nodeTitleProvider = StateProvider.autoDispose<String>(
    (ref) => ref.watch(nodeEditorTargetProvider).title);

@riverpod
TextEditingController maximum(MaximumRef ref) {
  var node = ref.watch(nodeEditorTargetProvider);
  var controller = TextEditingController(text: node.maximumStatus.toString());
  controller.addListener(() {
    ref.read(nodeEditorTargetProvider.notifier).setState((node) {
      node.maximumStatus = int.tryParse(controller.text) ?? 0;
      return node;
    });
  });
  ref.onDispose(() => controller.dispose());
  return controller;
}

@riverpod
class ImageListState extends _$ImageListState {
  @override
  List<String> build() {
    return ImageDB().imageList;
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
    }
    return name;
  }

  Future<void> addImageToList(String name, {Uint8List? data}) async {
    var before = data ?? ref.read(lastImageProvider)!;
    var out = await WebpConverter.instance!.convert(before, name);

    ImageDB().uploadImages(out.$1, out.$2);
    ref.read(imageStateProvider.notifier).state =
        ImageDB().getImageIndex(out.$1);
    ref.read(draggableNestedMapChangedProvider.notifier).state = true;
    ref.read(lastImageProvider.notifier).update((state) => null);
    ref.invalidate(vmSourceProvider);
    state = [...ImageDB().imageList];
  }
}

final imageStateProvider = StateProvider.autoDispose<int>((ref) {
  ref.listenSelf((previous, int index) {
    ref.read(nodeEditorTargetProvider.notifier).setState((node) {
      node.imageString = ImageDB().getImageName(index);
      return node;
    });
  });
  return ImageDB()
      .getImageIndex(ref.read(nodeEditorTargetProvider).imageString);
});

final lastImageProvider = StateProvider<Uint8List?>((ref) => null);

final editorImageDragDropColorProvider =
    StateProvider.autoDispose<Color>((ref) => Colors.black12);

final textColorProvider = StateProvider<Color>((ref) {
  return Colors.black;
});

final shownImageNumProvider = StateProvider<int>((ref) {
  return ConstList.isMobile() ? 3 : 4;
});
