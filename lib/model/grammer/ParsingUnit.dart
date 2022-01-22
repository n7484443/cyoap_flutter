class ParsingUnit {
  int type;
  String data;

  ParsingUnit(this.type, this.data);
  ParsingUnit changeUnitType(int newType) {
    return ParsingUnit(newType, data);
  }

  ParsingUnit addUnitData(String newData) {
    return ParsingUnit(type, data + newData);
  }
}
