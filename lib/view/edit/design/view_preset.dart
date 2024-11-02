import 'package:cyoap_flutter/i18n.dart';
import 'package:cyoap_flutter/view/edit/design/view_choice_line_preset.dart';
import 'package:cyoap_flutter/view/edit/design/view_choice_node_preset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../main.dart';
import '../../../viewModel/edit/preset/vm_preset.dart';
import '../../util/view_options.dart';

const double unitWidth = 300.0;
const double largeUnitWidth = unitWidth * 2.1;
class ViewPresetTab extends ConsumerWidget {
  final List<String> tabName = ['node', 'line'];

  ViewPresetTab({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var currentIndex = ref.watch(currentPresetTab);
    var first = CustomDropdownButton<String>(
      label: 'preset'.i18n,
      items: tabName.map((name) => DropdownMenuItem(value: name, child: Text(name.i18n))).toList(),
      value: tabName[currentIndex],
      useCard: false,
      onChanged: (value) {
        ref.read(currentPresetTab.notifier).state = tabName.indexOf(value!);
      },
    );
    // var first = ListView.builder(
    //   controller: ScrollController(),
    //   itemBuilder: (context, index) {
    //     return ListTile(
    //       title: Text(tabName[index]),
    //       selected: ref.watch(currentPresetTab) == index,
    //       onTap: () {
    //         ref.read(currentPresetTab.notifier).state = index;
    //       },
    //     );
    //   },
    //   itemCount: tabName.length,
    // );
    if (currentIndex == 0) {
      return ViewPresetPosition(
        first: first,
        second: const ChoiceNodePresetList(),
        sample: const ChoiceNodeSample(),
        describe: const ViewNodeOptionEditor(),
      );
    }
    return ViewPresetPosition(
      first: first,
      second: const ChoiceLinePresetList(),
      sample: const ChoiceLineSample(),
      describe: const ViewLineOptionEditor(),
    );
  }
}

class ViewPresetPosition extends ConsumerStatefulWidget {
  final Widget first;
  final Widget second;
  final Widget describe;
  final Widget? sample;

  const ViewPresetPosition({required this.first, required this.second, required this.describe, required this.sample, super.key});

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
            widget.first,
            SizedBox(
              height: 200,
              child: widget.second,
            ),
            if (widget.sample != null) const Divider(height: 1),
            if (widget.sample != null)
              SizedBox(
                height: 300,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: SizedBox(
                    height: 320,
                    child: widget.sample!,
                  ),
                ),
              ),
            const Divider(height: 1),
            widget.describe,
          ],
        ),
      );
    }

    if (widget.sample != null) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                widget.first,
                Expanded(
                  flex: 5,
                  child: widget.second,
                ),
                const Divider(height: 2),
                SizedBox(
                  height: 300,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: widget.sample!,
                    ),
                  ),
                )
              ],
            ),
          ),
          const VerticalDivider(width: 2),
          Expanded(
            flex: 12,
            child: widget.describe,
          ),
        ],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: 2,
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
        const VerticalDivider(width: 2),
        Expanded(
          flex: 3,
          child: widget.describe,
        ),
      ],
    );
  }
}

class PresetRenameDialog extends ConsumerStatefulWidget {
  final String name;

  const PresetRenameDialog(
    this.name, {
    super.key,
  });

  @override
  ConsumerState createState() => _PresetRenameDialogState();
}

class _PresetRenameDialogState extends ConsumerState<PresetRenameDialog> {
  TextEditingController? controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.name);
  }

  @override
  void dispose() {
    super.dispose();
    controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: TextField(
        controller: controller,
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('cancel'.i18n)),
        TextButton(
            onPressed: () {
              Navigator.of(context).pop(controller?.text);
            },
            child: Text('save'.i18n)),
      ],
    );
  }
}
