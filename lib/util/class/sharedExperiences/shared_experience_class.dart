import 'package:json_annotation/json_annotation.dart';

/// Esto permite a la clase `User` acceder a las propiedades privadas
/// en el fichero generado. El valor para esto es *.g.dart, donde
/// el asterisco denota el nombre del fichero fuente.
part 'shared_experience_class.g.dart';

/// Una anotación para el auto-generador de código para que sepa que en esta clase
/// necesita generarse lógica de serialización JSON.
@JsonSerializable()
class SharedExperienceRegister {
  SharedExperienceRegister(
    this.id,
    this.title,
    this.authorName,
    this.authorId,
    this.postContent,
    this.postDate,
    this.comments,
  );

  int id;
  int idLocal = 1;
  String title;
  String authorName;
  int authorId;
  String postContent;
  String postDate;
  List comments;

  /// Un método constructor de tipo factory es necesario para crear una nueva instancia User
  /// desde un mapa. Pasa el mapa al constructor auto-generado `_$UserFromJson()`.
  /// El constructor es nombrado después de la clase fuente, en este caso User.
  factory SharedExperienceRegister.fromJson(Map<String, dynamic> json) =>
      _$SharedExperienceRegisterFromJson(json);

  /// `toJson` es la convención para una clase declarar que soporta serialización
  /// a JSON. La implementación simplemente llama al método de ayuda privado
  /// `_$UserToJson`.
  Map<String, dynamic> toJson() => _$SharedExperienceRegisterToJson(this);
}
