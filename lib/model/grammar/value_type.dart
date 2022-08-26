import 'package:flutter/material.dart';

@immutable
class ValueType {
  final dynamic data;

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
    return data.toString();
  }

  ValueType.fromJson(Map<String, dynamic> json)
      : data = json['type'] == 'int'
            ? int.tryParse(json['data'])
            : json['type'] == 'double'
                ? double.tryParse(json['data'])
                : json['type'] == 'bool'
                    ? json['data'] == 'true'
                    : json['data'] as String;

  Map<String, dynamic> toJson() => {
        'data': data.toString(),
        'type': data.runtimeType.toString(),
      };
}

@immutable
class ValueTypeWrapper {
  final ValueType valueType;
  final bool visible;
  final bool isGlobal;
  final String displayName;

  const ValueTypeWrapper(this.valueType,
      {this.visible = false, this.displayName = '', this.isGlobal = true});

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

  ValueTypeWrapper copyWith(
      {ValueType? valueType,
      bool? visible,
      String? displayName,
      bool? isGlobal}) {
    return ValueTypeWrapper(valueType ?? this.valueType,
        visible: visible ?? this.visible,
        displayName: displayName ?? this.displayName,
        isGlobal: isGlobal ?? this.isGlobal);
  }
}
