import 'package:cyoap_flutter/view/preset/view_choice_node_preset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../main.dart';
import '../../viewModel/preset/vm_preset.dart';
import '../util/controller_adjustable_scroll.dart';

class ViewPresetTab extends ConsumerWidget {
  final List<String> tabName = ['선택지', '라인'];

  ViewPresetTab({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ViewPresetPosition(
      first: ListView.builder(
        controller: AdjustableScrollController(),
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(tabName[index]),
            selected: ref.watch(currentPresetTab) == index,
          );
        },
        itemCount: tabName.length,
      ),
      second: const ChoiceNodePresetList(),
      sample: const ChoiceNodeSample(),
      describe: const ViewNodeOptionEditor(),

    );
  }
}

class ViewPresetPosition extends ConsumerStatefulWidget {
  final Widget first;
  final Widget second;
  final Widget describe;
  final Widget? sample;

  const ViewPresetPosition({required this.first,
    required this.second,
    required this.describe,
    required this.sample, super.key});

  @override
  ConsumerState<ViewPresetPosition> createState() => _ViewPresetPositionState();
}

class _ViewPresetPositionState extends ConsumerState<ViewPresetPosition> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (ConstList.isSmallDisplay(context)) {
      return SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            SizedBox(
              height: 200,
              child: Row(
                children: [
                  Expanded(
                    child: widget.first,
                  ),
                  Expanded(
                    child: widget.second,
                  )
                ],
              ),
            ),
            if (widget.sample != null) widget.sample!,
            widget.describe,
          ],
        ),
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(children: [
            Expanded(
              child: widget.first,
            ),
            if (widget.sample != null)
              Expanded(
                child: widget.sample!,
              )
          ]),
        ),
        Expanded(
          child: widget.second,
        ),
        Expanded(flex: 4, child: widget.describe),
      ],
    );
  }
}