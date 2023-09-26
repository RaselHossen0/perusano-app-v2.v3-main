// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipeCategoryClass.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecipeCategoryRegister _$RecipeCategoryRegisterFromJson(
        Map<String, dynamic> json) =>
    RecipeCategoryRegister(
      json['id'] as int,
      json['value'] as String,
    )..idLocal = json['idLocal'] as int;

Map<String, dynamic> _$RecipeCategoryRegisterToJson(
        RecipeCategoryRegister instance) =>
    <String, dynamic>{
      'id': instance.id,
      'idLocal': instance.idLocal,
      'value': instance.value,
    };
