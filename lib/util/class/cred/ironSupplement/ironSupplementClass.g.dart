// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ironSupplementClass.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IronSupplementRegister _$IronSupplementRegisterFromJson(
        Map<String, dynamic> json) =>
    IronSupplementRegister(
      json['idKid'] as int,
      json['idLocalKid'] as int,
      json['id'] as int,
      json['name'] as String,
      json['nameId'] as int,
      json['type'] as String,
      json['dosage'] as Map<String, dynamic>,
      json['deliveryDate'] as String,
      json['dateRaw'] as String,
      json['wasChanged'] as bool,
      json['wasRemove'] as bool,
    )..idLocal = json['idLocal'] as int;

Map<String, dynamic> _$IronSupplementRegisterToJson(
        IronSupplementRegister instance) =>
    <String, dynamic>{
      'idKid': instance.idKid,
      'idLocalKid': instance.idLocalKid,
      'id': instance.id,
      'idLocal': instance.idLocal,
      'name': instance.name,
      'nameId': instance.nameId,
      'type': instance.type,
      'dosage': instance.dosage,
      'deliveryDate': instance.deliveryDate,
      'dateRaw': instance.dateRaw,
      'wasChanged': instance.wasChanged,
      'wasRemove': instance.wasRemove,
    };
