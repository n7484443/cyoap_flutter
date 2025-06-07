import 'package:cyoap_core/preset/node_preset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cyoap_flutter/view/edit/view_editor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cyoap_core/choiceNode/choice_node.dart';
import 'package:cyoap_flutter/viewModel/edit/vm_editor.dart';
import 'package:cyoap_flutter/viewModel/edit/preset/vm_choice_node_preset.dart';

void main() {
  testWidgets('ViewTitleTextFieldInput 텍스트 입력 테스트', (WidgetTester tester) async {
    // 테스트용 ChoiceNode 생성
    final choiceNode = ChoiceNode(
      title: '테스트 제목',
      contents: '',
    );

    // Provider 설정
    final container = ProviderContainer(
      overrides: [
        nodeEditorTargetProvider.overrideWith(() => NodeEditorTarget()),
        nodeEditorTargetPosProvider.overrideWith((pos) => null),
        nodeTitleProvider.overrideWith((pos) => '테스트 제목'),
        choiceNodePresetProvider.overrideWith((ref, name) => ChoiceNodeDesignPreset()),
      ],
    );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: Scaffold(
            body: ViewTitleTextFieldInput(),
          ),
        ),
      ),
    );

    // TextField 찾기
    final textField = find.byType(TextField);
    expect(textField, findsOneWidget);

    // 텍스트 입력 테스트
    await tester.enterText(textField, '새로운 제목');
    await tester.pump();

    // 입력된 텍스트 확인
    expect(find.text('새로운 제목'), findsOneWidget);
    print(find.text('새로운 제목'));
    
    // Provider 상태 확인
    expect(container.read(nodeTitleProvider), '새로운 제목');
    expect(container.read(nodeEditorTargetProvider).title, '새로운 제목');
  });

  testWidgets('ViewTextContentsEditor 텍스트 입력 테스트', (WidgetTester tester) async {
    // 테스트용 ChoiceNode 생성
    final choiceNode = ChoiceNode(
      title: '테스트 제목',
      contents: '',
    );

    // Provider 설정
    final container = ProviderContainer(
      overrides: [
        nodeEditorTargetProvider.overrideWith(() => NodeEditorTarget()),
        nodeEditorTargetPosProvider.overrideWith((pos) => null),
        nodeTitleProvider.overrideWith((pos) => '테스트 제목'),
        choiceNodePresetProvider.overrideWith((ref, name) => ChoiceNodeDesignPreset()),
      ],
    );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: Scaffold(
            body: ViewTextContentsEditor(),
          ),
        ),
      ),
    );

    // QuillEditor 찾기
    final quillEditor = find.byType(QuillEditor);
    expect(quillEditor, findsOneWidget);

    // 텍스트 입력 테스트
    await tester.enterText(quillEditor, '테스트 내용');
    await tester.pump();

    // 입력된 텍스트 확인
    expect(find.text('테스트 내용'), findsOneWidget);
    
    // Provider 상태 확인
    expect(container.read(nodeEditorTargetProvider).contentsString, isNotEmpty);
  });
} 