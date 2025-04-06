List<int> _versionParse(String version) {
  return version.replaceFirst('v', '').split('.').map((e) => int.parse(e)).toList();
}

int versionCheck(String versionA, String versionB) {
  var vA = _versionParse(versionA);
  var vB = _versionParse(versionB);
  for (int i = 0; i < 3; i++) {
    if (vA[i] > vB[i]) return 1;
    if (vA[i] < vB[i]) return -1;
  }

  return 0;
}
