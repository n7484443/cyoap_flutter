import 'package:cyoap_core/choiceNode/choice_node.dart';
import 'package:cyoap_core/choiceNode/pos.dart';
import 'package:cyoap_flutter/model/platform_system.dart';
import 'package:cyoap_flutter/view/choice/view_choice_node.dart';
import 'package:cyoap_flutter/view/edit/view_make_platform.dart';
import 'package:cyoap_flutter/viewModel/choice/vm_choice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async {
  testWidgets('copy paste to queue', (tester) async {
    getPlatformFileSystem.createFromVoid();
    var platform = getPlatformFileSystem.platform!;

    var pos0 = const Pos(data: [0, 0, 0]);
    var pos1 = const Pos(data: [0, 0, 1]);
    platform.addData(pos0, ChoiceNode(title: "copy test 1", width: 12, contents: ""));
    platform.addData(pos1, ChoiceNode(title: "copy test 2", width: 12, contents: ""));

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: ViewMakePlatform()),
      ),
    );
    final container = ProviderScope.containerOf(tester.element(find.byType(ViewMakePlatform)));
    expect(platform.clipboard.queue.length, 0);
    container.read(choiceStatusProvider(pos0)).copyData();
    expect(platform.clipboard.queue.length, 1);
    container.read(choiceStatusProvider(pos1)).copyData();
    expect(platform.clipboard.queue.length, 2);

    var posCopy0 = const Pos(data: [-1]);
    var posCopy1 = const Pos(data: [-2]);
    var vCopy0 = find.byWidgetPredicate((widget) {
      if (widget is! ViewChoiceNode) {
        return false;
      }
      print(widget.pos);
      return widget.pos == posCopy0;
    });
    var vCopy1 = find.byWidgetPredicate((widget) => widget is ViewChoiceNode && widget.pos == posCopy1);
    expect(vCopy0, findsOneWidget);
    expect(vCopy1, findsOneWidget);

    // var dragPos = find.byWidgetPredicate((widget) => widget is NodeDragTarget && widget.pos == posCopy0);
    // await tester.drag(vCopy0, tester.getCenter(dragPos));

    expect(find.byElementType(ViewChoiceNode), findsExactly(5));
  });
}
