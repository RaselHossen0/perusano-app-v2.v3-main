// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingredientClass.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IngredientRegister _$IngredientRegisterFromJson(Map<String, dynamic> json) =>
    IngredientRegister(
      json['id'] as int,
      json['value'] as String,
    )..idLocal = json['idLocal'] as int;

Map<String, dynamic> _$IngredientRegisterToJson(IngredientRegister instance) =>
    <String, dynamic>{
      'id': instance.id,
      'idLocal': instance.idLocal,
      'value': instance.value,
    };
