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
import '../../util/platform_specified_util/platform_specified.dart';
import '../code/vm_ide.dart';

part 'vm_editor.g.dart';

final editEndProvider = StateProvider.family<bool, ChoiceType>((ref, choiceType) {
  ref.listenSelf((previous, next) {
    if (next) {
      ref.read(currentProjectChangedProvider.notifier).changed(needUpdateCode: true);
      Pos? pos;
      if (choiceType == ChoiceType.node) {
        pos = ref.read(nodeEditorTargetPosProvider);
      } else if (choiceType == ChoiceType.line) {
        pos = ref.read(lineEditorTargetPosProvider);
      }
      ref.read(choiceStatusProvider(pos!)).refreshParent();
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
    ref.notifyListeners();
  }

  void setChoiceNodeOption(ChoiceNodeOption option) {
    setState((node) {
      node.choiceNodeOption = option;
      return node;
    });
  }

  void setChoiceMode(ChoiceNodeMode option) {
    setState((node) {
      node.choiceNodeMode = option;
      if (option == ChoiceNodeMode.onlyCode) {
        node.conditionalCodeHandler.conditionClickableCode = [];
        node.conditionalCodeHandler.conditionVisibleCode = [];
        node.conditionalCodeHandler.conditionClickableString = null;
        node.conditionalCodeHandler.conditionVisibleString = null;
      }
      return node;
    });
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

final nodeEditorDesignProvider = Provider<ChoiceNodeOption>((ref) {
  return ref.watch(nodeEditorTargetProvider).choiceNodeOption;
});

final nodeTitleProvider = StateProvider.autoDispose<String>((ref) => ref.watch(nodeEditorTargetProvider).title);

@riverpod
class ImageListState extends _$ImageListState {
  @override
  List<String> build() {
    return ImageDB().imageList;
  }

  Future<List<PlatformFile>?> addImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      withData: true,
      allowedExtensions: ['png', 'jpg', 'jpeg', 'gif', 'webp', 'bmp'],
      type: FileType.custom,
      allowMultiple: true,
      allowCompression: false,
    );
    return result?.files;
  }

  Future<void> addImageToList(String name, {Uint8List? data}) async {
    var before = data ?? ref.read(lastImageProvider)!;
    var out = await PlatformUtil().platform.webpConverter.convert(before, name);

    ImageDB().uploadImages(out.$1, out.$2);
    ref.read(imageStateProvider.notifier).setImageIndex(ImageDB().getImageIndex(out.$1));
    ref.read(currentProjectChangedProvider.notifier).changed(needUpdateCode: false);
    ref.read(lastImageProvider.notifier).update((state) => null);
    ref.invalidate(vmSourceProvider);
    state = [...ImageDB().imageList];
  }
}

final imageStateProvider = StateNotifierProvider<ImageStateNotifier, int>((ref) {
  var initialIndex = ImageDB().getImageIndex(ref.read(nodeEditorTargetProvider).imageString);
  return ImageStateNotifier(ref, initialIndex);
});

class ImageStateNotifier extends StateNotifier<int> {
  Ref ref;
  ImageStateNotifier(this.ref, int initIndex) : super(initIndex);

  void setImageIndex(int index) {
    ref.read(nodeEditorTargetProvider.notifier).setState((node) {
      node.imageString = ImageDB().getImageName(index);
      return node;
    });
    state = index;
  }
}

final lastImageProvider = StateProvider<Uint8List?>((ref) => null);

final editorImageDragDropColorProvider = StateProvider.autoDispose<bool>((ref) => false);

final textColorProvider = StateProvider<Color>((ref) {
  return Colors.black;
});

final shownImageNumProvider = StateProvider<int>((ref) {
  return ConstList.isMobile() ? 3 : 4;
});

@riverpod
bool isSimpleCodeEditor(Ref ref) {
  return ref.watch(nodeEditorTargetProvider).conditionalCodeHandler.isSimple;
}
