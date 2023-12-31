import 'dart:typed_data';

import 'package:cyoap_flutter/i18n.dart';
import 'package:cyoap_flutter/model/platform_system.dart';
import 'package:cyoap_flutter/util/platform_specified_util/platform_specified.dart';
import 'package:cyoap_flutter/viewModel/vm_choice_node.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../main.dart';
import '../model/device_preference.dart';

final playDataProvider = StateNotifierProvider<PlayDataNotifier, void>(
    (ref) => PlayDataNotifier(ref));

class PlayDataNotifier extends StateNotifier<void> {
  Ref ref;
  PlayDataNotifier(this.ref) : super("");

  Future<String> savePlayData() async {
    var json = getPlatform.getSelectedPosInternal();
    var saveProject = PlatformSpecified().saveProject!;
    var data = Uint8List.fromList(json.codeUnits);

    if (ConstList.isWeb()) {
      await saveProject.downloadCapture('', 'save.json', data);
      return 'save_web'.i18n;
    } else {
      var path = await DevicePreference.getDownloadFolder();
      await saveProject.downloadCapture(path, 'save.json', data);
      return 'save_non_web'.i18n.fill([path]);
    }
  }

  Future<String?> loadPlayData() async {
    var selected = await FilePicker.platform.pickFiles(
        type: FileType.custom, allowedExtensions: ['json'], withData: true);
    if (selected == null) {
      return 'no_file_selected'.i18n;
    }
    var bytes = selected.files[0].bytes;
    var string = String.fromCharCodes(bytes!);
    getPlatform.setSelectedPosInternal(string);
    updateStatus(ref);
    return null;
  }
}
