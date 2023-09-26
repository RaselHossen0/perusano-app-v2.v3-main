// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipeClass.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecipeRegister _$RecipeRegisterFromJson(Map<String, dynamic> json) =>
    RecipeRegister(
      json['id'] as int,
      json['title'] as String,
      json['total_likes'] as int,
      json['author_name'] as String,
      json['author_id'] as int,
      json['preparation'] as List<dynamic>,
      json['comments'] as List<dynamic>,
      json['ingredients'] as List<dynamic>,
      json['status'] as String,
      json['statusId'] as int,
      json['age_tag'] as Map<String, dynamic>,
      json['is_liked_by_me'] as bool,
      json['url_photo'] as String,
      json['url_video'] as String,
    )..idLocal = json['idLocal'] as int;

Map<String, dynamic> _$RecipeRegisterToJson(RecipeRegister instance) =>
    <String, dynamic>{
      'id': instance.id,
      'idLocal': instance.idLocal,
      'title': instance.title,
      'total_likes': instance.totalLikes,
      'author_name': instance.authorName,
      'author_id': instance.authorId,
      'preparation': instance.preparation,
      'comments': instance.comments,
      'ingredients': instance.ingredients,
      'status': instance.status,
      'statusId': instance.statudId,
      'age_tag': instance.ageTag,
      'is_liked_by_me': instance.isLikedByMe,
      'url_photo': instance.urlPhoto,
      'url_video': instance.urlVideo,
    };
