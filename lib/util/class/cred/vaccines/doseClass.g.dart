// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doseClass.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DoseRegister _$DoseRegisterFromJson(Map<String, dynamic> json) => DoseRegister(
      json['id'] as int,
      json['dosis_number'] as int,
      json['applied_date'] as String?,
      json['applied_date_raw'] as String?,
      json['suggest_date_format'] as String,
      json['suggest_date'] as String,
      json['month'] as int,
      json['wasChanged'] as bool,
    )..idLocal = json['idLocal'] as int;

Map<String, dynamic> _$DoseRegisterToJson(DoseRegister instance) =>
    <String, dynamic>{
      'id': instance.id,
      'idLocal': instance.idLocal,
      'dosis_number': instance.dosis_number,
      'applied_date': instance.applied_date,
      'applied_date_raw': instance.applied_date_raw,
      'suggest_date_format': instance.suggest_date_format,
      'suggest_date': instance.suggest_date,
      'month': instance.month,
      'wasChanged': instance.wasChanged,
    };
