int versionCheck(String versionA, String versionB) {
  var vA = versionA
      .replaceFirst('v', '')
      .split('.')
      .map((e) => int.parse(e))
      .toList();
  var vB = versionB
      .replaceFirst('v', '')
      .split('.')
      .map((e) => int.parse(e))
      .toList();
  for (int i = 0; i < 3; i++) {
    if (vA[i] > vB[i]) return 1;
    if (vA[i] < vB[i]) return -1;
  }

  return 0;
}
