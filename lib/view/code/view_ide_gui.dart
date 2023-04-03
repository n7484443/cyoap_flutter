import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../main.dart';

class ViewIdeGui extends ConsumerWidget {
  const ViewIdeGui({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var list = const [
      ViewCodeNodeSetter(
        type: "define local",
        leftSide: "t",
        rightSide: "0",
      ),
      ViewCodeNodeSetter(
        type: "설정",
        leftSide: "t",
        rightSide: "0",
      ),
      ViewIfNode(
        condition: "test {b equal} 3",
        innerTrue: ViewCodeNodeSetter(
          type: "set",
          leftSide: "t",
          rightSide: "30",
        ),
        innerFalse: ViewIfNode(
          condition: "test {b smaller} 3",
          innerTrue: ViewCodeNodeSetter(
            type: "set",
            leftSide: "t",
            rightSide: "2",
          ),
          innerFalse: ViewCodeNodeSetter(
            type: "지역 변수 정의",
            leftSide: "a",
            rightSide: "30",
          ),
        ),
      ),
      ViewForNode(
        variable: "test",
        range: "1..3",
        inner: ViewCodeNodeSetter(
          type: "set",
          leftSide: "t",
          rightSide: "0",
        ),
      ),
    ];
    list = [...list, ...list, ...list];
    list = [...list, ...list, ...list];
    return Card(
      child: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) => Align(
          alignment: Alignment.centerLeft,
          child: list[index],
        ),
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
  final Widget? inner;

  const ViewBranchNode({
    required this.code,
    this.inner,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var innerWidget = inner ??
        DragTarget(
          builder: (BuildContext context, List<dynamic> accepted,
                  List<dynamic> rejected) =>
              const SizedBox(
            height: 40,
            width: 40,
          ),
        );
    var widget = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ViewCodeText(code: code),
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: innerWidget,
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
  final Widget? innerTrue;
  final Widget? innerFalse;

  const ViewIfNode(
      {required this.condition, this.innerTrue, this.innerFalse, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var widget = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ViewCodeText(code: "{r if} $condition"),
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: innerTrue,
        ),
        const ViewCodeText(code: "{r else}"),
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: innerFalse,
        ),
      ],
    );
    return Draggable(
      feedback: Transform.scale(scale: 0.9, child: widget),
      child: widget,
    );
  }
}

class ViewCodeNodeSetter extends ConsumerWidget {
  final String type;
  final String leftSide;
  final String rightSide;

  const ViewCodeNodeSetter(
      {required this.type,
      required this.leftSide,
      required this.rightSide,
      super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ViewCodeText(code: "{$type} $leftSide {b to} $rightSide");
  }
}
