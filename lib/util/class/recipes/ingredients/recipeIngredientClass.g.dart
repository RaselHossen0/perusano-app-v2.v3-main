// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipeIngredientClass.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecipeIngredientRegister _$RecipeIngredientRegisterFromJson(
        Map<String, dynamic> json) =>
    RecipeIngredientRegister(
      json['id'] as int,
      json['name'] as String,
      json['amount'] as String,
      json['unit'] as String,
      json['alternatives'] as List<dynamic>,
    )..idLocal = json['idLocal'] as int;

Map<String, dynamic> _$RecipeIngredientRegisterToJson(
        RecipeIngredientRegister instance) =>
    <String, dynamic>{
      'id': instance.id,
      'idLocal': instance.idLocal,
      'name': instance.name,
      'amount': instance.amount,
      'unit': instance.unit,
      'alternatives': instance.alternatives,
    };
