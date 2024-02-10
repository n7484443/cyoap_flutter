import 'dart:convert';
import 'dart:math';

import 'package:cyoap_core/choiceNode/choice_node.dart';
import 'package:cyoap_core/choiceNode/pos.dart';
import 'package:cyoap_core/playable_platform.dart';
import 'package:cyoap_core/preset/node_preset.dart';
import 'package:cyoap_flutter/i18n.dart';
import 'package:cyoap_flutter/util/color_helper.dart';
import 'package:cyoap_flutter/view/util/controller_adjustable_scroll.dart';
import 'package:cyoap_flutter/view/util/view_image_loading.dart';
import 'package:cyoap_flutter/view/util/view_wrap_custom.dart';
import 'package:cyoap_flutter/viewModel/choice/vm_choice_node.dart';
import 'package:cyoap_flutter/viewModel/vm_draggable_nested_map.dart';
import 'package:cyoap_flutter/viewModel/vm_editor.dart'
    show nodeEditorTargetPosProvider;
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../main.dart';
import '../../model/platform_system.dart';
import '../../viewModel/choice/vm_choice.dart';
import '../../viewModel/preset/vm_choice_node_preset.dart';
import '../../viewModel/vm_global_setting.dart';
import '../../viewModel/vm_make_platform.dart';
import '../../viewModel/vm_variable_table.dart';

class ViewChoiceNode extends ConsumerWidget {
  final Pos pos;
  final bool ignoreOpacity;
  final bool ignoreChild;
  final bool ignoreOption;

  const ViewChoiceNode(this.pos,
      {this.ignoreOpacity = false,
      this.ignoreChild = false,
      this.ignoreOption = false,
      super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (pos.last == nonPositioned) {
      var presetName =
          ref.watch(choiceNodeDesignSettingProvider(pos: pos)).presetName;
      return Card(
        color: ref
            .watch(choiceNodePresetProvider(presetName))
            .defaultColorOption
            .getColor(),
        child: SizedBox(
          width: MediaQuery.of(context).size.width /
              defaultMaxSize *
              3 *
              ConstList.scale(context),
          height: nodeBaseHeight * ConstList.scale(context),
        ),
      );
    }
    if (ignoreOpacity) {
      return ViewChoiceNodeMain(pos,
          ignoreChild: ignoreChild, ignoreOption: ignoreOption);
    }
    return Opacity(
      opacity: ref.watch(opacityProvider(pos)),
      child: ViewChoiceNodeMain(pos,
          ignoreChild: ignoreChild, ignoreOption: ignoreOption),
    );
  }
}

class ViewChoiceNodeMain extends ConsumerWidget {
  final Pos pos;
  final bool ignoreChild;
  final bool ignoreOption;

  const ViewChoiceNodeMain(this.pos,
      {this.ignoreChild = false, this.ignoreOption = false, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var node = ref.watch(choiceStatusProvider(pos)).asChoiceNode()!;
    var design = ref.watch(choiceNodeDesignSettingProvider(pos: pos));
    var preset = ref.watch(choiceNodePresetProvider(design.presetName));
    var isSelected = node.select > 0;
    var defaultColor = isSelected && preset.selectColorEnable
        ? preset.selectColorOption
        : preset.defaultColorOption;
    var outline = isSelected && preset.selectOutlineEnable
        ? preset.selectOutlineOption
        : preset.defaultOutlineOption;
    var innerWidget = Ink(
      decoration: BoxDecoration(
        color: defaultColor.getColor(),
        gradient: defaultColor.getGradient(),
        borderRadius: BorderRadius.circular(max(preset.round, 0)),
      ),
      child: InkWell(
        onDoubleTap: ref.watch(isEditableProvider(pos: pos))
            ? () {
                ref.read(nodeEditorTargetPosProvider.notifier).state = node.pos;
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
        child: Padding(
          padding: EdgeInsets.all(preset.padding),
          child: Stack(children: [
            ViewChoiceNodeContent(pos, ignoreChild: ignoreChild),
            if (ref.watch(isEditableProvider(pos: pos)) && !ignoreOption)
              Align(
                alignment: Alignment.topRight,
                child: CircleAvatar(
                  radius: 16,
                  child: PopupMenuButton<int>(
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.more_vert),
                    onSelected: (result) {
                      switch (result) {
                        case 0:
                          showDialog(
                            context: context,
                            builder: (builder) => SizeDialog(pos),
                          );
                          break;
                        case 1:
                          ref.read(choiceStatusProvider(pos)).copyData();
                          break;
                        case 2:
                          ref.read(choiceStatusProvider(pos)).removeData();
                          break;
                      }
                    },
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                          value: 0,
                          child: Text('modify_size'.i18n),
                        ),
                        PopupMenuItem(
                          value: 1,
                          child: Text('copy'.i18n),
                        ),
                        PopupMenuItem(
                          value: 2,
                          child: Text('delete'.i18n),
                        ),
                      ];
                    },
                  ),
                ),
              ),
          ]),
        ),
      ),
    );

    var shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(preset.round),
      side: const BorderSide(width: 0, style: BorderStyle.none),
    );
    if (outline.outlineType == OutlineType.dotted ||
        outline.outlineType == OutlineType.dashed) {
      return DottedBorder(
        borderType: BorderType.RRect,
        strokeWidth: outline.outlineWidth,
        dashPattern:
            outline.outlineType == OutlineType.dashed ? [6, 2] : [3, 1],
        radius: Radius.circular(preset.round),
        color: outline.outlineColor.getColorIgnoreGradient(),
        padding: EdgeInsets.all(outline.outlinePadding),
        child: Card(
          shape: shape,
          clipBehavior: Clip.none,
          elevation: preset.elevation,
          color: Colors.transparent,
          margin: EdgeInsets.zero,
          child: innerWidget,
        ),
      );
    }

    if (outline.outlineType == OutlineType.solid) {
      return DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(preset.round),
          border: Border.all(
            color: outline.outlineColor.getColorIgnoreGradient(),
            width: outline.outlineWidth,
          ),
        ),
        child: Card(
          elevation: preset.elevation,
          margin: EdgeInsets.all(outline.outlinePadding),
          clipBehavior: Clip.antiAlias,
          shape: shape,
          color: Colors.transparent,
          child: innerWidget,
        ),
      );
    }

    return Card(
      shape: shape,
      clipBehavior: Clip.antiAlias,
      elevation: preset.elevation,
      color: Colors.transparent,
      child: innerWidget,
    );
  }
}

class SizeDialog extends ConsumerWidget {
  final Pos pos;

  const SizeDialog(this.pos, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var width = ref.watch(choiceNodeSizeProvider(pos));
    var str = width == 0 ? 'max' : width.toString();
    return AlertDialog(
      scrollable: true,
      alignment: Alignment.center,
      title: Text('modify_size'.i18n, textAlign: TextAlign.center),
      content: SizedBox(
        width: 400,
        height: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${'length'.i18n} : $str',
                style: Theme.of(context).textTheme.titleMedium),
            Slider(
              onChanged: (double value) {
                ref
                    .read(choiceNodeSizeProvider(pos).notifier)
                    .sizeChange(value.toInt());
              },
              value: width.toDouble(),
              divisions: defaultMaxSize,
              max: defaultMaxSize.toDouble(),
              min: 0,
              label: str,
            ),
          ],
        ),
      ),
    );
  }
}

class NodeDraggable extends ConsumerWidget {
  final Pos pos;

  const NodeDraggable(this.pos, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var node = ref.watch(choiceStatusProvider(pos)).asChoiceNode();
    if (node == null) {
      return const SizedBox.shrink();
    }
    var widget = ViewChoiceNode(pos);
    if (ConstList.isMobile()) {
      return LongPressDraggable<Pos>(
        onDragUpdate: (details) => ref
            .read(dragPositionProvider.notifier)
            .state = details.localPosition.dy,
        data: pos,
        feedback: Opacity(
          opacity: 0.5,
          child: SizedBox(
              width: MediaQuery.of(context).size.width /
                  (defaultMaxSize + 3) *
                  (node.width == 0 ? defaultMaxSize : node.width),
              child: widget),
        ),
        onDragStarted: () {
          ref.read(dragChoiceNodeStatusProvider.notifier).dragStart(pos);
        },
        child: ref.watch(dragChoiceNodeStatusProvider) == pos
            ? Opacity(
                opacity: 0.2,
                child: widget,
              )
            : widget,
        onDraggableCanceled: (Velocity velocity, Offset offset) {
          ref.read(dragChoiceNodeStatusProvider.notifier).dragEnd();
        },
      );
    } else {
      return Draggable<Pos>(
        onDragUpdate: (details) => ref
            .read(dragPositionProvider.notifier)
            .state = details.localPosition.dy,
        data: pos,
        feedback: Opacity(
          opacity: 0.5,
          child: SizedBox(
              width: MediaQuery.of(context).size.width /
                  (defaultMaxSize + 3) *
                  (node.width == 0 ? defaultMaxSize : node.width),
              child: widget),
        ),
        onDragStarted: () {
          ref.read(dragChoiceNodeStatusProvider.notifier).dragStart(pos);
        },
        child: Opacity(
          opacity: ref.watch(dragChoiceNodeStatusProvider) == pos ? 0.2 : 1.0,
          child: widget,
        ),
        onDraggableCanceled: (Velocity velocity, Offset offset) {
          ref.read(dragChoiceNodeStatusProvider.notifier).dragEnd();
        },
      );
    }
  }
}

class ViewTitleWithEdit extends ConsumerWidget {
  final Pos pos;

  const ViewTitleWithEdit(this.pos, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var design = ref.watch(choiceNodeDesignSettingProvider(pos: pos));
    var preset = ref.watch(choiceNodePresetProvider(design.presetName));
    if (!preset.hideTitle) {
      return Center(
          child: Text(
        ref.watch(titleStringProvider(pos)),
        style: ConstList.getFont(preset.titleFont).copyWith(
          fontSize: 20 * ConstList.scale(context),
          color: Color(preset.colorTitle),
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
    int select = ref.watch(choiceStatusProvider(pos)).asChoiceNode()!.select;
    if (design.showAsSlider) {
      return Slider(
        value: select.toDouble(),
        min: 0,
        max: ref
            .watch(choiceStatusProvider(pos).notifier)
            .maxSelect()
            .toDouble(),
        label: select.toString(),
        onChanged: (value) {
          var valueInt = value.toInt();
          if (!ref.watch(isEditableProvider(pos: pos)) && valueInt != select) {
            int t = valueInt - select;
            ref.read(choiceStatusProvider(pos).notifier).select(t);
          }
        },
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          child: Container(
            width: 64,
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
              ref.read(choiceStatusProvider(pos).notifier).select(-1);
            }
          },
        ),
        Text(
          select.toString(),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.black,
              ),
          textAlign: TextAlign.center,
        ),
        InkWell(
          child: Container(
            width: 64,
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
              ref.read(choiceStatusProvider(pos).notifier).select(1);
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
    _scrollController = AdjustableScrollController();
    _controller = QuillController.basic();
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
      configurations: QuillEditorConfigurations(
        controller: _controller!,
        readOnly: true,
        autoFocus: false,
        expands: false,
        padding: const EdgeInsets.symmetric(vertical: 4),
        showCursor: false,
        scrollable: false,
        enableInteractiveSelection: false,
        customStyles: ConstList.getDefaultThemeData(
            context, ConstList.scale(context),
            fontStyle: ConstList.getFontWithColor(preset.mainFont)),
      ),
      focusNode: _focusNode!,
      scrollController: _scrollController!,
    );
  }
}

class ViewChoiceNodeContent extends ConsumerWidget {
  final Pos pos;
  final bool ignoreChild;

  const ViewChoiceNodeContent(this.pos, {this.ignoreChild = false, super.key});

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
          maxHeight: preset.maximizingImage
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
    if (pos.isValid) {
      if (ref.watch(isEditableProvider(pos: pos))) {
        child = ViewWrapCustomReorder(
          pos,
          maxSize: min(ref.watch(maximumSizeProvider), node.getMaxSize(true)),
        );
      } else if (!ignoreChild) {
        child = ViewWrapCustom(
          pos,
          (i) => ViewChoiceNode(pos.addLast(i)),
          maxSize: min(ref.watch(maximumSizeProvider), node.getMaxSize(true)),
        );
      }
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
    List<Widget> subWidget = preset.titlePosition
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