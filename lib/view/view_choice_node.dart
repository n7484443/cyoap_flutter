import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:cyoap_flutter/model/choiceNode/choice_node.dart';
import 'package:cyoap_flutter/view/util/view_image_loading.dart';
import 'package:cyoap_flutter/view/util/view_text_outline.dart';
import 'package:cyoap_flutter/view/util/view_wrap_custom.dart';
import 'package:cyoap_flutter/view/view_draggable_nested_map.dart';
import 'package:cyoap_flutter/viewModel/vm_choice_node.dart';
import 'package:cyoap_flutter/viewModel/vm_design_setting.dart';
import 'package:cyoap_flutter/viewModel/vm_draggable_nested_map.dart';
import 'package:cyoap_flutter/viewModel/vm_editor.dart'
    show nodeEditorTargetPosProvider;
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../main.dart';
import '../model/choiceNode/pos.dart';
import '../model/platform_system.dart';
import '../viewModel/vm_make_platform.dart';
import '../viewModel/vm_variable_table.dart';

class ViewChoiceNode extends ConsumerWidget {
  final Pos pos;
  final bool ignoreOpacity;

  const ViewChoiceNode(this.pos, {this.ignoreOpacity = false, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (pos.last == nonPositioned) {
      return Card(
        color: ref.watch(colorNodeProvider),
        child: SizedBox(
          width: MediaQuery.of(context).size.width /
              defaultMaxSize *
              3 *
              ConstList.scale(context),
          height: nodeBaseHeight * ConstList.scale(context),
        ),
      );
    }
    if(ignoreOpacity){
      return ViewChoiceNodeMain(pos);
    }
    var opacity = ref.watch(opacityProvider(pos));
    if (opacity == 0) {
      if (ref.watch(isChoiceNodeIsOccupySpaceProvider(pos))) {
        return Opacity(
          opacity: opacity,
          child: ViewChoiceNodeMain(pos),
        );
      } else {
        return const SizedBox.shrink();
      }
    }
    return Opacity(
      opacity: opacity,
      child: ViewChoiceNodeMain(pos),
    );
  }
}

class ViewChoiceNodeMain extends ConsumerWidget {
  final Pos pos;

  const ViewChoiceNodeMain(this.pos, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var node = ref.watch(choiceNodeProvider(pos)).node!;
    return Card(
      shape: ref.watch(isChoiceNodeRoundProvider(pos))
          ? RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.0),
              side: BorderSide(
                color: ref.watch(nodeModeProvider(pos)) !=
                            ChoiceNodeMode.unSelectableMode &&
                        ref
                            .watch(choiceNodePlayStatusProvider(pos))
                            .isSelected()
                    ? ref.watch(colorOutlineProvider)
                    : ref.watch(colorNodeProvider),
                width: ConstList.isSmallDisplay(context) ? 2 : 4,
              ),
            )
          : Border.fromBorderSide(
              BorderSide(
                color: ref.watch(nodeModeProvider(pos)) !=
                            ChoiceNodeMode.unSelectableMode &&
                        ref
                            .watch(choiceNodePlayStatusProvider(pos))
                            .isSelected()
                    ? ref.watch(colorOutlineProvider)
                    : ref.watch(colorNodeProvider),
                width: ConstList.isSmallDisplay(context) ? 2 : 4,
              ),
            ),
      clipBehavior: Clip.antiAlias,
      margin:
          ConstList.isSmallDisplay(context) ? const EdgeInsets.all(1.4) : null,
      elevation:
          ref.watch(isChoiceNodeCardProvider(pos)) ? ConstList.elevation : 0,
      color: ref.watch(colorNodeProvider),
      child: Ink(
        color: ref.watch(colorNodeProvider),
        child: Padding(
          padding: ConstList.isSmallDisplay(context)
              ? const EdgeInsets.all(2.0)
              : const EdgeInsets.all(4.0),
          child: InkWell(
            onDoubleTap: isEditable
                ? () {
                    ref.read(nodeEditorTargetPosProvider.notifier).state =
                        node.pos;
                    ref
                        .read(changeTabProvider.notifier)
                        .changePageString("viewEditor", context);
                  }
                : null,
            onTap: !isEditable && ref.watch(isIgnorePointerProvider(pos))
                ? () {
                    ref.read(choiceNodeSelectProvider(pos).notifier).select(
                          0,
                          showDialogFunction: () => showDialog(
                            context: context,
                            builder: (builder) => RandomDialog(pos),
                            barrierDismissible: false,
                          ),
                        );
                  }
                : null,
            child: ViewChoiceNodeContent(pos),
          ),
        ),
      ),
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
      title: const Text('크기 수정', textAlign: TextAlign.center),
      content: SizedBox(
        width: 400,
        height: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('길이 : $str', style: Theme.of(context).textTheme.titleMedium),
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

class RandomDialog extends ConsumerWidget {
  final Pos pos;

  const RandomDialog(this.pos, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
        scrollable: true,
        title: const Text('랜덤'),
        content: AnimatedFlipCounter(
            value: ref.watch(randomStateNotifierProvider(pos)),
            duration: const Duration(milliseconds: 500),
            textStyle: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                )),
        actions: [
          Visibility(
            visible: !ref.watch(randomProcessExecutedProvider),
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('확인'),
            ),
          )
        ]);
  }
}

class NodeDraggable extends ConsumerWidget {
  final Pos pos;

  const NodeDraggable(this.pos, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var node = ref.watch(choiceNodeProvider(pos)).node;
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
          ref.read(dragChoiceNodeProvider.notifier).dragStart(pos);
        },
        child: ref.watch(dragChoiceNodeProvider) == pos
            ? Opacity(
                opacity: 0.2,
                child: widget,
              )
            : widget,
        onDragEnd: (DraggableDetails data) {
          ref.read(dragChoiceNodeProvider.notifier).dragEnd();
        },
        onDraggableCanceled: (Velocity velocity, Offset offset) {
          ref.read(dragChoiceNodeProvider.notifier).dragEnd();
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
          ref.read(dragChoiceNodeProvider.notifier).dragStart(pos);
        },
        child: Opacity(
          opacity: ref.watch(dragChoiceNodeProvider) == pos ? 0.2 : 1.0,
          child: widget,
        ),
        onDragEnd: (DraggableDetails data) {
          ref.read(dragChoiceNodeProvider.notifier).dragEnd();
        },
        onDraggableCanceled: (Velocity velocity, Offset offset) {
          ref.read(dragChoiceNodeProvider.notifier).dragEnd();
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
    Widget title;
    if (!ref.watch(isChoiceNodeHideTitleProvider(pos))) {
      if (ref.watch(titleOutlineProvider)) {
        title = TextOutline(
          ref.watch(titleStringProvider(pos)),
          20 * ConstList.scale(context),
          ConstList.getFont(
            ref.watch(titleFontProvider),
          ),
          textColor: ref.watch(colorTitleProvider),
        );
      } else {
        title = Text(
          ref.watch(titleStringProvider(pos)),
          style: ConstList.getFont(ref.watch(titleFontProvider)).copyWith(
            fontSize: 20 * ConstList.scale(context),
            color: ref.watch(colorTitleProvider),
          ),
        );
      }
    } else {
      title = const SizedBox.shrink();
    }

    if (!isEditable) {
      return title;
    }
    return Stack(
      alignment: Alignment.center,
      children: [
        title,
        Align(
          alignment: Alignment.centerRight,
          child: PopupMenuButton<int>(
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
                  ref
                      .read(vmDraggableNestedMapProvider)
                      .copyData(ref.watch(choiceNodeProvider(pos)).node!);
                  break;
              }
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem(
                  value: 0,
                  child: Text('크기 수정'),
                ),
                const PopupMenuItem(
                  value: 1,
                  child: Text('복사'),
                ),
              ];
            },
          ),
        ),
      ],
    );
  }
}

class ViewChoiceNodeMultiSelect extends ConsumerWidget {
  final Pos pos;

  const ViewChoiceNodeMultiSelect(this.pos, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          width: 20,
          child: IconButton(
            padding: EdgeInsets.zero,
            icon: const Icon(Icons.chevron_left),
            onPressed: () {
              if (!isEditable) {
                ref.read(choiceNodeSelectProvider(pos).notifier).select(-1);
              }
            },
          ),
        ),
        Text(
          ref.watch(choiceNodeSelectProvider(pos)).toString(),
          style: Theme.of(context).textTheme.headline5,
          textAlign: TextAlign.center,
        ),
        SizedBox(
          width: 20,
          child: IconButton(
            padding: EdgeInsets.zero,
            icon: const Icon(Icons.chevron_right),
            onPressed: () {
              if (!isEditable) {
                ref.read(choiceNodeSelectProvider(pos).notifier).select(1);
              }
            },
          ),
        ),
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

  @override
  void initState() {
    _focusNode = FocusNode();
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _focusNode?.dispose();
    _scrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (ref.watch(contentsQuillProvider(widget.pos)).document.isEmpty()) {
      return const SizedBox.shrink();
    }
    return QuillEditor(
      controller: ref.watch(contentsQuillProvider(widget.pos)),
      focusNode: _focusNode!,
      readOnly: true,
      autoFocus: false,
      expands: false,
      padding: const EdgeInsets.symmetric(vertical: 4),
      showCursor: false,
      scrollController: _scrollController!,
      scrollable: false,
      enableInteractiveSelection: false,
      customStyles: ConstList.getDefaultThemeData(
          context, ConstList.scale(context),
          fontStyle: ConstList.getFont(ref.watch(mainFontProvider))),
    );
  }
}

class ViewChoiceNodeContent extends ConsumerWidget {
  final Pos pos;

  const ViewChoiceNodeContent(this.pos, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var node = ref.watch(choiceNodeProvider(pos)).node!;
    Widget image;
    if (ref.watch(imageStringProvider(pos)).isNotEmpty) {
      image = ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: ref.watch(maximizingImageProvider(pos))
              ? MediaQuery.of(context).size.height / 1.25
              : MediaQuery.of(context).size.height / 2,
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          child: ViewImageLoading(ref.watch(imageStringProvider(pos))),
        ),
      );
    } else {
      image = const SizedBox.shrink();
    }

    Widget? child;
    if (pos.isValid) {
      if (isEditable) {
        child = ViewWrapCustomReorderable(
          pos,
          (i) => NodeDragTarget(pos.addLast(i)),
          maxSize: node.getMaxSize(true),
        );
      } else {
        child = ViewWrapCustom(
          pos,
          (i) => ViewChoiceNode(pos.addLast(i)),
          maxSize: node.getMaxSize(true),
        );
      }
    }
    child ??= const SizedBox.shrink();

    if (ref.watch(imagePositionProvider(pos)) == 1) {
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
    if (ref.watch(imagePositionProvider(pos)) == 2) {
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
    List<Widget> subWidget;
    if (ref.watch(titleOverlapProvider)) {
      subWidget = [
        Stack(
          alignment: ref.watch(titlePositionProvider)
              ? Alignment.topCenter
              : Alignment.bottomCenter,
          children: [
            image,
            ViewTitleWithEdit(pos),
          ],
        ),
      ];
    } else if (ref.watch(titlePositionProvider)) {
      subWidget = [
        ViewTitleWithEdit(pos),
        image,
      ];
    } else {
      subWidget = [
        image,
        ViewTitleWithEdit(pos),
      ];
    }

    subWidget.addAll([
      ViewContents(pos),
      if (node.choiceNodeMode == ChoiceNodeMode.multiSelect)
        ViewChoiceNodeMultiSelect(pos),
      child,
    ]);

    if (!isEditable &&
        getPlatformFileSystem.hasSource(ref.watch(imageStringProvider(pos))) &&
        ref.watch(isVisibleSourceProvider)) {
      subWidget.add(
        TextButton(
          child: const Text(
            '출처',
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w800),
          ),
          onPressed: () {
            var url = getPlatformFileSystem
                .getSource(ref.watch(imageStringProvider(pos)));
            if (url != null && url.isNotEmpty) {
              launchUrlString(url);
            }
          },
        ),
      );
    }
    return Column(
      children: subWidget,
    );
  }
}
