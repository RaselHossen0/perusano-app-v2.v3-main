// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stepClass.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

stepRegister _$stepRegisterFromJson(Map<String, dynamic> json) => stepRegister(
      json['id'] as int,
      json['description'] as String,
    )..idLocal = json['idLocal'] as int;

Map<String, dynamic> _$stepRegisterToJson(stepRegister instance) =>
    <String, dynamic>{
      'id': instance.id,
      'idLocal': instance.idLocal,
      'description': instance.description,
    };
