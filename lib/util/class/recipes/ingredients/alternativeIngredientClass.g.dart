// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alternativeIngredientClass.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AlternativeIngredientRegister _$AlternativeIngredientRegisterFromJson(
        Map<String, dynamic> json) =>
    AlternativeIngredientRegister(
      json['id'] as int,
      json['name'] as String,
      json['amount'] as String,
      json['unit'] as String,
    )..idLocal = json['idLocal'] as int;

Map<String, dynamic> _$AlternativeIngredientRegisterToJson(
        AlternativeIngredientRegister instance) =>
    <String, dynamic>{
      'id': instance.id,
      'idLocal': instance.idLocal,
      'name': instance.name,
      'amount': instance.amount,
      'unit': instance.unit,
    };
