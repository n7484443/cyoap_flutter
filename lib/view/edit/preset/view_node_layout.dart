import 'package:cyoap_core/preset/layout.dart' as lo;
import 'package:cyoap_core/preset/layout.dart' hide Text;
import 'package:cyoap_flutter/i18n.dart';
import 'package:cyoap_flutter/main.dart';
import 'package:cyoap_flutter/viewModel/edit/preset/vm_node_layout.dart';
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
              if (ref.watch(currentNodeLayoutElementIndexProvider) != null)
                const Card(
                  elevation: ConstList.elevation,
                  child: SizedBox(
                    height: 200,
                    child: NodeLayoutElementEditor(),
                  ),
                ),
            ],
          ),
        ),
        const NodeLayoutElementList()
      ],
    );
  }
}

class NodeLayoutElementList extends ConsumerStatefulWidget {
  const NodeLayoutElementList({super.key});

  @override
  ConsumerState createState() => _NodeLayoutElementListState();
}

class _NodeLayoutElementListState extends ConsumerState<NodeLayoutElementList> {
  void swapIndex(int oldIndex, int newIndex) {
    var index = ref.watch(currentPresetIndexProvider);
    var preset = ref.read(choiceNodePresetCurrentEditProvider);
    var layout = preset.layout!;
    var cloneList = [...layout.nodeLayoutElements];
    cloneList.insert(newIndex, cloneList[oldIndex]);
    if (oldIndex < newIndex) {
      cloneList.removeAt(oldIndex);
    } else {
      cloneList.removeAt(oldIndex + 1);
    }
    var newPreset = preset.copyWith.layout!(nodeLayoutElements: cloneList);
    ref
        .read(choiceNodePresetListProvider.notifier)
        .updateIndex(index, newPreset);
  }

  @override
  Widget build(BuildContext context) {
    var preset = ref.watch(choiceNodePresetCurrentEditProvider);
    var layout = preset.layout!;
    return Card(
      elevation: ConstList.elevation,
      child: SizedBox(
        width: 140,
        child: ReorderableListView.builder(
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
            return Padding(
              key: ValueKey(index),
              padding:
                  const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
              child: FilterChip.elevated(
                label: Text(name),
                onSelected: (bool value) {
                  ref
                      .read(currentNodeLayoutElementIndexProvider.notifier)
                      .setIndex(value ? index : null);
                },
                selected:
                    ref.watch(currentNodeLayoutElementIndexProvider) == index,
              ),
            );
          },
          itemCount: layout.nodeLayoutElements.length,
          onReorder: (int oldIndex, int newIndex) {
            swapIndex(oldIndex, newIndex);
          },
        ),
      ),
    );
  }
}

class NodeLayoutElementEditor extends ConsumerStatefulWidget {
  const NodeLayoutElementEditor({super.key});

  @override
  ConsumerState createState() => _NodeLayoutElementEditorState();
}

class _NodeLayoutElementEditorState
    extends ConsumerState<NodeLayoutElementEditor> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const position = ['left', 'right', 'top', 'bottom', 'width', 'height'];
    return Scrollbar(
      controller: _scrollController,
      child: ListView.builder(
        controller: _scrollController,
        itemCount: position.length,
        itemBuilder: (BuildContext context, int index) {
          var pos = position[index];
          return SizedBox(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width: 50, child: Text(pos.i18n)),
                      SizedBox(
                        width: 140,
                        child: CustomDropdownButton<ResponsiveSizeOption>(
                          coverCard: false,
                          value: ref.watch(
                              nodeLayoutResponsiveSizeOptionProvider(
                                  position: pos)),
                          items: ResponsiveSizeOption.values
                              .map<DropdownMenuItem<ResponsiveSizeOption>>(
                                (name) => DropdownMenuItem(
                                  value: name,
                                  child: Text(name.name),
                                ),
                              )
                              .toList(),
                          onChanged: (ResponsiveSizeOption? value) {
                            if (value == null) return;
                            ref
                                .read(nodeLayoutResponsiveSizeOptionProvider(
                                        position: pos)
                                    .notifier)
                                .setValue(value);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 120,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 70,
                            child: TextField(
                              controller: ref.watch(
                                nodeLayoutElementControllerProvider(
                                    position: pos, type: 'px'),
                              ),
                            ),
                          ),
                          const Spacer(),
                          const Text('px'),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 120,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 70,
                            child: TextField(
                              controller: ref.watch(
                                nodeLayoutElementControllerProvider(
                                    position: pos, type: 'percentage'),
                              ),
                            ),
                          ),
                          const Spacer(),
                          const Text('%'),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
