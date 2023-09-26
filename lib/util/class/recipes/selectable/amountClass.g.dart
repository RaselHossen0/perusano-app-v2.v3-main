// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'amountClass.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AmountRegister _$AmountRegisterFromJson(Map<String, dynamic> json) =>
    AmountRegister(
      json['id'] as int,
      json['value'] as String,
    )..idLocal = json['idLocal'] as int;

Map<String, dynamic> _$AmountRegisterToJson(AmountRegister instance) =>
    <String, dynamic>{
      'id': instance.id,
      'idLocal': instance.idLocal,
      'value': instance.value,
    };
