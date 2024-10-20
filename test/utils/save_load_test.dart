import 'dart:convert';
import 'dart:io';

import 'package:cyoap_core/choiceNode/choice_node.dart';
import 'package:cyoap_core/choiceNode/pos.dart';
import 'package:cyoap_flutter/model/platform.dart';
import 'package:cyoap_flutter/model/platform_file_system.dart';
import 'package:cyoap_flutter/model/platform_system.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:cyoap_flutter/util/platform_specified_util/platform_specified.dart'
deferred as platform_specified;

EditablePlatform createPlatform() {
  EditablePlatform platform = EditablePlatform.none();
  platform.addData(const Pos(data: [0, 0, 0]),
      ChoiceNode(title: "save load test 1", width: 12, contents: "testData 1"));
  platform.addData(
      const Pos(data: [0, 1, 0]),
      ChoiceNode(title: "save load test 2", width: 12, contents: "testData 2")
        ..conditionalCodeHandler.conditionVisibleString =
            "\$[save load test 1]");
  platform.updateStatus();
  platform.generateRecursiveParser();
  return platform;
}

bool checkSamePlatform(EditablePlatform a, EditablePlatform b) {
  var aData = jsonEncode(a.toJson());
  var bData = jsonEncode(b.toJson());
  return aData == bData;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await platform_specified.loadLibrary();
  platform_specified.PlatformUtil().platform.preInit();
  platform_specified.PlatformUtil().platform.init();
  test('save load zip', () async {
    var pathZip = "test\\utils\\save_load_folder\\extract.zip";
    var pathFolder = "test\\utils\\save_load_folder";
    File fileZip = File(pathZip);
    if (await fileZip.exists()) {
      await fileZip.delete();
    }
    EditablePlatform platform = createPlatform();
    PlatformFileSystem fileSystem = PlatformSystem.platformFileSystem;
    fileSystem.path = pathFolder;
    fileSystem.openAsFile = true;
    fileSystem.platform = platform;
    await fileSystem.save(true);
    var loadState = await PlatformSystem().openPlatformZip(fileZip);
    expect(loadState.state, ProjectState.success);
    expect(checkSamePlatform(platform, getPlatform), true);
  });

  test('save load folder', () async {
    var pathFolder = "test\\utils\\save_load_folder\\folder";
    Directory dir = Directory(pathFolder);
    if(await dir.exists()){
      await dir.delete(recursive: true);
    }
    await dir.create();
    EditablePlatform platform = createPlatform();
    PlatformFileSystem fileSystem = PlatformSystem.platformFileSystem;
    fileSystem.path = pathFolder;
    fileSystem.openAsFile = false;
    fileSystem.platform = platform;
    await fileSystem.save(false);
    var loadState = await PlatformSystem().openPlatformFolder(pathFolder);
    expect(loadState.state, ProjectState.success);
    expect(checkSamePlatform(platform, getPlatform), true);
  });
}
