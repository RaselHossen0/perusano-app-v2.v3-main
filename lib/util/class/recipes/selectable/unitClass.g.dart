// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unitClass.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UnitRegister _$UnitRegisterFromJson(Map<String, dynamic> json) => UnitRegister(
      json['id'] as int,
      json['value'] as String,
    )..idLocal = json['idLocal'] as int;

Map<String, dynamic> _$UnitRegisterToJson(UnitRegister instance) =>
    <String, dynamic>{
      'id': instance.id,
      'idLocal': instance.idLocal,
      'value': instance.value,
    };
