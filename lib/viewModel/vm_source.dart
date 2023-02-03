import 'package:cyoap_flutter/model/image_db.dart';
import 'package:cyoap_flutter/viewModel/vm_choice_node.dart';
import 'package:cyoap_flutter/viewModel/vm_draggable_nested_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final deleteModeProvider = StateProvider.autoDispose<bool>((ref) => false);
final deleteImageListProvider =
    StateProvider.autoDispose<List<String>>((ref) => []);

final vmSourceProvider =
    StateNotifierProvider.autoDispose<VMSource, List<String>>(
        (ref) => VMSource(ref, List<String>.from(ImageDB().imageList)));

class VMSource extends StateNotifier<List<String>> {
  final Ref ref;

  VMSource(this.ref, super.state);

  void checkRemove(String name) {
    ref
        .read(deleteImageListProvider.notifier)
        .update((state) => [...state, name]);
  }

  void remove() {
    for (var name in ref.read(deleteImageListProvider)) {
      ImageDB().removeImage(name);
    }
    state = List<String>.from(ImageDB().imageList);
    updateImageAll(ref);
    ref.read(draggableNestedMapChangedProvider.notifier).state = true;
  }
}
