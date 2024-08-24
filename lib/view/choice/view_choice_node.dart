import 'dart:convert';
import 'dart:typed_data';

import 'package:context_menus/context_menus.dart';
import 'package:cyoap_core/choiceNode/choice_node.dart';
import 'package:cyoap_core/choiceNode/pos.dart';
import 'package:cyoap_core/preset/node_preset.dart';
import 'package:cyoap_flutter/i18n.dart';
import 'package:cyoap_flutter/util/color_helper.dart';
import 'package:cyoap_flutter/view/choice/view_choice_node_dialog.dart';
import 'package:cyoap_flutter/view/choice/view_wrap_custom.dart';
import 'package:cyoap_flutter/view/util/view_image_loading.dart';
import 'package:cyoap_flutter/viewModel/choice/vm_choice_node.dart';
import 'package:cyoap_flutter/viewModel/edit/vm_editor.dart'
    show nodeEditorTargetPosProvider;
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:super_drag_and_drop/super_drag_and_drop.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../main.dart';
import '../../model/platform_system.dart';
import '../../viewModel/choice/vm_choice.dart';
import '../../viewModel/edit/preset/vm_choice_node_preset.dart';
import '../../viewModel/edit/vm_make_platform.dart';
import '../../viewModel/vm_variable_table.dart';
import '../util/SliderThumbStyle.dart';
import '../util/view_outline_overlay.dart';

enum ChoiceNodeChildRender {
  noOption,
  /*default option*/
  onlySelf,
  selected,
  noOptionWithViewOnly
}

class NodeDraggable extends ConsumerWidget {
  final Pos pos;
  final ChoiceNodeChildRender ignoreOption;

  const NodeDraggable(this.pos,
      {this.ignoreOption = ChoiceNodeChildRender.noOption, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var node = ref.watch(choiceStatusProvider(pos)).asChoiceNode();
    if (node == null) {
      return const SizedBox.shrink();
    }
    var subWidget = ViewChoiceNode(pos, ignoreOption: ignoreOption);
    return DragItemWidget(
      dragItemProvider: (DragItemRequest request) =>
          DragItem(localData: Int32List.fromList(pos.data)),
      allowedOperations: () => [DropOperation.copy],
      child: DraggableWidget(
        child: subWidget,
      ),
    );
  }
}

class ViewChoiceNode extends ConsumerWidget {
  final Pos pos;
  final bool ignoreOpacity;
  final ChoiceNodeChildRender ignoreOption;

  const ViewChoiceNode(this.pos,
      {this.ignoreOpacity = false,
      this.ignoreOption = ChoiceNodeChildRender.noOption,
      super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (ignoreOpacity) {
      return ViewChoiceNodeMain(pos, ignoreOption: ignoreOption);
    }

    if (ref.watch(isEditableProvider(pos: pos)) &&
        ignoreOption == ChoiceNodeChildRender.noOption) {
      var popupList = [
        (
          'modify_size'.i18n,
          () {
            showDialog(
              context: context,
              builder: (builder) => SizeDialog(pos),
            );
          }
        ),
        (
          'modify_preset'.i18n,
          () {
            showDialog(
              context: context,
              builder: (builder) => PresetDialog(pos),
            );
          }
        ),
        (
          'copy'.i18n,
          () {
            ref.read(choiceStatusProvider(pos)).copyData();
          }
        ),
        (
          'delete'.i18n,
          () {
            ref.read(choiceStatusProvider(pos)).removeData();
          }
        ),
      ];
      if (ConstList.isMobile()) {
        return Opacity(
          opacity: ref.watch(opacityProvider(pos)),
          child: Stack(
            children: [
              ViewChoiceNodeMain(pos, ignoreOption: ignoreOption),
              Align(
                alignment: Alignment.topRight,
                child: CircleAvatar(
                  radius: 16,
                  child: PopupMenuButton<int>(
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.more_vert),
                    popUpAnimationStyle:
                        AnimationStyle(duration: ConstList.durationAnimation),
                    onSelected: (result) {
                      popupList[result].$2();
                    },
                    itemBuilder: (context) {
                      return List.generate(
                          popupList.length,
                          (index) => PopupMenuItem(
                                value: index,
                                child: Text(popupList[index].$1),
                              ));
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      }
      return Opacity(
        opacity: ref.watch(opacityProvider(pos)),
        child: ContextMenuRegion(
          contextMenu: GenericContextMenu(
            buttonConfigs: List.generate(
              popupList.length,
              (index) => ContextMenuButtonConfig(
                popupList[index].$1,
                onPressed: popupList[index].$2,
              ),
            ),
          ),
          isEnabled: !ConstList.isMobile(),
          child: ViewChoiceNodeMain(pos, ignoreOption: ignoreOption),
        ),
      );
    }
    return Opacity(
      opacity: ref.watch(opacityProvider(pos)),
      child: ViewChoiceNodeMain(pos, ignoreOption: ignoreOption),
    );
  }
}

class ViewChoiceNodeMain extends ConsumerWidget {
  final Pos pos;
  final bool ignoreChild;
  final ChoiceNodeChildRender ignoreOption;

  const ViewChoiceNodeMain(this.pos,
      {this.ignoreChild = false, required this.ignoreOption, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var node = ref.watch(choiceStatusProvider(pos)).asChoiceNode()!;
    var design = ref.watch(choiceNodeDesignSettingProvider(pos: pos));
    var preset = ref.watch(choiceNodePresetProvider(design.presetName));
    var isSelected = node.select > 0;
    var defaultColor = isSelected && preset.selectColorEnable!
        ? preset.selectColorOption!
        : preset.defaultColorOption!;
    var outline = isSelected && preset.selectOutlineEnable!
        ? preset.selectOutlineOption!
        : preset.defaultOutlineOption!;

    var borderRadius = BorderRadius.only(
      topLeft: Radius.circular(preset.round!.topLeft),
      topRight: Radius.circular(preset.round!.topRight),
      bottomRight: Radius.circular(preset.round!.bottomRight),
      bottomLeft: Radius.circular(preset.round!.bottomLeft),
    );

    var shape = RoundedRectangleBorder(
      borderRadius: borderRadius,
      side: const BorderSide(width: 0, style: BorderStyle.none),
    );

    var innerWidget = Card(
      shape: shape,
      clipBehavior: Clip.antiAlias,
      elevation: preset.elevation,
      color: Colors.transparent,
      margin: EdgeInsets.zero,
      child: Ink(
        decoration: BoxDecoration(
          color: defaultColor.getColor(),
          gradient: defaultColor.getGradient(),
          borderRadius: borderRadius,
        ),
        child: InkWell(
          onDoubleTap: ref.watch(isEditableProvider(pos: pos))
              ? () {
                  ref.read(nodeEditorTargetPosProvider.notifier).state =
                      node.pos;
                  ref
                      .read(changeTabProvider.notifier)
                      .changePageString("viewEditor", context);
                }
              : null,
          onTap: !ref.watch(isEditableProvider(pos: pos))
              ? () {
                  ref.read(choiceStatusProvider(pos).notifier).select(0);
                }
              : null,
          child: ViewChoiceNodeContent(pos,
              ignoreOption: ignoreOption, ignoreChild: ignoreChild),
        ),
      ),
    );

    var outlineEdgeInsets = EdgeInsets.only(
        top: outline.distance.top,
        right: outline.distance.right,
        bottom: outline.distance.bottom,
        left: outline.distance.left);
    var outlineRound = BorderRadius.only(
        topLeft: Radius.circular(outline.round.topLeft),
        topRight: Radius.circular(outline.round.topRight),
        bottomLeft: Radius.circular(outline.round.bottomLeft),
        bottomRight: Radius.circular(outline.round.bottomRight));

    return OutlineOverlay(
      edgeInsets: outlineEdgeInsets,
      borderRadius: outlineRound,
      outlineType: outline.outlineType,
      color: outline.outlineColor.getColorIgnoreGradient(),
      strokeWidth: outline.outlineWidth,
      child: Padding(
        padding: EdgeInsets.only(
            top: preset.padding!.top,
            right: preset.padding!.right,
            bottom: preset.padding!.bottom,
            left: preset.padding!.left),
        child: innerWidget,
      ),
    );
  }
}

class ViewTitleWithEdit extends ConsumerWidget {
  final Pos pos;

  const ViewTitleWithEdit(this.pos, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var design = ref.watch(choiceNodeDesignSettingProvider(pos: pos));
    var preset = ref.watch(choiceNodePresetProvider(design.presetName));
    if (!preset.hideTitle!) {
      return Center(
          child: Text(
        ref.watch(titleStringProvider(pos)),
        style: ConstList.getFont(preset.titleFont!).copyWith(
          fontSize: 20 * ConstList.scale(context),
          color: Color(preset.colorTitle!),
        ),
      ));
    } else {
      return const SizedBox.shrink();
    }
  }
}

class ViewChoiceNodeMultiSelect extends ConsumerWidget {
  final Pos pos;

  const ViewChoiceNodeMultiSelect(this.pos, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var design = ref.watch(choiceNodeDesignSettingProvider(pos: pos));
    var preset = ref.watch(choiceNodePresetProvider(design.presetName));
    int select = ref.watch(choiceStatusProvider(pos)).asChoiceNode()!.select;
    if (design.showAsSlider) {
      return SizedBox(
        height: 36,
        child: SliderTheme(
          data: Theme.of(context).sliderTheme.copyWith(
                thumbShape: preset.sliderOption?.sliderThumbShape ==
                        SliderThumbShape.circle
                    ? null
                    : const RoundedRectangleSliderShape(
                        thumbRadius: 10, cornerRadius: 2),
              ),
          child: Slider(
            value: select.toDouble(),
            min: 0,
            max: ref
                .watch(choiceStatusProvider(pos).notifier)
                .maxSelect()
                .toDouble(),
            label: select.toString(),
            thumbColor: preset.sliderOption!.sliderThumbColor.getColor(),
            activeColor: preset.sliderOption!.sliderTrackActiveColor.getColor(),
            inactiveColor:
                preset.sliderOption!.sliderTrackInactiveColor.getColor(),
            onChanged: (value) {
              var valueInt = value.toInt();
              if (!ref.watch(isEditableProvider(pos: pos)) &&
                  valueInt != select) {
                ref.read(choiceStatusProvider(pos).notifier).select(valueInt);
              }
            },
          ),
        ),
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(5),
            ),
            child: const Icon(
              Icons.chevron_left,
              size: 16,
              color: Colors.black,
            ),
          ),
          onTap: () {
            if (!ref.watch(isEditableProvider(pos: pos))) {
              ref.read(choiceStatusProvider(pos).notifier).select(select - 1);
            }
          },
        ),
        Expanded(
          child: Text(
            select.toString(),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.black,
                ),
            textAlign: TextAlign.center,
          ),
        ),
        InkWell(
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(5),
            ),
            child: const Icon(
              Icons.chevron_right,
              size: 16,
              color: Colors.black,
            ),
          ),
          onTap: () {
            if (!ref.watch(isEditableProvider(pos: pos))) {
              ref.read(choiceStatusProvider(pos).notifier).select(select + 1);
            }
          },
        )
      ],
    );
  }
}

class ViewContents extends ConsumerStatefulWidget {
  final Pos pos;

  const ViewContents(
    this.pos, {
    super.key,
  });

  @override
  ConsumerState createState() => _ViewContentsState();
}

class _ViewContentsState extends ConsumerState<ViewContents> {
  FocusNode? _focusNode;
  ScrollController? _scrollController;
  QuillController? _controller;

  @override
  void initState() {
    _focusNode = FocusNode();
    _scrollController = ScrollController();
    _controller = QuillController(
      configurations: const QuillControllerConfigurations(),
      document: Document(),
      selection: const TextSelection.collapsed(offset: 0),
      readOnly: true,
    );
    super.initState();
  }

  @override
  void dispose() {
    _focusNode?.dispose();
    _scrollController?.dispose();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var json = ref.watch(contentsQuillProvider(pos: widget.pos));
    if (json == null) {
      return const SizedBox.shrink();
    }
    _controller!.setContents(Delta.fromJson(jsonDecode(json)));
    var design = ref.watch(choiceNodeDesignSettingProvider(pos: widget.pos));
    var preset = ref.watch(choiceNodePresetProvider(design.presetName));
    return QuillEditor(
      controller: _controller!,
      configurations: QuillEditorConfigurations(
        autoFocus: false,
        expands: false,
        padding: const EdgeInsets.symmetric(vertical: 4),
        showCursor: false,
        scrollable: false,
        enableInteractiveSelection: false,
        customStyles: ConstList.getDefaultThemeData(
            context, ConstList.scale(context),
            fontStyle: ConstList.getFontWithColor(preset.mainFont!)),
      ),
      focusNode: _focusNode!,
      scrollController: _scrollController!,
    );
  }
}

class ViewChoiceNodeContent extends ConsumerWidget {
  final Pos pos;
  final bool ignoreChild;
  final ChoiceNodeChildRender ignoreOption;

  const ViewChoiceNodeContent(this.pos,
      {this.ignoreChild = false, required this.ignoreOption, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var node = ref.watch(choiceStatusProvider(pos)).asChoiceNode() ??
        ChoiceNode.empty();
    var design = ref.watch(choiceNodeDesignSettingProvider(pos: pos));
    var preset = ref.watch(choiceNodePresetProvider(design.presetName));
    Widget image;
    if (ref.watch(imageStringProvider(pos: pos)).isNotEmpty) {
      image = ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: preset.maximizingImage!
              ? MediaQuery.of(context).size.height / 1.25
              : MediaQuery.of(context).size.height / 2,
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          child: ViewImageLoading(ref.watch(imageStringProvider(pos: pos))),
        ),
      );
    } else {
      image = const SizedBox.shrink();
    }

    Widget? child;
    if (ref.watch(isEditableProvider(pos: pos)) &&
        ignoreOption == ChoiceNodeChildRender.noOption) {
      child = ViewWrapCustomReorder(
        pos,
        isReorderAble:
            ignoreOption != ChoiceNodeChildRender.noOptionWithViewOnly,
        parentMaxSize: node.getMaxSize(true),
      );
    } else if (!ignoreChild &&
        node.children.isNotEmpty &&
        ignoreOption != ChoiceNodeChildRender.onlySelf) {
      child = ViewWrapCustomReorder(
        pos,
        isReorderAble: false,
        parentMaxSize: node.getMaxSize(true),
        builder: (i) {
          if (ignoreOption == ChoiceNodeChildRender.selected &&
              !getPlatform.checkIsSelected(
                  node.children[i] as ChoiceNode, true)) {
            return const SizedBox.shrink();
          }
          return ViewChoiceNode(
            pos.addLast(i),
            ignoreOption: ignoreOption,
          );
        },
      );
    }
    child ??= const SizedBox.shrink();

    if (preset.imagePosition == 1) {
      return Column(
        children: [
          ViewTitleWithEdit(pos),
          Row(
            children: [
              Flexible(
                child: ViewContents(pos),
              ),
              Expanded(child: image),
            ],
          ),
          if (node.choiceNodeMode == ChoiceNodeMode.multiSelect)
            ViewChoiceNodeMultiSelect(pos),
          child,
        ],
      );
    }
    if (preset.imagePosition == 2) {
      return Column(
        children: [
          ViewTitleWithEdit(pos),
          Row(
            children: [
              Expanded(child: image),
              Flexible(
                child: ViewContents(pos),
              ),
            ],
          ),
          if (node.choiceNodeMode == ChoiceNodeMode.multiSelect)
            ViewChoiceNodeMultiSelect(pos),
          child,
        ],
      );
    }
    List<Widget> subWidget = preset.titlePosition!
        ? [
            ViewTitleWithEdit(pos),
            image,
          ]
        : [
            image,
            ViewTitleWithEdit(pos),
          ];

    subWidget.addAll([
      ViewContents(pos),
      if (node.choiceNodeMode == ChoiceNodeMode.multiSelect)
        ViewChoiceNodeMultiSelect(pos),
      child,
    ]);

    if (!ref.watch(isEditableProvider(pos: pos)) &&
        getPlatformFileSystem
            .hasSource(ref.watch(imageStringProvider(pos: pos))) &&
        ref.watch(isVisibleSourceProvider)) {
      subWidget.add(
        TextButton(
          child: Text(
            'source'.i18n,
            style: const TextStyle(
                color: Colors.blue, fontWeight: FontWeight.w800),
          ),
          onPressed: () {
            var url = getPlatformFileSystem
                .getSource(ref.watch(imageStringProvider(pos: pos)));
            if (url != null && url.isNotEmpty) {
              launchUrlString(url);
            }
          },
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: subWidget,
    );
  }
}
