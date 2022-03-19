import 'package:flutter/foundation.dart';
import 'package:github/github.dart';

import '../main.dart';
import '../util/version.dart';

class CheckUpdate {
  static Future<bool> needUpdateCheck() async {
    var github = GitHub();

    var lastRelease = await github.repositories
        .listReleases(RepositorySlug('n7484443', 'FlutterCyoap'))
        .first;
    if (kDebugMode) {
      print(
          '마지막 업데이트 버전 : ${lastRelease.tagName} | 현제 버전 : v${ConstList.version}');
    }
    if (lastRelease.tagName == null) return false;
    if (ConstList.version == '') return false;
    if (versionCheck(lastRelease.tagName!, ConstList.version) > 0) {
      return true;
    }
    return false;
  }
}
