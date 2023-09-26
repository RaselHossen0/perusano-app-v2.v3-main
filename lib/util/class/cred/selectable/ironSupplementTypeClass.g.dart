// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ironSupplementTypeClass.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IronSupplementTypeRegister _$IronSupplementTypeRegisterFromJson(
        Map<String, dynamic> json) =>
    IronSupplementTypeRegister(
      json['id'] as int,
      json['label'] as String,
      json['wasChanged'] as bool,
      json['wasRemove'] as bool,
    )..idLocal = json['idLocal'] as int;

Map<String, dynamic> _$IronSupplementTypeRegisterToJson(
        IronSupplementTypeRegister instance) =>
    <String, dynamic>{
      'id': instance.id,
      'idLocal': instance.idLocal,
      'label': instance.label,
      'wasChanged': instance.wasChanged,
      'wasRemove': instance.wasRemove,
    };
