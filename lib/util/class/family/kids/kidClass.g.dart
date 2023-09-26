// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kidClass.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KidRegister _$KidRegisterFromJson(Map<String, dynamic> json) => KidRegister(
      json['id'] as int,
      json['names'] as String,
      json['lastname'] as String,
      json['mother_lastname'] as String,
      json['birthday'] as String,
      json['dateRaw'] as String,
      json['gender'] as int,
      json['afiliateCode'] as String,
      json['url_photo'] as String,
      json['familyId'] as int,
      json['wasChanged'] as bool,
      json['wasRemove'] as bool,
    )..idLocal = json['idLocal'] as int;

Map<String, dynamic> _$KidRegisterToJson(KidRegister instance) =>
    <String, dynamic>{
      'idLocal': instance.idLocal,
      'id': instance.id,
      'names': instance.names,
      'lastname': instance.lastname,
      'mother_lastname': instance.mother_lastname,
      'birthday': instance.birthday,
      'dateRaw': instance.dateRaw,
      'gender': instance.gender,
      'afiliateCode': instance.afiliateCode,
      'url_photo': instance.url_photo,
      'familyId': instance.familyId,
      'wasChanged': instance.wasChanged,
      'wasRemove': instance.wasRemove,
    };
