import 'package:json_annotation/json_annotation.dart';

/// Esto permite a la clase `User` acceder a las propiedades privadas
/// en el fichero generado. El valor para esto es *.g.dart, donde
/// el asterisco denota el nombre del fichero fuente.
part 'kidClass.g.dart';

/// Una anotación para el auto-generador de código para que sepa que en esta clase
/// necesita generarse lógica de serialización JSON.
@JsonSerializable()


class KidRegister {

  KidRegister(this.id, this.names, this.lastname, this.mother_lastname, this.birthday, this.dateRaw, this.gender, this.afiliateCode, this.url_photo, this.familyId, this.wasChanged, this.wasRemove);

  int idLocal = 1;
  int id;
  String names;
  String lastname;
  String mother_lastname;
  String birthday;
  String dateRaw;
  int gender;
  String afiliateCode;
  String url_photo;
  int familyId;
  bool wasChanged;
  bool wasRemove;

  /// Un método constructor de tipo factory es necesario para crear una nueva instancia User
  /// desde un mapa. Pasa el mapa al constructor auto-generado `_$UserFromJson()`.
  /// El constructor es nombrado después de la clase fuente, en este caso User.
  factory KidRegister.fromJson(Map<String, dynamic> json) => _$KidRegisterFromJson(json);

  /// `toJson` es la convención para una clase declarar que soporta serialización
  /// a JSON. La implementación simplemente llama al método de ayuda privado
  /// `_$UserToJson`.
  Map<String, dynamic> toJson() => _$KidRegisterToJson(this);

}