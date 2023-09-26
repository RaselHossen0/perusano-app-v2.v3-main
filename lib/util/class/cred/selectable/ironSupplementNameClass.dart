import 'package:json_annotation/json_annotation.dart';
//import 'package:build_runner/build_runner.dart';

/// Esto permite a la clase `User` acceder a las propiedades privadas
/// en el fichero generado. El valor para esto es *.g.dart, donde
/// el asterisco denota el nombre del fichero fuente.
part 'ironSupplementNameClass.g.dart';

/// Una anotación para el auto-generador de código para que sepa que en esta clase
/// necesita generarse lógica de serialización JSON.
@JsonSerializable()


class IronSupplementNameRegister {



  IronSupplementNameRegister(this.id, this.label, this.type, this.wasChanged, this.wasRemove);

  int id;
  int idLocal = 1;
  String label;
  Map type;
  bool wasChanged;
  bool wasRemove;


  /// Un método constructor de tipo factory es necesario para crear una nueva instancia User
  /// desde un mapa. Pasa el mapa al constructor auto-generado `_$UserFromJson()`.
  /// El constructor es nombrado después de la clase fuente, en este caso User.
  factory IronSupplementNameRegister.fromJson(Map<String, dynamic> json) => _$IronSupplementNameRegisterFromJson(json);

  /// `toJson` es la convención para una clase declarar que soporta serialización
  /// a JSON. La implementación simplemente llama al método de ayuda privado
  /// `_$UserToJson`.
  Map<String, dynamic> toJson() => _$IronSupplementNameRegisterToJson(this);


}