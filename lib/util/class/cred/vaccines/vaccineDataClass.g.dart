// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vaccineDataClass.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VaccineDataRegister _$VaccineDataRegisterFromJson(Map<String, dynamic> json) =>
    VaccineDataRegister(
      json['id'] as int,
      json['name'] as String,
      json['description'] as String,
      json['totalDosis'] as int,
      json['timeDosis'] as List<dynamic>,
      json['wasChanged'] as bool,
      json['wasRemove'] as bool,
    )..idLocal = json['idLocal'] as int;

Map<String, dynamic> _$VaccineDataRegisterToJson(
        VaccineDataRegister instance) =>
    <String, dynamic>{
      'id': instance.id,
      'idLocal': instance.idLocal,
      'name': instance.name,
      'description': instance.description,
      'totalDosis': instance.totalDosis,
      'timeDosis': instance.timeDosis,
      'wasChanged': instance.wasChanged,
      'wasRemove': instance.wasRemove,
    };
