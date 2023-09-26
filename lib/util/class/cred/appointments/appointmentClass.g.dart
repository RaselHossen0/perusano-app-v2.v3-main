// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointmentClass.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppointmentRegister _$AppointmentRegisterFromJson(Map<String, dynamic> json) =>
    AppointmentRegister(
      json['idKid'] as int,
      json['idLocalKid'] as int,
      json['id'] as int,
      json['date_format'] as String,
      json['date'] as String,
      json['attendanceDate'] as String?,
      json['attendanceDate_format'] as String?,
      json['description'] as String,
      json['state_value'] as String,
      json['state_id'] as int,
      json['wasChanged'] as bool,
      json['wasRemove'] as bool,
    )..idLocal = json['idLocal'] as int;

Map<String, dynamic> _$AppointmentRegisterToJson(
        AppointmentRegister instance) =>
    <String, dynamic>{
      'idKid': instance.idKid,
      'idLocalKid': instance.idLocalKid,
      'id': instance.id,
      'idLocal': instance.idLocal,
      'date_format': instance.date_format,
      'date': instance.date,
      'attendanceDate': instance.attendanceDate,
      'attendanceDate_format': instance.attendanceDate_format,
      'description': instance.description,
      'state_value': instance.state_value,
      'state_id': instance.state_id,
      'wasChanged': instance.wasChanged,
      'wasRemove': instance.wasRemove,
    };
