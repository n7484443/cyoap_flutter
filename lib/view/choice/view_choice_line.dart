import 'package:cyoap_core/choiceNode/pos.dart';
import 'package:cyoap_flutter/i18n.dart';
import 'package:cyoap_flutter/view/util/view_back_dialog.dart';
import 'package:cyoap_flutter/view/util/view_circle_button.dart';
import 'package:cyoap_flutter/view/util/view_wrap_custom.dart';
import 'package:cyoap_flutter/view/choice/view_choice_node.dart';
import 'package:cyoap_flutter/view/view_draggable_nested_map.dart';
import 'package:cyoap_flutter/viewModel/vm_global_setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../main.dart';
import '../../model/platform_system.dart';
import '../../viewModel/preset/vm_choice_line_preset.dart';
import '../../viewModel/choice/vm_choice.dart';
import '../../viewModel/choice/vm_choice_line.dart';
import '../../viewModel/vm_editor.dart';
import '../../viewModel/vm_make_platform.dart';

class ViewChoiceLine extends ConsumerWidget {
  final Pos pos;
  final bool isOutOfLength;

  const ViewChoiceLine(
      {super.key, required this.pos, required this.isOutOfLength});

  Color getColorLine(bool alwaysVisible) {
    if (pos.last < getPlatform.choicePage.choiceLines.length &&
        !alwaysVisible) {
      return Colors.blueAccent;
    }
    return Colors.white54;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (isOutOfLength) {
      return SliverToBoxAdapter(
        child: NodeDragTarget(
          pos.addLast(0),
          isHorizontal: true,
        ),
      );
    }
    if (ref.watch(lineFoldProvider(pos: pos))) {
      return const SliverToBoxAdapter(
        child: SizedBox(
          height: 4,
        ),
      );
    }
    if (getPlatformFileSystem.isEditable && ref.watch(isEditableProvider(pos: pos))) {
      return ViewWrapCustomReorder(
        pos,
        isInner: false,
        maxSize: ref.watch(maximumSizeProvider),
      );
    }
    return ViewWrapCustom(
      pos,
      (index) {
        return ViewChoiceNode(pos.addLast(index));
      },
      isInner: false,
      maxSize: ref.watch(maximumSizeProvider),
    );
  }
}

class ViewChoiceLineHeader extends ConsumerWidget {
  final Pos pos;
  final bool isOutOfLength;

  const ViewChoiceLineHeader(
      {super.key, required this.pos, required this.isOutOfLength});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (isOutOfLength) {
      return const Divider(
        thickness: 4,
        color: Colors.white54,
      );
    }
    var lineOption = ref.watch(lineOptionProvider(pos: pos));
    var preset = ref.watch(lineDesignPresetProvider(pos: pos));
    if (!preset.alwaysVisibleLine && !isPlatformEditable) {
      return const SizedBox.shrink();
    }
    if (isPlatformEditable) {
      return Stack(
        alignment: Alignment.center,
        children: [
          Divider(
            thickness: 4,
            color:
                preset.alwaysVisibleLine ? Colors.blueAccent : Colors.white54,
          ),
          Card(
            elevation: 0,
            color: ref.watch(themeStateProvider) == ThemeMode.light
                ? Colors.white70
                : Colors.black54,
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: Row(
                children: [
                  CircleButton(
                    onPressed: () {
                      ref.read(lineFoldProvider(pos: pos).notifier).reverse();
                    },
                    child: ref.watch(lineFoldProvider(pos: pos))
                        ? const Icon(
                            Icons.unfold_more,
                          )
                        : const Icon(
                            Icons.unfold_less,
                          ),
                  ),
                  const Spacer(),
                  if (lineOption.name != null && isPlatformEditable)
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        lineOption.name!,
                        style: ConstList.getFont("notoSans").copyWith(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  const Spacer(),
                  CircleButton(
                    onPressed: () {
                      ref
                          .read(isEditableStateProvider(pos).notifier)
                          .state = !ref.watch(isEditableStateProvider(pos));
                    },
                    child: ref.watch(isEditableStateProvider(pos))
                        ? const Icon(
                            Icons.visibility,
                          )
                        : const Icon(
                            Icons.edit,
                          ),
                  ),
                  const SizedBox.square(
                    dimension: 5,
                  ),
                  CircleButton(
                    onPressed: () {
                      if (pos.last - 1 >= 0) {
                        var upPos = pos.removeLast().addLast(pos.last - 1);
                        ref.read(choiceStatusProvider(pos)).swapChoice(upPos);
                      }
                    },
                    child: const Icon(
                      Icons.arrow_upward,
                    ),
                  ),
                  const SizedBox.square(
                    dimension: 5,
                  ),
                  CircleButton(
                    onPressed: () {
                      var downPos = pos.removeLast().addLast(pos.last + 1);
                      ref.read(choiceStatusProvider(pos)).swapChoice(downPos);
                    },
                    child: const Icon(
                      Icons.arrow_downward,
                    ),
                  ),
                  const SizedBox.square(
                    dimension: 5,
                  ),
                  CircleButton(
                    onPressed: () async {
                      var name = await showDialog<String>(
                          context: context,
                          builder: (_) => NodeDividerDialog(pos: pos),
                          barrierDismissible: false);
                      ref
                          .read(lineOptionProvider(pos: pos).notifier)
                          .setName(name ?? '');
                    },
                    child: const Icon(
                      Icons.settings,
                    ),
                  ),
                  CircleButton(
                    onPressed: () async {
                      await showDialog<bool?>(
                          context: context,
                          builder: (_) => ViewWarningDialog(
                                acceptFunction: () {
                                  ref
                                      .read(choiceStatusProvider(pos))
                                      .removeData();
                                },
                                cancelFunction: () {},
                                content: 'warning_message_line_delete'.i18n,
                              ),
                          barrierDismissible: false);
                    },
                    child: const Icon(
                      Icons.delete,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    } else {
      return Stack(
        alignment: Alignment.center,
        children: [
          Divider(
            thickness: 4,
            color:
                preset.alwaysVisibleLine ? Colors.blueAccent : Colors.white54,
          ),
          Visibility(
            visible: lineOption.maxSelect != -1,
            child: Text(
              'lineSetting_tooltip_1'.i18n.fill([lineOption.maxSelect]),
              style: ConstList.getFont("notoSans").copyWith(
                fontSize: 18.0,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );
    }
  }
}

class NodeDividerDialog extends ConsumerStatefulWidget {
  final Pos pos;

  const NodeDividerDialog({
    required this.pos,
    super.key,
  });

  @override
  ConsumerState createState() => _NodeDividerDialogState();
}

class _NodeDividerDialogState extends ConsumerState<NodeDividerDialog> {
  TextEditingController? _nameController;

  @override
  void initState() {
    _nameController = TextEditingController(
        text: ref.read(lineOptionProvider(pos: widget.pos)).name ??
            "ChoiceLine_${widget.pos.last}");
    super.initState();
  }

  @override
  void dispose() {
    _nameController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var lineOption = ref.watch(lineOptionProvider(pos: widget.pos));
    var maxSelectString =
        lineOption.maxSelect == -1 ? "max" : lineOption.maxSelect.toString();
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (ConstList.isMobile()) Text('lineSetting_tooltip_0'.i18n),
          if (ConstList.isMobile())
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () {
                    ref
                        .read(lineOptionProvider(pos: widget.pos).notifier)
                        .setValue(lineOption.copyWith(
                            maxSelect: lineOption.maxSelect >= 0
                                ? lineOption.maxSelect - 1
                                : lineOption.maxSelect));
                  },
                ),
                Text(maxSelectString),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () {
                    ref
                        .read(lineOptionProvider(pos: widget.pos).notifier)
                        .setValue(lineOption.copyWith(
                            maxSelect: lineOption.maxSelect + 1));
                  },
                ),
              ],
            ),
          if (!ConstList.isMobile())
            Row(
              children: [
                Text('lineSetting_tooltip_0'.i18n),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () {
                    ref
                        .read(lineOptionProvider(pos: widget.pos).notifier)
                        .setValue(lineOption.copyWith(
                            maxSelect: lineOption.maxSelect >= 0
                                ? lineOption.maxSelect - 1
                                : lineOption.maxSelect));
                  },
                ),
                Text(maxSelectString),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () {
                    ref
                        .read(lineOptionProvider(pos: widget.pos).notifier)
                        .setValue(lineOption.copyWith(
                            maxSelect: lineOption.maxSelect + 1));
                  },
                ),
              ],
            ),
          const SizedBox(height: ConstList.padding),
          DropdownButtonFormField<String>(
            decoration:
                InputDecoration(labelText: 'preset_setting_tooltip'.i18n),
            items: ref
                .watch(choiceLinePresetListProvider)
                .map<DropdownMenuItem<String>>(
                  (preset) => DropdownMenuItem(
                    value: preset.name,
                    child: Text(preset.name),
                  ),
                )
                .toList(),
            onChanged: (String? t) {
              if (t != null) {
                ref
                    .read(lineOptionProvider(pos: widget.pos).notifier)
                    .setValue(lineOption.copyWith(presetName: t));
              }
            },
            value: ref.watch(lineOptionProvider(pos: widget.pos)).presetName,
          ),
          const SizedBox(height: ConstList.padding),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(hintText: 'lineSetting_tooltip_2'.i18n),
          ),
          const SizedBox(height: ConstList.paddingHuge),
        ],
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        TextButton(
          onPressed: () {
            ref.read(lineEditorTargetPosProvider.notifier).state = widget.pos;
            Navigator.of(context).pop(_nameController!.text);
            ref
                .read(changeTabProvider.notifier)
                .changePageString("viewEditorLine", context);
          },
          child: Text("lineSetting_tooltip_3".i18n),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(_nameController!.text);
          },
          child: Text("confirm".i18n),
        ),
      ],
    );
  }
}
