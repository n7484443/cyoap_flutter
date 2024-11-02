import 'package:cyoap_core/choiceNode/choice_line.dart';
import 'package:cyoap_core/choiceNode/pos.dart';
import 'package:cyoap_core/preset/line_preset.dart';
import 'package:cyoap_flutter/viewModel/choice/vm_choice.dart';
import 'package:cyoap_flutter/viewModel/edit/preset/vm_choice_line_preset.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../model/platform_system.dart';

part 'vm_choice_line.g.dart';

@riverpod
ChoiceLineDesignPreset lineDesignPreset(Ref ref, {required Pos pos}) {
  var line = ref.watch(choiceStatusProvider(pos)).asChoiceLine();
  var presetName = line?.choiceLineOption.presetName;
  return ref.watch(choiceLinePresetProvider(presetName!));
}

@riverpod
class LineOption extends _$LineOption {
  @override
  ChoiceLineOption build({required Pos pos}) {
    return ref.watch(choiceStatusProvider(pos)).asChoiceLine()?.choiceLineOption ?? const ChoiceLineOption();
  }

  void setValue(ChoiceLineOption value) {
    getPlatform.getChoiceLine(pos)?.choiceLineOption = value;
    state = value;
    ref.read(choiceStatusProvider(pos)).refreshSelf();
  }

  void setName(String name) {
    setValue(state.copyWith(name: name));
  }
}

@riverpod
class LineFold extends _$LineFold {
  @override
  bool build({required Pos pos}) {
    return false;
  }

  void reverse() {
    state = !state;
  }
}

final isEditableStateProvider = StateProvider.autoDispose.family<bool, Pos>((ref, pos) {
  return true;
});
