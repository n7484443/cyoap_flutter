import 'dart:async';

import 'package:cyoap_flutter/viewModel/vm_draggable_nested_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/platform_system.dart';

final stopWatchProvider =
    StateNotifierProvider<SaveStopWatch, String>((ref) => SaveStopWatch());

class SaveStopWatch extends StateNotifier<String> {
  SaveStopWatch() : super("");
  Stopwatch stopwatch = Stopwatch();
  Timer? timer;

  void start() {
    stopwatch.reset();
    stopwatch.start();
    timer = Timer.periodic(const Duration(milliseconds: 10), (Timer timer) {
      state = stopwatch.elapsed.toString();
    });
  }

  void stop() {
    timer?.cancel();
    stopwatch.stop();
  }
}

Future<void> savePlatform(WidgetRef ref, bool asZip) async {
  ref.read(stopWatchProvider.notifier).start();

  getPlatform.checkDataCorrect();
  getPlatform.generateRecursiveParser();

  await getPlatformFileSystem.save(asZip);
  ref.read(stopWatchProvider.notifier).stop();
  ref.read(draggableNestedMapChangedProvider.notifier).state = false;
}
