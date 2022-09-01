// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:cyoap_flutter/model/choiceNode/choice_node.dart';
import 'package:cyoap_flutter/model/choiceNode/pos.dart';
import 'package:cyoap_flutter/model/platform_system.dart';
import 'package:cyoap_flutter/view/view_choice_node.dart';
import 'package:cyoap_flutter/viewModel/vm_choice_node.dart';
import 'package:cyoap_flutter/viewModel/vm_design_setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  getPlatformFileSystem.isEditable = false;
  var pos = Pos(data: [0, 0]);
  getPlatform.addData(pos, ChoiceNode(
    4,
    true,
    "디자인",
    "[{\"insert\":\"레이아웃과 폰트, 디자인, 크기 등을 조정하고 확인할 수 있습니다.\\n\"}]",
    "noImage",
  ));


  testWidgets('ViewChoiceNodeMain', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: ProviderScope(
        overrides: [
          titleOutlineProvider.overrideWithValue(StateController(false)),
          colorNodeProvider.overrideWithValue(StateController(Colors.black)),
          colorOutlineProvider.overrideWithValue(StateController(Colors.white)),
        ],
        child: ViewChoiceNodeMain(pos),
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

  testWidgets('ViewChoiceNodeWithOpacity', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: ProviderScope(
        overrides: [
          isChoiceNodeIsOccupySpaceProvider(pos).overrideWithValue(true),
          opacityProvider(pos).overrideWithValue(0),
        ],
        child: ViewChoiceNode(pos),
      ),
    ));
    expect(find.byType(ViewChoiceNodeMain, skipOffstage: false), isOnstage);
  });
  testWidgets('ViewChoiceNodeWithOffstage', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: ProviderScope(
        overrides: [
          isChoiceNodeIsOccupySpaceProvider(pos).overrideWithValue(false),
          opacityProvider(pos).overrideWithValue(0),
        ],
        child: ViewChoiceNode(pos),
      ),
    ));
    expect(find.byType(ViewChoiceNodeMain, skipOffstage: false), isOffstage);
  });
}
