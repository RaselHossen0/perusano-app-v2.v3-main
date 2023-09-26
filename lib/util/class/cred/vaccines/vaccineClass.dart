import 'package:json_annotation/json_annotation.dart';

import 'doseClass.dart';
//import 'package:build_runner/build_runner.dart';

/// Esto permite a la clase `User` acceder a las propiedades privadas
/// en el fichero generado. El valor para esto es *.g.dart, donde
/// el asterisco denota el nombre del fichero fuente.
part 'vaccineClass.g.dart';

/// Una anotación para el auto-generador de código para que sepa que en esta clase
/// necesita generarse lógica de serialización JSON.
@JsonSerializable()


class VaccineRegister {

  VaccineRegister(this.idKid, this.idLocalKid, this.id, this.name, this.dosis);

  int idKid;
  int idLocalKid;
  int id;
  String name;
  List dosis;

  /// Un método constructor de tipo factory es necesario para crear una nueva instancia User
  /// desde un mapa. Pasa el mapa al constructor auto-generado `_$UserFromJson()`.
  /// El constructor es nombrado después de la clase fuente, en este caso User.
  factory VaccineRegister.fromJson(Map<String, dynamic> json) => _$VaccineRegisterFromJson(json);

  /// `toJson` es la convención para una clase declarar que soporta serialización
  /// a JSON. La implementación simplemente llama al método de ayuda privado
  /// `_$UserToJson`.
  Map<String, dynamic> toJson() => _$VaccineRegisterToJson(this);


}