import 'package:cyoap_core/preset/layout.dart' as lo;
import 'package:cyoap_core/preset/layout.dart' hide Text;
import 'package:cyoap_flutter/i18n.dart';
import 'package:cyoap_flutter/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../viewModel/edit/preset/vm_node_preset.dart';
import '../../../viewModel/edit/preset/vm_preset.dart';
import '../../choice/view_node_layout_render.dart';
import '../../util/view_options.dart';

class ViewNodeLayoutEditor extends ConsumerWidget {
  const ViewNodeLayoutEditor({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var preset = ref.watch(choiceNodePresetCurrentEditProvider);
    var presetIndex = ref.watch(currentPresetIndexProvider);
    var layout = preset.layout!;
    var children = layout.nodeLayoutElements.indexed
        .map(
          (e) => ColoredBox(
            color: [Colors.red, Colors.green, Colors.blue][e.$1],
            child: const SizedBox(
              width: 100,
              height: 100,
            ),
          ),
        )
        .toList();
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Expanded(
                child: NodeLayoutWidget(
                  childrenLayout: layout.nodeLayoutElements,
                  children: children,
                ),
              ),
              const Card(
                elevation: ConstList.elevation,
                child: SizedBox(
                  height: 240,
                  child: NodeLayoutElementEditor(),
                ),
              ),
            ],
          ),
        ),
        Card(
          elevation: ConstList.elevation,
          child: SizedBox(
            height: double.infinity,
            width: 150,
            child: ReorderableList(
              itemBuilder: (context, index) {
                var element = layout.nodeLayoutElements[index];
                var name = switch (element) {
                  lo.Title() => 'Title',
                  lo.Image() => 'Image',
                  lo.Content() => 'Content',
                  lo.Text() => 'Text',
                  lo.Box() => 'Box',
                  lo.NodeLayoutElement() => throw UnimplementedError(),
                };
                return Card(
                  key: ValueKey(index),
                  child: ListTile(
                    title: Text(name),
                  ),
                );
              },
              itemCount: layout.nodeLayoutElements.length,
              onReorder: (before, after) {},
            ),
          ),
        )
      ],
    );
  }
}

class NodeLayoutElementEditor extends ConsumerWidget {
  const NodeLayoutElementEditor({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const position = ['left', 'right', 'top', 'bottom'];
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, mainAxisExtent: 60),
      itemBuilder: (BuildContext context, int index) {
        switch (index % 3) {
          case 0:
            return Center(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(position[index ~/ 3].i18n),
                  const Spacer(),
                  SizedBox(
                    width: 80,
                    child: CustomDropdownButton<ResponsiveSizeOption>(
                      coverCard: false,
                      value: ResponsiveSizeOption.min,
                      items: ResponsiveSizeOption.values
                          .map<DropdownMenuItem<ResponsiveSizeOption>>(
                            (name) => DropdownMenuItem(
                              value: name,
                              child: Text(name.name),
                            ),
                          )
                          .toList(),
                      onChanged: (ResponsiveSizeOption? value) {},
                    ),
                  ),
                ],
              ),
            ));
          case 1:
            return const Card(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 80,
                      child: TextField(),
                    ),
                    Spacer(),
                    Text('px'),
                  ],
                ),
              ),
            );
          default:
            return const Card(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 80,
                      child: TextField(),
                    ),
                    Spacer(),
                    Text('%'),
                  ],
                ),
              ),
            );
        }
      },
      itemCount: position.length * 3,
    );
  }
}
