import 'package:flutter/foundation.dart';
import 'package:github/github.dart';

import '../main.dart';
import 'version.dart';

class CheckUpdate {
  static Future<Release?> getLatestRelease() async {
    var github = GitHub();
    Release lastRelease;
    try {
      lastRelease = await github.repositories
          .listReleases(RepositorySlug('n7484443', 'cyoap_flutter'))
          .first;
    } catch (e) {
      return null;
    }
    return lastRelease;
  }

  static Future<String?> needUpdateCheck() async {
    var lastRelease = await getLatestRelease();
    if (lastRelease == null) {
      return null;
    }
    if (kDebugMode) {
      print(
          '마지막 업데이트 버전 : ${lastRelease.tagName} | 현제 버전 : v${ConstList.version}');
    }
    if (lastRelease.tagName == null) return null;
    if (ConstList.version == '') return null;
    if (versionCheck(lastRelease.tagName!, ConstList.version) > 0) {
      return lastRelease.tagName;
    }
    return null;
  }
}
