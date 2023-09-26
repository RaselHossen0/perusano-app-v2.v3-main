// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weightHeightClass.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeightHeightRegister _$WeightHeightRegisterFromJson(
        Map<String, dynamic> json) =>
    WeightHeightRegister(
      json['idKid'] as int,
      json['idLocalKid'] as int,
      json['id'] as int,
      (json['weight'] as num).toDouble(),
      (json['height'] as num).toDouble(),
      json['date'] as String,
      json['dateRaw'] as String,
      json['age'] as int,
      json['lengthDiagnostic'] as String,
      json['lengthDiagnosticNumber'] as int,
      json['weightForLengthDiagnostic'] as String,
      json['weightForLengthDiagnosticNumber'] as int,
      json['wasChanged'] as bool,
      json['wasRemove'] as bool,
    )..idLocal = json['idLocal'] as int;

Map<String, dynamic> _$WeightHeightRegisterToJson(
        WeightHeightRegister instance) =>
    <String, dynamic>{
      'idKid': instance.idKid,
      'idLocalKid': instance.idLocalKid,
      'id': instance.id,
      'idLocal': instance.idLocal,
      'weight': instance.weight,
      'height': instance.height,
      'date': instance.date,
      'dateRaw': instance.dateRaw,
      'age': instance.age,
      'lengthDiagnostic': instance.lengthDiagnostic,
      'lengthDiagnosticNumber': instance.lengthDiagnosticNumber,
      'weightForLengthDiagnostic': instance.weightForLengthDiagnostic,
      'weightForLengthDiagnosticNumber':
          instance.weightForLengthDiagnosticNumber,
      'wasChanged': instance.wasChanged,
      'wasRemove': instance.wasRemove,
    };
