import 'dart:async';

import 'package:cyoap_flutter/viewModel/vm_draggable_nested_map.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/platform_system.dart';
import '../util/platform_specified_util/platform_specified.dart';

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

final loadStringProvider = StateProvider<String>((ref) => '');
final loadedProvider = StateProvider<bool>((ref) => false);

Future<void> doDistributeMode(WidgetRef ref) async {
  ref.read(stopWatchProvider.notifier).start();

  if (kDebugMode) {
    print('web is Distribute mode');
  }

  ref.read(loadStringProvider.notifier).state = '[ 로드 시작 ]';
  var nodeList = await PlatformSpecified().distribute!.getNodeList();
  if (kDebugMode) {
    print('load start');
  }
  ref.read(loadStringProvider.notifier).state = '[ 선택지 로드중 ]';
  List<Future> futureMap = List.empty(growable: true);
  Map<String, String> nodeMap = {};
  var time = DateTime.now().toIso8601String();
  for (var name in nodeList) {
    var future = PlatformSpecified()
        .distribute!
        .getFileAsJson('nodes/$name?preventCache=$time');
    future.then((value) => nodeMap[name] = value);
    futureMap.add(future);
  }
  await Future.wait(futureMap);

  ref.read(loadStringProvider.notifier).state = '[ 구조 생성중 ]';
  if (kDebugMode) {
    print('node loaded');
  }

  String imageSource = await PlatformSpecified()
      .distribute!
      .getFileAsJson('imageSource.json?preventCache=$time');
  String platformData = await PlatformSpecified()
      .distribute!
      .getFileAsJson('platform.json?preventCache=$time');
  ref.read(loadStringProvider.notifier).state = '[ 로드 완료 ]';
  if (kDebugMode) {
    print('load end');
  }
  ref.read(stopWatchProvider.notifier).stop();

  await PlatformSystem().openPlatformList(nodeMap, imageSource, platformData);
  getPlatformFileSystem.isEditable = false;
  ref.read(loadedProvider.notifier).state = true;
}

Future<void> savePlatform(WidgetRef ref, bool asZip) async {
  ref.read(stopWatchProvider.notifier).start();

  getPlatform.compress();
  getPlatform.generateRecursiveParser();

  await getPlatformFileSystem.save(asZip);
  ref.read(stopWatchProvider.notifier).stop();
  ref.read(draggableNestedMapChangedProvider.notifier).state = false;
}
