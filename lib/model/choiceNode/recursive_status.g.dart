// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recursive_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecursiveStatus _$RecursiveStatusFromJson(Map<String, dynamic> json) =>
    RecursiveStatus(
      conditionClickableString: json['conditionClickableString'] as String?,
      conditionVisibleString: json['conditionVisibleString'] as String?,
      executeCodeString: json['executeCodeString'] as String?,
    )
      ..conditionClickableCode =
          (json['conditionClickableCode'] as List<dynamic>?)
                  ?.map((e) => e as String)
                  .toList() ??
              []
      ..conditionVisibleCode = (json['conditionVisibleCode'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          []
      ..executeCode = (json['executeCode'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [];

Map<String, dynamic> _$RecursiveStatusToJson(RecursiveStatus instance) =>
    <String, dynamic>{
      'conditionClickableCode': instance.conditionClickableCode,
      'conditionVisibleCode': instance.conditionVisibleCode,
      'executeCode': instance.executeCode,
      'conditionClickableString': instance.conditionClickableString,
      'conditionVisibleString': instance.conditionVisibleString,
      'executeCodeString': instance.executeCodeString,
    };
