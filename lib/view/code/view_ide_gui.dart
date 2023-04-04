import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../main.dart';
import '../../model/code_gui.dart';
import '../../viewModel/code/vm_ide_gui.dart';

class ViewIdeGui extends ConsumerWidget {
  const ViewIdeGui({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var list = ref.watch(codeBlockProvider);
    var widgetList = list.map((e) => getWidgetFromCodeBlock(e)).toList();
    return Card(
      child: ListView.builder(
        itemCount: widgetList.length,
        itemBuilder: (context, index) => Align(
          alignment: Alignment.centerLeft,
          child: widgetList[index],
        ),
      ),
    );
  }
}

Widget getWidgetFromCodeBlock(CodeBlock codeBlock) {
  if (codeBlock is CodeBlockIf) {
    return ViewIfNode(
      condition: codeBlock.code,
      innerTrue: codeBlock.childTrue.map((e) => getWidgetFromCodeBlock(e)).toList(),
      innerFalse: codeBlock.childFalse.map((e) => getWidgetFromCodeBlock(e)).toList(),
    );
  }
  if (codeBlock is CodeBlockFor) {
    return ViewForNode(
      variable: codeBlock.code,
      range: codeBlock.range,
      inner: codeBlock.child.map((e) => getWidgetFromCodeBlock(e)).toList(),
    );
  }

  return ViewCodeText(
    code: codeBlock.code,
  );
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
  final List<Widget>? inner;

  const ViewBranchNode({
    required this.code,
    this.inner,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var widget = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ViewCodeText(code: code),
        if(inner != null)
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: inner!,
            ),
          ),
      ],
    );
    return Draggable(
      feedback: Transform.scale(scale: 0.9, child: widget),
      child: widget,
    );
  }
}

class ViewForNode extends ViewBranchNode {
  final String variable;
  final String range;

  const ViewForNode(
      {required this.variable, required this.range, super.inner, super.key})
      : super(code: "{r for} $variable {b until} $range");
}

class ViewIfNode extends ConsumerWidget {
  final String condition;
  final List<Widget>? innerTrue;
  final List<Widget>? innerFalse;

  const ViewIfNode(
      {required this.condition, this.innerTrue, this.innerFalse, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var widget = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ViewCodeText(code: "{r if} $condition"),
        if(innerTrue != null)
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: innerTrue!,
            ),
          ),
        const ViewCodeText(code: "{r else}"),
        if(innerFalse != null)
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: innerFalse!,
            ),
          ),
      ],
    );
    return Draggable(
      feedback: Transform.scale(scale: 0.9, child: widget),
      child: widget,
    );
  }
}