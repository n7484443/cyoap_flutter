String getCloneName(String name, bool Function(String name) hasName) {
  var newName = name;
  int i = 0;
  while (hasName(newName)) {
    i++;
    newName = "${name}_$i";
  }
  return newName;
}
