import 'package:cyoap_flutter/view/util/view_back_dialog.dart';
import 'package:cyoap_flutter/view/view_choice_node.dart';
import 'package:cyoap_flutter/view/view_draggable_nested_map.dart';
import 'package:cyoap_flutter/viewModel/vm_platform.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../main.dart';
import '../model/choiceNode/pos.dart';
import '../model/platform_system.dart';
import '../viewModel/vm_choice_node.dart';
import '../viewModel/vm_draggable_nested_map.dart';

class ViewSaveDialog extends ConsumerWidget {
  final bool asZip;

  const ViewSaveDialog(
    this.asZip, {
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: Text(asZip ? '저장중...' : '압축중...'),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          Text(ref.watch(stopWatchProvider)),
        ],
      ),
    );
  }
}

class ViewMake extends ConsumerWidget {
  const ViewMake({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var appbarWidget = AppBar(
      leading: IconButton(
        tooltip: '뒤로가기',
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          if (ref.read(draggableNestedMapChangedProvider)) {
            showDialog<bool>(
              context: context,
              builder: (_) => ViewBackDialog(() => () {}, () {}),
            ).then((value) async {
              if (value ?? false) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => ViewSaveDialog(getPlatformFileSystem.openAsFile),
                    barrierDismissible: false);
                savePlatform(ref, getPlatformFileSystem.openAsFile).then((v) {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacementNamed("/");
                  ref.read(draggableNestedMapChangedProvider.notifier).state =
                      false;
                });
              }
            });
          } else {
            Navigator.of(context).pushReplacementNamed("/");
          }
        },
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          DragTarget<Pos>(
            builder: (BuildContext context, List<dynamic> accepted,
                List<dynamic> rejected) {
              return const Tooltip(
                  message: '드래그&드랍으로 선택지 삭제', child: Icon(Icons.delete));
            },
            onAccept: (Pos data) {
              ref.read(vmDraggableNestedMapProvider).removeData(data);
            },
          ),
          Draggable<Pos>(
            data: Pos(data: [nonPositioned, nonPositioned]),
            feedback: Transform.scale(
              scale: 0.9,
              child: Opacity(
                opacity: 0.6,
                child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 400,
                    ),
                    child: ViewChoiceNode(
                        Pos(data: [nonPositioned, nonPositioned]))),
              ),
            ),
            onDragStarted: () {
              ref
                  .read(dragChoiceNodeProvider.notifier)
                  .dragStart(Pos(data: [nonPositioned, nonPositioned]));
            },
            onDragEnd: (DraggableDetails data) {
              ref.read(dragChoiceNodeProvider.notifier).dragEnd();
            },
            onDragUpdate: (DragUpdateDetails details) => ref
                .read(dragPositionProvider.notifier)
                .state = details.localPosition.dy,
            child: const Tooltip(
              message: '드래그로 선택지 생성',
              child: Icon(Icons.add),
            ),
          ),
          Visibility(
            visible: ref.watch(removedChoiceNode) != null,
            child: Draggable<Pos>(
              data: Pos(data: [removedPositioned, removedPositioned]),
              feedback: Transform.scale(
                scale: 0.9,
                child: Opacity(
                  opacity: 0.6,
                  child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 400,
                      ),
                      child: ViewChoiceNode(
                          Pos(data: [removedPositioned, removedPositioned]))),
                ),
              ),
              onDragStarted: () {
                ref.read(dragChoiceNodeProvider.notifier).dragStart(
                    Pos(data: [removedPositioned, removedPositioned]));
              },
              onDragEnd: (DraggableDetails data) {
                ref.read(dragChoiceNodeProvider.notifier).dragEnd();
              },
              onDragUpdate: (DragUpdateDetails details) => ref
                  .read(dragPositionProvider.notifier)
                  .state = details.localPosition.dy,
              child: const Tooltip(
                message: '최근 삭제된 선택지 생성',
                child: Icon(Icons.paste),
              ),
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.play_arrow),
          tooltip: '변수 목록 갱신',
          onPressed: () {
            getPlatform.generateRecursiveParser();
            getPlatform.updateStatusAll();
          },
        ),
        PopupMenuButton(
          icon: const Icon(Icons.save),
          tooltip: '저장 관련 옵션',
          onSelected: (int selected) {
            showDialog(
                context: context,
                builder: (BuildContext context) => ViewSaveDialog(selected == 0),
                barrierDismissible: false);
            switch (selected) {
              case 0:
                savePlatform(ref, false)
                    .then((value) => Navigator.of(context).pop());
                break;
              case 1:
                savePlatform(ref, true)
                    .then((value) => Navigator.of(context).pop());
                break;
            }
          },
          itemBuilder: (BuildContext context) {
            return [
              if (!getPlatformFileSystem.openAsFile)
                const PopupMenuItem(
                  value: 0,
                  child: Text('저장'),
                ),
              PopupMenuItem(
                value: 1,
                child: Text(
                    '${ConstList.isMobile() ? 'download 폴더에 ' : ''}zip 파일로 추출'),
              ),
            ];
          },
        )
      ],
    );

    return WillPopScope(
      onWillPop: () {
        return showDialog(
          context: context,
          builder: (_) => ViewBackDialog(
            () => savePlatform(ref, ConstList.isWeb()),
            () => Navigator.of(context).pop(),
          ),
        ) as Future<bool>;
      },
      child: Scaffold(
        appBar: appbarWidget,
        body: const NestedScroll(),
      ),
    );
  }
}
