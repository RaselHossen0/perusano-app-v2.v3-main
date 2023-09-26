// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'familyMemberClass.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FamilyMemberRegister _$FamilyMemberRegisterFromJson(
        Map<String, dynamic> json) =>
    FamilyMemberRegister(
      json['id'] as int,
      json['dni'] as String,
      json['name'] as String,
      json['lastname'] as String,
      json['mother_lastname'] as String,
      json['relationship'] as String,
      json['cellphone'] as String,
      json['phone'] as String,
      json['occupation'] as String,
      json['email'] as String,
      json['is_caregiver'] as bool,
      json['url_photo'] as String,
      json['familyId'] as int,
      json['wasChanged'] as bool,
      json['wasRemove'] as bool,
    )..idLocal = json['idLocal'] as int;

Map<String, dynamic> _$FamilyMemberRegisterToJson(
        FamilyMemberRegister instance) =>
    <String, dynamic>{
      'idLocal': instance.idLocal,
      'id': instance.id,
      'dni': instance.dni,
      'name': instance.name,
      'lastname': instance.lastname,
      'mother_lastname': instance.mother_lastname,
      'relationship': instance.relationship,
      'cellphone': instance.cellphone,
      'phone': instance.phone,
      'occupation': instance.occupation,
      'email': instance.email,
      'is_caregiver': instance.is_caregiver,
      'url_photo': instance.url_photo,
      'familyId': instance.familyId,
      'wasChanged': instance.wasChanged,
      'wasRemove': instance.wasRemove,
    };
