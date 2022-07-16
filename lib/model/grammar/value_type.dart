import 'analyser.dart';

class ValueType {
  dynamic data;

  ValueType(this.data) {
    if (data is ValueType) {
      throw Error();
    }
  }

  dynamic dataUnzip() {
    if (data == null) return null;
    return data;
  }

  @override
  String toString() {
    if (data is String && Analyser().functionList.hasFunction(data)) {
      return data;
    }
    return 'ValueType|$data';
  }

  ValueType.fromJson(Map<String, dynamic> json) {
    switch (json['type']) {
      case 'int':
        data = int.tryParse(json['data']);
        break;
      case 'double':
        data = double.tryParse(json['data']);
        break;
      case 'bool':
        data = json['data'] == 'true';
        break;
      case 'String':
        data = json['data'] as String;
        break;
    }
  }

  Map<String, dynamic> toJson() => {
        'data': data.toString(),
        'type': data.runtimeType.toString(),
      };
}

class ValueTypeWrapper {
  ValueType valueType;
  bool visible;
  bool isGlobal;
  String displayName;

  ValueTypeWrapper(this.valueType, this.visible,
      {this.displayName = '', this.isGlobal = true});

  ValueTypeWrapper.normal(this.valueType, this.isGlobal)
      : visible = false,
        displayName = '';

  ValueTypeWrapper.copy(ValueTypeWrapper other)
      : visible = other.visible,
        isGlobal = other.isGlobal,
        displayName = other.displayName,
        valueType = other.valueType;

  ValueTypeWrapper.fromJson(Map<String, dynamic> json)
      : valueType = ValueType.fromJson(json['valueType']),
        visible = json['visible'] == 'true',
        isGlobal = json['isGlobal'] ?? true,
        displayName = json['displayName'] ?? '';

  Map<String, dynamic> toJson() => {
        'visible': visible.toString().toLowerCase(),
        'valueType': valueType.toJson(),
        'displayName': displayName,
        'isGlobal': isGlobal,
      };

  @override
  String toString() {
    return '( $valueType |{$visible : $isGlobal} )';
  }
}
