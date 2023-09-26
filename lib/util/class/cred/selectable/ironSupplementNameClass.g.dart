// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ironSupplementNameClass.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IronSupplementNameRegister _$IronSupplementNameRegisterFromJson(
        Map<String, dynamic> json) =>
    IronSupplementNameRegister(
      json['id'] as int,
      json['label'] as String,
      json['type'] as Map<String, dynamic>,
      json['wasChanged'] as bool,
      json['wasRemove'] as bool,
    )..idLocal = json['idLocal'] as int;

Map<String, dynamic> _$IronSupplementNameRegisterToJson(
        IronSupplementNameRegister instance) =>
    <String, dynamic>{
      'id': instance.id,
      'idLocal': instance.idLocal,
      'label': instance.label,
      'type': instance.type,
      'wasChanged': instance.wasChanged,
      'wasRemove': instance.wasRemove,
    };
