import 'package:cyoap_core/choiceNode/choice_node.dart';
import 'package:cyoap_core/choiceNode/pos.dart';
import 'package:cyoap_core/choiceNode/selectable_status.dart';
import 'package:cyoap_flutter/model/platform_system.dart';
import 'package:cyoap_flutter/view/util/view_wrap_custom.dart';
import 'package:cyoap_flutter/view/view_choice_node.dart';
import 'package:cyoap_flutter/viewModel/vm_design_setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  getPlatformFileSystem.isEditable = false;
  var pos0_0 = Pos(data: [0, 0]);
  getPlatform.addData(
    pos0_0,
    ChoiceNode(
      4,
      "디자인",
      "[{\"insert\":\"레이아웃과 폰트, 디자인, 크기 등을 조정하고 확인할 수 있습니다.\\n\"}]",
      "noImage",
    )
  );

  testWidgets('ViewChoiceNodeMain', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: ProviderScope(
        overrides: [
          titleOutlineProvider.overrideWithValue(StateController(false)),
          colorNodeProvider.overrideWithValue(StateController(Colors.black)),
          colorOutlineProvider.overrideWithValue(StateController(Colors.white)),
        ],
        child: ViewChoiceNodeMain(pos0_0),
      ),
    ));

    expect(find.text('디자인'), findsOneWidget);
    expect(
        find.text('레이아웃과 폰트, 디자인, 크기 등을 조정하고 확인할 수 있습니다.', findRichText: true),
        findsOneWidget);
    var before = (find.byType(Card).evaluate().single.widget as Card).shape;
    expect(before is RoundedRectangleBorder, true);
    expect((before! as RoundedRectangleBorder).side.color, Colors.black);

    await tester.tap(find.byType(Card));
    await tester.pump();
    var after = (find.byType(Card).evaluate().single.widget as Card).shape;
    expect(after is RoundedRectangleBorder, true);
    expect((after! as RoundedRectangleBorder).side.color, Colors.white);
  });

  var parentPos1 = Pos(data: [1]);
  var pos1_0 = Pos(data: [1, 0]);
  var pos1_1 = Pos(data: [1, 1]);
  getPlatform.addData(
    pos1_0,
    ChoiceNode(
      4,
      "디자인",
      "[{\"insert\":\"레이아웃과 폰트, 디자인, 크기 등을 조정하고 확인할 수 있습니다.\\n\"}]",
      "noImage",
    )
  );
  getPlatform.addData(
    pos1_1,
    ChoiceNode(
      4,
      "디자인",
      "[{\"insert\":\"레이아웃과 폰트, 디자인, 크기 등을 조정하고 확인할 수 있습니다.\\n\"}]",
      "noImage",
    )
  );

  testWidgets('OccupySpace', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: ProviderScope(
        overrides: [],
        child: ViewWrapCustom(
            parentPos1, (i) => ViewChoiceNode(parentPos1.addLast(i))),
      ),
    ));
    getPlatform.getChoiceNode(pos1_0)?.choiceNodeDesign = ChoiceNodeDesign(isOccupySpace: true);
    getPlatform.getChoiceNode(pos1_0)?.selectableStatus = SelectableStatus.hide;
    getPlatform.getChoiceNode(pos1_1)?.choiceNodeDesign = ChoiceNodeDesign(isOccupySpace: true);
    getPlatform.getChoiceNode(pos1_1)?.selectableStatus = SelectableStatus.hide;
    expect(find.byType(Expanded), findsNWidgets(3));
  });
  testWidgets('OccupySpaceFalse', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: ProviderScope(
        overrides: [],
        child: ViewWrapCustom(
            parentPos1, (i) => ViewChoiceNode(parentPos1.addLast(i))),
      ),
    ));
    getPlatform.getChoiceNode(pos1_0)?.choiceNodeDesign = ChoiceNodeDesign(isOccupySpace: false);
    getPlatform.getChoiceNode(pos1_0)?.selectableStatus = SelectableStatus.hide;
    getPlatform.getChoiceNode(pos1_1)?.choiceNodeDesign = ChoiceNodeDesign(isOccupySpace: false);
    getPlatform.getChoiceNode(pos1_1)?.selectableStatus = SelectableStatus.hide;
    expect(find.byType(Expanded), findsNothing);
  });
}
