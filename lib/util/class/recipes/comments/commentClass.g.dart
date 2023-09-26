// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'commentClass.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentRegister _$CommentRegisterFromJson(Map<String, dynamic> json) =>
    CommentRegister(
      json['id'] as int,
      json['comment'] as String,
      json['author'] as Map<String, dynamic>,
      json['total_likes'] as int,
      json['is_liked_by_me'] as bool,
    )..idLocal = json['idLocal'] as int;

Map<String, dynamic> _$CommentRegisterToJson(CommentRegister instance) =>
    <String, dynamic>{
      'id': instance.id,
      'idLocal': instance.idLocal,
      'comment': instance.comment,
      'author': instance.author,
      'total_likes': instance.total_likes,
      'is_liked_by_me': instance.is_liked_by_me,
    };
