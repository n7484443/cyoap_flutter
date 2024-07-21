import 'package:cyoap_core/choiceNode/pos.dart';
import 'package:cyoap_flutter/i18n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../main.dart';
import '../../model/code_gui.dart';
import '../../viewModel/code/vm_ide.dart';
import '../../viewModel/code/vm_ide_gui.dart';
import '../../viewModel/edit/vm_editor.dart';

class ViewIdeGui extends ConsumerWidget {
  const ViewIdeGui({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var list = ref.watch(codeBlockProvider).state;
    var widgetList = <Widget>[];
    for (int i = 0; i < list.codeBlocks.length; i++) {
      widgetList.add(ViewCodeBlockWrapper(pos: Pos(data: [i])));
    }
    widgetList.add(
      const ViewDragTargetNode(
        pos: Pos(data: []),
      ),
    );
    return Card(
      child: Row(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widgetList.length,
              itemBuilder: (context, index) => Align(
                alignment: Alignment.centerLeft,
                child: widgetList[index],
              ),
            ),
          ),
          const VerticalDivider(),
          SizedBox(
            width: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DragTarget<Pos>(
                      onAcceptWithDetails: (DragTargetDetails<Pos> dragDetails) {
                        var pos = dragDetails.data;
                        if (pos.first < 0) return;
                        ref.read(codeBlockProvider.notifier).removeBlock(pos);
                      },
                      builder: (BuildContext context,
                          List<Object?> candidateData,
                          List<dynamic> rejectedData) {
                        return const Icon(Icons.delete);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.dns_rounded),
                      tooltip: "gui".i18n,
                      onPressed: () {
                        var code = ref.read(codeBlockProvider).state.build();
                        var out = ref
                            .read(ideCurrentInputProvider.notifier)
                            .formatting(code);
                        ref
                            .read(nodeEditorTargetProvider.notifier)
                            .setState((node) {
                          node.conditionalCodeHandler.executeCodeString =
                              out.$1;
                          return node;
                        });
                        ref
                            .read(currentIdeOpenProvider.notifier)
                            .update((state) => !state);
                      },
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: CodeBlockType.values.length,
                    itemBuilder: (context, index) {
                      var inner = Card(
                        elevation: 3.0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(CodeBlockType.values[index].name),
                        ),
                      );
                      return Align(
                        alignment: Alignment.centerLeft,
                        child: ViewDraggableNode(
                          pos: Pos(data: [-(index + 1)]),
                          child: inner,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ViewCodeBlockWrapper extends ConsumerWidget {
  final Pos pos;

  const ViewCodeBlockWrapper({required this.pos, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var block = ref.watch(codeBlockProvider).searchBlock(pos);
    Widget widget = const ViewCodeText(
      code: '',
    );
    if (block is CodeBlockIf) {
      widget = ViewIfNode(
        pos: pos,
      );
    } else if (block is CodeBlockFor) {
      widget = ViewForNode(
        variable: block.code,
        range: block.range,
        pos: pos,
      );
    } else if (block is CodeBlock) {
      widget = ViewCodeText(
        code: block.code,
      );
    }

    return ViewDraggableNode(
      pos: pos,
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return ViewNodeEditDialog(pos: pos);
            },
          );
        },
        child: widget,
      ),
    );
  }
}

final RegExp checkColorReg = RegExp(r"\{.*?\}");

class ViewCodeText extends ConsumerWidget {
  final String code;

  const ViewCodeText({
    required this.code,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var black = ConstList.getCurrentFont(context).bodyLarge;
    var red = black?.copyWith(color: Colors.red);
    var blue = black?.copyWith(color: Colors.blue);
    var green = black?.copyWith(color: Colors.green);
    var codeRegex = code.contains(checkColorReg);
    if (!codeRegex) {
      return Card(
        elevation: 3.0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(
            code,
            style: black,
          ),
        ),
      );
    } else {
      var matches = checkColorReg.allMatches(code).toList();
      var widgetList = <Widget>[];
      int i = 0;
      for (var match in matches) {
        var text = code.substring(i, match.start);
        var innerText = code.substring(match.start + 1, match.end - 1);
        widgetList.add(Text(text, style: black));
        if (innerText.startsWith('r ')) {
          widgetList.add(Text(innerText.substring(2), style: red));
        } else if (innerText.startsWith('b ')) {
          widgetList.add(Text(innerText.substring(2), style: blue));
        } else {
          widgetList.add(Text(innerText, style: green));
        }
        i = match.end;
      }
      if (i < code.length) {
        widgetList.add(Text(code.substring(i), style: black));
      }
      return Card(
        elevation: 3.0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: widgetList,
          ),
        ),
      );
    }
  }
}

class ViewBranchNode extends ConsumerWidget {
  final String code;
  final Pos pos;

  const ViewBranchNode({
    required this.code,
    required this.pos,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var block = ref.watch(codeBlockProvider).searchBlock(pos);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ViewCodeText(code: code),
        if (block.child != null)
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                block.child!.length,
                (index) {
                  return ViewCodeBlockWrapper(
                    pos: pos.addLast(index),
                  );
                },
              ),
            ),
          ),
        ViewDragTargetNode(pos: pos),
      ],
    );
  }
}

class ViewForNode extends ViewBranchNode {
  final String variable;
  final String range;

  const ViewForNode(
      {required this.variable,
      required this.range,
      required super.pos,
      super.key})
      : super(code: "{r for} $variable {b until} $range");
}

class ViewIfNode extends ConsumerWidget {
  final Pos pos;

  const ViewIfNode({required this.pos, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var block = ref.watch(codeBlockProvider).searchBlock(pos) as CodeBlockIf;
    var blockTrue = block.childTrue;
    var blockFalse = block.childFalse;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ViewCodeText(code: "{r if} ${block.code}"),
        if (blockTrue.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                blockTrue.length,
                (index) {
                  return ViewCodeBlockWrapper(
                    pos: pos.addLast(index),
                  );
                },
              ),
            ),
          ),
        ViewDragTargetNode(
          onAccept: (Pos data) {
            if (data.first >= 0) {
              var removed = ref.read(codeBlockProvider).removeBlock(data);
              if (removed == null) {
                return;
              }
              ref.read(codeBlockProvider).addBlock(pos, removed, option: true);
            } else {
              var codeBlockBuild =
                  CodeBlockType.values[-(data.first + 1)].toCodeBlock();
              ref
                  .read(codeBlockProvider)
                  .addBlock(pos, codeBlockBuild(), option: true);
            }
          },
          pos: pos,
        ),
        const ViewCodeText(code: "{r else}"),
        if (blockFalse.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                blockFalse.length,
                (index) {
                  return ViewCodeBlockWrapper(
                    pos: pos.addLast(blockFalse.length + index),
                  );
                },
              ),
            ),
          ),
        ViewDragTargetNode(
          onAccept: (Pos data) {
            if (data.first >= 0) {
              var removed = ref.read(codeBlockProvider).removeBlock(data);
              if (removed == null) {
                return;
              }
              ref.read(codeBlockProvider).addBlock(pos, removed, option: false);
            } else {
              var codeBlockBuild =
                  CodeBlockType.values[-(data.first + 1)].toCodeBlock();
              ref
                  .read(codeBlockProvider)
                  .addBlock(pos, codeBlockBuild(), option: false);
            }
          },
          pos: pos,
        ),
      ],
    );
  }
}

class ViewDragTargetNode extends ConsumerWidget {
  final void Function(Pos)? onAccept;
  final Pos pos;

  const ViewDragTargetNode({
    this.onAccept,
    required this.pos,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var dragPos = ref.watch(codeBlockPosProvider);
    if (dragPos == null || dragPos.isParent(pos) || dragPos == pos) {
      return const Opacity(
        opacity: 0.0,
        child: Card(
          child: SizedBox(
            height: 18.0,
            width: 100.0,
          ),
        ),
      );
    }
    return DragTarget<Pos>(
      builder: (BuildContext context, List<Pos?> candidateData,
          List<dynamic> rejectedData) {
        return const Card(
          color: Colors.blue,
          child: SizedBox(
            height: 18.0,
            width: 100.0,
          ),
        );
      },
      onAcceptWithDetails: (DragTargetDetails<Pos> dragDetails) {
        var data = dragDetails.data;
        if (onAccept == null) {
          if (data.first >= 0) {
            var removed = ref.read(codeBlockProvider).removeBlock(data);
            if (removed == null) {
              return;
            }
            ref.read(codeBlockProvider).addBlock(pos, removed);
          } else {
            var codeBlockBuild =
                CodeBlockType.values[-(data.first + 1)].toCodeBlock();
            ref.read(codeBlockProvider).addBlock(pos, codeBlockBuild());
          }
          return;
        }
        onAccept!(data);
      },
    );
  }
}

class ViewDraggableNode extends ConsumerWidget {
  final Widget child;
  final Pos pos;

  const ViewDraggableNode({
    required this.child,
    required this.pos,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Draggable<Pos>(
      feedback: Transform.scale(scale: 0.9, child: Material(child: child)),
      data: pos,
      child: child,
      onDragStarted: () {
        ref.read(codeBlockPosProvider.notifier).state = pos;
      },
      onDragEnd: (DraggableDetails details) {
        ref.read(codeBlockPosProvider.notifier).state = null;
      },
    );
  }
}

class ViewNodeEditDialog extends ConsumerStatefulWidget {
  final Pos pos;

  const ViewNodeEditDialog({
    required this.pos,
    super.key,
  });

  @override
  ConsumerState createState() => _ViewNodeEditDialogState();
}

class _ViewNodeEditDialogState extends ConsumerState<ViewNodeEditDialog> {
  TextEditingController? _controller;

  @override
  void initState() {
    var block = ref.read(codeBlockProvider).searchBlock(widget.pos);
    if (block is CodeBlockIf) {
      _controller = TextEditingController(text: block.code.toString());
    } else {
      _controller = TextEditingController();
    }
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var block = ref.watch(codeBlockProvider).searchBlock(widget.pos);
    if (block is CodeBlockIf) {
      return AlertDialog(
        scrollable: true,
        title: Text('edit'.i18n),
        content: Column(
          children: [
            TextField(controller: _controller),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('no'.i18n),
          ),
          TextButton(
            onPressed: () {
              (block.code as CodeBlock).code = _controller!.text;
              Navigator.of(context).pop();
              ref.read(codeBlockProvider).updatePos();
            },
            child: Text('yes'.i18n),
          ),
        ],
      );
    }
    return AlertDialog(
      title: Text('edit'.i18n),
      content: Text(block.toString()),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('no'.i18n),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            ref.read(codeBlockProvider).updatePos();
          },
          child: Text('yes'.i18n),
        ),
      ],
    );
  }
}
