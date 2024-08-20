import 'package:cyoap_core/choiceNode/pos.dart';
import 'package:cyoap_flutter/i18n.dart';
import 'package:cyoap_flutter/view/choice/view_choice_node.dart';
import 'package:cyoap_flutter/view/util/view_switch_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/platform_system.dart';
import '../viewModel/vm_selected_grid.dart';

class ViewSelectedResultGrid extends ConsumerStatefulWidget {
  const ViewSelectedResultGrid({super.key});

  @override
  ConsumerState createState() => _ViewSelectedResultGridState();
}

class _ViewSelectedResultGridState
    extends ConsumerState<ViewSelectedResultGrid> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var globalKey = GlobalKey();
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 10.0),
      content: Consumer(builder: (context, ref, child) {
        var numRow = ref.watch(numRowProvider);
        var posList =
            getPlatform.selectedResult(ref.watch(separateChildProvider));
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ViewSwitchLabel(
                      () {
                        ref
                            .read(separateLineProvider.notifier)
                            .update((b) => !b);
                      },
                      ref.watch(separateLineProvider),
                      label: 'separate_line'.i18n,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ViewSwitchLabel(
                      () {
                        ref
                            .read(separateChildProvider.notifier)
                            .update((b) => !b);
                      },
                      ref.watch(separateChildProvider),
                      label: 'separate_child'.i18n,
                    ),
                  ),
                  const Padding(padding: EdgeInsets.all(8.0)),
                  Row(
                    children: [
                      Text('change_result_size'.i18n),
                      Slider(
                        onChanged: (value) {
                          ref
                              .read(numRowProvider.notifier)
                              .update((i) => value.toInt());
                        },
                        value: ref.watch(numRowProvider).toDouble(),
                        min: 1,
                        max: 12,
                        label: ref.watch(numRowProvider).toString(),
                      ),
                    ],
                  ),
                ],
              ),
              const Padding(padding: EdgeInsets.all(8.0)),
              Expanded(
                child: RepaintBoundary(
                  key: globalKey,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: ColoredBox(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: Column(
                        children:
                            List.generate(posList.length * 2 - 1, (index) {
                          if (index.isEven) {
                            var columnItem = posList[index ~/ 2];
                            var maxLength = (columnItem.length / numRow).ceil();
                            return Column(
                              children: List.generate(maxLength, (innerIndex) {
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: List.generate(numRow, (rowIndex) {
                                    var itemPos =
                                        innerIndex * numRow + rowIndex;
                                    if (itemPos >= columnItem.length) {
                                      return const Expanded(
                                        child: SizedBox.shrink(),
                                      );
                                    }
                                    return Expanded(
                                      child: IgnorePointer(
                                        child: ViewChoiceNode(
                                          Pos(data: columnItem[itemPos]),
                                          ignoreOpacity: true,
                                          ignoreOption: ref
                                                  .watch(separateChildProvider)
                                              ? ChoiceNodeChildRender.onlySelf
                                              : ChoiceNodeChildRender.selected,
                                        ),
                                      ),
                                    );
                                  }),
                                );
                              }),
                            );
                          }
                          return const Padding(
                            padding: EdgeInsets.all(8.0),
                          );
                        }),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
      actions: [
        TextButton(
          onPressed: () {
            saveAsImage(globalKey);
          },
          child: Text('save_as_image'.i18n),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('confirm'.i18n),
        ),
      ],
    );
  }
}
