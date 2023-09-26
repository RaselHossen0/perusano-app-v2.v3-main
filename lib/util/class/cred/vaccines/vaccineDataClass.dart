import 'package:json_annotation/json_annotation.dart';
//import 'package:build_runner/build_runner.dart';

/// Esto permite a la clase `User` acceder a las propiedades privadas
/// en el fichero generado. El valor para esto es *.g.dart, donde
/// el asterisco denota el nombre del fichero fuente.
part 'vaccineDataClass.g.dart';

/// Una anotación para el auto-generador de código para que sepa que en esta clase
/// necesita generarse lógica de serialización JSON.
@JsonSerializable()


class VaccineDataRegister {



  VaccineDataRegister(this.id, this.name, this.description, this.totalDosis, this.timeDosis, this.wasChanged, this.wasRemove);

  int id;
  int idLocal = 1;
  String name;
  String description;
  int totalDosis;
  List timeDosis;
  bool wasChanged;
  bool wasRemove;

  /// Un método constructor de tipo factory es necesario para crear una nueva instancia User
  /// desde un mapa. Pasa el mapa al constructor auto-generado `_$UserFromJson()`.
  /// El constructor es nombrado después de la clase fuente, en este caso User.
  factory VaccineDataRegister.fromJson(Map<String, dynamic> json) => _$VaccineDataRegisterFromJson(json);

  /// `toJson` es la convención para una clase declarar que soporta serialización
  /// a JSON. La implementación simplemente llama al método de ayuda privado
  /// `_$UserToJson`.
  Map<String, dynamic> toJson() => _$VaccineDataRegisterToJson(this);


}