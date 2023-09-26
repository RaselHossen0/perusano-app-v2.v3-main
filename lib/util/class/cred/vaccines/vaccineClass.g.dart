// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vaccineClass.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VaccineRegister _$VaccineRegisterFromJson(Map<String, dynamic> json) =>
    VaccineRegister(
      json['idKid'] as int,
      json['idLocalKid'] as int,
      json['id'] as int,
      json['name'] as String,
      json['dosis'] as List<dynamic>,
    );

Map<String, dynamic> _$VaccineRegisterToJson(VaccineRegister instance) =>
    <String, dynamic>{
      'idKid': instance.idKid,
      'idLocalKid': instance.idLocalKid,
      'id': instance.id,
      'name': instance.name,
      'dosis': instance.dosis,
    };
