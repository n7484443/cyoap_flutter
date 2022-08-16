import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:cyoap_flutter/model/choiceNode/choice_node.dart';
import 'package:cyoap_flutter/view/util/view_image_loading.dart';
import 'package:cyoap_flutter/view/util/view_text_outline.dart';
import 'package:cyoap_flutter/view/util/view_wrap_custom.dart';
import 'package:cyoap_flutter/view/view_draggable_nested_map.dart';
import 'package:cyoap_flutter/viewModel/vm_choice_node.dart';
import 'package:cyoap_flutter/viewModel/vm_design_setting.dart';
import 'package:cyoap_flutter/viewModel/vm_draggable_nested_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../main.dart';
import '../model/choiceNode/pos.dart';
import '../model/editor.dart';
import '../model/platform_system.dart';
import '../viewModel/vm_make_platform.dart';
import '../viewModel/vm_variable_table.dart';

class ViewChoiceNode extends ConsumerWidget {
  final Pos pos;

  const ViewChoiceNode(this.pos, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (pos.last == nonPositioned) {
      return Card(
        child: SizedBox(
          width: MediaQuery.of(context).size.width /
              defaultMaxSize *
              3 *
              ConstList.scale(context),
          height: nodeBaseHeight * ConstList.scale(context),
        ),
      );
    }
    var node = ref.watch(choiceNodeProvider(pos))!;
    return Opacity(
      opacity: ref.watch(opacityProvider(pos)),
      child: Card(
        shape: ref.watch(isChoiceNodeRoundProvider(pos))
            ? RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
                side: BorderSide(
                  color: ref.watch(isChoiceNodeSelectableProvider(pos))
                      ? Colors.lightBlueAccent
                      : ref.watch(colorNodeProvider),
                  width: ConstList.isSmallDisplay(context) ? 2 : 4,
                ),
              )
            : Border.fromBorderSide(
                BorderSide(
                  color: ref.watch(isChoiceNodeSelectableProvider(pos))
                      ? Colors.lightBlueAccent
                      : ref.watch(colorNodeProvider),
                  width: ConstList.isSmallDisplay(context) ? 2 : 4,
                ),
              ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        margin: ConstList.isSmallDisplay(context)
            ? const EdgeInsets.all(1.4)
            : null,
        elevation:
            ref.watch(isChoiceNodeCardProvider(pos)) ? ConstList.elevation : 0,
        color: ref.watch(colorNodeProvider),
        child: Visibility(
          visible: isEditable || node.isVisible(),
          child: Ink(
            color: ref.watch(colorNodeProvider),
            child: Padding(
              padding: ConstList.isSmallDisplay(context)
                  ? const EdgeInsets.all(2.0)
                  : const EdgeInsets.all(4.0),
              child: InkWell(
                onDoubleTap: isEditable
                    ? () {
                        NodeEditor().target = node;
                        ref
                            .read(changeTabProvider.notifier)
                            .changePageString("viewEditor", context);
                      }
                    : null,
                onTap: !isEditable &&
                        (ref.watch(nodeModeProvider(pos)) !=
                                ChoiceNodeMode.multiSelect ||
                            ref.watch(isIgnorePointerProvider(pos)))
                    ? () => ref
                        .read(choiceNodeSelectProvider(pos).notifier)
                        .select(0, context)
                    : null,
                child: ViewChoiceNodeContent(pos),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SizeDialog extends ConsumerWidget {
  final Pos pos;

  const SizeDialog(this.pos, {Key? key}) : super(key: key);

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
                refreshLine(ref, pos.first);
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

  const RandomDialog(this.pos, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
        scrollable: true,
        title: const Text('랜덤'),
        content: AnimatedFlipCounter(
            value: ref.watch(randomStateNotifierProvider(pos)),
            duration: const Duration(milliseconds: 500),
            textStyle: const TextStyle(
              fontSize: 40,
              color: Colors.blue,
              fontWeight: FontWeight.bold,
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

  const NodeDraggable(this.pos, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var node = ref.watch(choiceNodeProvider(pos));
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

  const ViewTitleWithEdit(this.pos, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget title;
    if (!ref.watch(isChoiceNodeHideTitleProvider(pos))) {
      if (ref.watch(titleOutlineProvider)) {
        title = TextOutline(
          ref.watch(titleStringProvider(pos)),
          20 * ConstList.scale(context),
          ConstList.getFont(ref.watch(titleFontProvider)),
        );
      } else {
        title = Text(
          ref.watch(titleStringProvider(pos)),
          style: ConstList.getFont(ref.watch(titleFontProvider)).copyWith(
            fontSize: 20 * ConstList.scale(context),
            color: ref.watch(colorNodeProvider).computeLuminance() > 0.5
                ? Colors.black
                : Colors.white,
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
                      .copyData(ref, ref.watch(choiceNodeProvider(pos))!);
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

  const ViewChoiceNodeMultiSelect(this.pos, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: IconButton(
            icon: const Icon(Icons.chevron_left, size: 30),
            onPressed: () {
              if (!isEditable) {
                ref
                    .read(choiceNodeSelectProvider(pos).notifier)
                    .select(-1, context);
              }
            },
          ),
        ),
        Expanded(
          child: Text(
            ref.watch(choiceNodeSelectProvider(pos)).toString(),
            style: Theme.of(context).textTheme.headline4,
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: IconButton(
            icon: const Icon(Icons.chevron_right, size: 30),
            onPressed: () {
              if (!isEditable) {
                ref
                    .read(choiceNodeSelectProvider(pos).notifier)
                    .select(1, context);
              }
            },
          ),
        ),
      ],
    );
  }
}

class ViewContents extends ConsumerWidget {
  final Pos pos;
  const ViewContents(this.pos, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var node = ref.watch(choiceNodeProvider(pos))!;
    if (ref.watch(contentsQuillProvider(pos)).document.isEmpty()) {
      if (node.choiceNodeMode == ChoiceNodeMode.multiSelect) {
        return ViewChoiceNodeMultiSelect(node.pos);
      } else {
        return const SizedBox.shrink();
      }
    } else {
      Widget contentText = IgnorePointer(
        child: QuillEditor(
          controller: ref.watch(contentsQuillProvider(pos)),
          focusNode: FocusNode(),
          readOnly: true,
          autoFocus: false,
          expands: false,
          padding: const EdgeInsets.only(top: 4),
          scrollController: ScrollController(),
          scrollable: false,
          customStyles: ConstList.getDefaultThemeData(
              context, ConstList.scale(context),
              fontStyle: ConstList.getFont(ref.watch(mainFontProvider))),
        ),
      );
      if (node.choiceNodeMode == ChoiceNodeMode.multiSelect) {
        return Column(children: [
          contentText,
          ViewChoiceNodeMultiSelect(node.pos),
        ]);
      } else {
        return contentText;
      }
    }
  }
}

class ViewChoiceNodeContent extends ConsumerWidget {
  final Pos pos;

  const ViewChoiceNodeContent(this.pos, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var node = ref.watch(choiceNodeProvider(pos))!;
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
          (i) => NodeDragTarget(Pos(data: [...pos.data, i])),
          maxSize: node.getMaxSize(true),
        );
      } else if (node.children.isNotEmpty) {
        child = ViewWrapCustom(
          pos,
          (child) => ViewChoiceNode(child.pos),
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
