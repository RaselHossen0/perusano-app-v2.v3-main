// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'eventClass.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventRegister _$EventRegisterFromJson(Map<String, dynamic> json) =>
    EventRegister(
      json['idFamily'] as int,
      json['id'] as int,
      json['date'] as String,
      json['formattedDate'] as String,
      json['formattedTime'] as String,
      json['description'] as String,
      json['isRecurrent'] as bool,
    )..idLocal = json['idLocal'] as int;

Map<String, dynamic> _$EventRegisterToJson(EventRegister instance) =>
    <String, dynamic>{
      'idFamily': instance.idFamily,
      'id': instance.id,
      'idLocal': instance.idLocal,
      'date': instance.date,
      'formattedDate': instance.formattedDate,
      'formattedTime': instance.formattedTime,
      'description': instance.description,
      'isRecurrent': instance.isRecurrent,
    };
