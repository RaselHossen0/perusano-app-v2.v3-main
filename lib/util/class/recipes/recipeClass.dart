import 'package:json_annotation/json_annotation.dart';

/// Esto permite a la clase `User` acceder a las propiedades privadas
/// en el fichero generado. El valor para esto es *.g.dart, donde
/// el asterisco denota el nombre del fichero fuente.
part 'recipeClass.g.dart';

/// Una anotación para el auto-generador de código para que sepa que en esta clase
/// necesita generarse lógica de serialización JSON.
@JsonSerializable()
class RecipeRegister {
  RecipeRegister(
      this.id,
      this.title,
      this.totalLikes,
      this.authorName,
      this.authorId,
      this.preparation,
      this.comments,
      this.ingredients,
      this.status,
      this.statudId,
      this.ageTag,
      this.isLikedByMe,
      this.urlPhoto,
      this.urlVideo);

  int id;
  int idLocal = 1;
  String title;
  int totalLikes;
  String authorName;
  int authorId;
  List preparation;
  List comments;
  List ingredients;
  String status;
  int statudId;
  Map ageTag;
  bool isLikedByMe;
  String urlPhoto;
  String urlVideo;

  /// Un método constructor de tipo factory es necesario para crear una nueva instancia User
  /// desde un mapa. Pasa el mapa al constructor auto-generado `_$UserFromJson()`.
  /// El constructor es nombrado después de la clase fuente, en este caso User.
  factory RecipeRegister.fromJson(Map<String, dynamic> json) =>
      _$RecipeRegisterFromJson(json);

  /// `toJson` es la convención para una clase declarar que soporta serialización
  /// a JSON. La implementación simplemente llama al método de ayuda privado
  /// `_$UserToJson`.
  Map<String, dynamic> toJson() => _$RecipeRegisterToJson(this);
}
