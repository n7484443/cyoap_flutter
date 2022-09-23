import 'package:cyoap_flutter/view/view_draggable_nested_map.dart';
import 'package:cyoap_flutter/view/view_variable_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewModel/vm_snackbar.dart';

class ViewPlay extends ConsumerStatefulWidget {
  const ViewPlay({
    super.key,
  });

  @override
  ConsumerState createState() => _ViewPlayState();
}

class _ViewPlayState extends ConsumerState<ViewPlay> {
  void _showSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children:
                ref.watch(snackBarErrorProvider).map((e) => Text(e)).toList(),
          ),
        ),
        action: SnackBarAction(
          label: '클립보드로 복사',
          onPressed: () {
            Clipboard.setData(ClipboardData(
                text: ref.watch(snackBarErrorProvider).fold(
                      "",
                      (previousValue, element) => "$previousValue \n $element",
                    )));
            ref.read(snackBarErrorProvider.notifier).clear();
          },
        ),
        duration: const Duration(days: 365),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(
      snackBarErrorProvider,
      (previous, List<String> next) {
        if (next.isNotEmpty) {
          _showSnackBar();
        }
      },
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pushReplacementNamed("/"),
        ),
      ),
      endDrawer: const Drawer(
        child: ViewPlayDrawer(),
      ),
      bottomNavigationBar: const VariableTiles(asBottom: true),
      body: const NestedScroll(),
    );
  }
}
