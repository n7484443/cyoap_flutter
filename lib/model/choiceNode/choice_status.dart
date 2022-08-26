import 'package:freezed_annotation/freezed_annotation.dart';

part 'choice_status.freezed.dart';

enum SelectableStatus {
  //isSelectable가 false 인 경우에는 selected와 hide 두가지로 사용
  selected, //선택된 상태
  hide, //숨긴 상태
  open, //선택 가능한 상태
  closed, //약간 흐릿하면서 선택 불가능한 상태
}

extension SelectableStatusExtension on SelectableStatus {}

@freezed
class ChoiceStatus with _$ChoiceStatus {
  factory ChoiceStatus({
    @Default(SelectableStatus.open) SelectableStatus status,
    @Default(true) bool visible,
  }) = _ChoiceStatus;

  ChoiceStatus._();

  bool isSelected() {
    return status == SelectableStatus.selected;
  }

  bool isHide() {
    return status == SelectableStatus.hide;
  }

  bool isOpen() {
    return status == SelectableStatus.open;
  }

  bool isPointerInteractive(bool isSelectable) {
    if (isSelectable) {
      return isSelected() || isOpen();
    }
    return false;
  }

  bool isNotSelected() {
    return !isSelected();
  }

  SelectableStatus reverseSelected(bool isSelectable) {
    if (!isSelected()) {
      return SelectableStatus.selected;
    }
    if (isSelectable) {
      return SelectableStatus.open;
    } else {
      return SelectableStatus.hide;
    }
  }
}
