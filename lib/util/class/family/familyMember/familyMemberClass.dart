import 'package:json_annotation/json_annotation.dart';

/// Esto permite a la clase `User` acceder a las propiedades privadas
/// en el fichero generado. El valor para esto es *.g.dart, donde
/// el asterisco denota el nombre del fichero fuente.
part 'familyMemberClass.g.dart';

/// Una anotación para el auto-generador de código para que sepa que en esta clase
/// necesita generarse lógica de serialización JSON.
@JsonSerializable()


class FamilyMemberRegister {



  FamilyMemberRegister(this.id, this.dni, this.name, this.lastname, this.mother_lastname, this.relationship, this.cellphone, this.phone, this.occupation, this.email, this.is_caregiver, this.url_photo, this.familyId, this.wasChanged, this.wasRemove);

  int idLocal = 1;
  int id;
  String dni;
  String name;
  String lastname;
  String mother_lastname;
  String relationship;
  String cellphone;
  String phone;
  String occupation;
  String email;
  bool is_caregiver;
  String url_photo;
  int familyId;
  bool wasChanged;
  bool wasRemove;

  /// Un método constructor de tipo factory es necesario para crear una nueva instancia User
  /// desde un mapa. Pasa el mapa al constructor auto-generado `_$UserFromJson()`.
  /// El constructor es nombrado después de la clase fuente, en este caso User.
  factory FamilyMemberRegister.fromJson(Map<String, dynamic> json) => _$FamilyMemberRegisterFromJson(json);

  /// `toJson` es la convención para una clase declarar que soporta serialización
  /// a JSON. La implementación simplemente llama al método de ayuda privado
  /// `_$UserToJson`.
  Map<String, dynamic> toJson() => _$FamilyMemberRegisterToJson(this);

}