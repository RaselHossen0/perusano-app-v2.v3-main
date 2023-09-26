// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shared_experience_class.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SharedExperienceRegister _$SharedExperienceRegisterFromJson(
        Map<String, dynamic> json) =>
    SharedExperienceRegister(
      json['id'] as int,
      json['title'] as String,
      json['author_name'] as String,
      json['author_id'] as int,
      json['post_content'] as String,
      json['post_date'] as String,
      json['comments'] as List<dynamic>,
    )..idLocal = json['idLocal'] as int;

Map<String, dynamic> _$SharedExperienceRegisterToJson(
        SharedExperienceRegister instance) =>
    <String, dynamic>{
      'id': instance.id,
      'idLocal': instance.idLocal,
      'title': instance.title,
      'author_name': instance.authorName,
      'author_id': instance.authorId,
      'post_content': instance.postContent,
      'post_date': instance.postDate,
      'comments': instance.comments,
    };
