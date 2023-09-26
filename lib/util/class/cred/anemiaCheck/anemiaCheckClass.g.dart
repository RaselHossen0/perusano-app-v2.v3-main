// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'anemiaCheckClass.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnemiaCheckRegister _$AnemiaCheckRegisterFromJson(Map<String, dynamic> json) =>
    AnemiaCheckRegister(
      json['idKid'] as int,
      json['idLocalKid'] as int,
      json['id'] as int,
      (json['result'] as num).toDouble(),
      json['date'] as String,
      json['dateRaw'] as String,
      json['age'] as int,
      json['wasChanged'] as bool,
      json['wasRemove'] as bool,
    )..idLocal = json['idLocal'] as int;

Map<String, dynamic> _$AnemiaCheckRegisterToJson(
        AnemiaCheckRegister instance) =>
    <String, dynamic>{
      'idKid': instance.idKid,
      'idLocalKid': instance.idLocalKid,
      'id': instance.id,
      'idLocal': instance.idLocal,
      'result': instance.result,
      'date': instance.date,
      'dateRaw': instance.dateRaw,
      'age': instance.age,
      'wasChanged': instance.wasChanged,
      'wasRemove': instance.wasRemove,
    };
