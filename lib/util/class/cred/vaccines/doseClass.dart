import 'package:json_annotation/json_annotation.dart';
//import 'package:build_runner/build_runner.dart';

/// Esto permite a la clase `User` acceder a las propiedades privadas
/// en el fichero generado. El valor para esto es *.g.dart, donde
/// el asterisco denota el nombre del fichero fuente.
part 'doseClass.g.dart';

/// Una anotación para el auto-generador de código para que sepa que en esta clase
/// necesita generarse lógica de serialización JSON.
@JsonSerializable()


class DoseRegister {



  DoseRegister(this.id, this.dosis_number, this.applied_date, this.applied_date_raw, this.suggest_date_format, this.suggest_date, this.month, this.wasChanged);

  int id;
  int idLocal = 1;
  int dosis_number;
  String? applied_date;
  String? applied_date_raw;
  String suggest_date_format;
  String suggest_date;
  int month;
  bool wasChanged;

  /// Un método constructor de tipo factory es necesario para crear una nueva instancia User
  /// desde un mapa. Pasa el mapa al constructor auto-generado `_$UserFromJson()`.
  /// El constructor es nombrado después de la clase fuente, en este caso User.
  factory DoseRegister.fromJson(Map<String, dynamic> json) => _$DoseRegisterFromJson(json);

  /// `toJson` es la convención para una clase declarar que soporta serialización
  /// a JSON. La implementación simplemente llama al método de ayuda privado
  /// `_$UserToJson`.
  Map<String, dynamic> toJson() => _$DoseRegisterToJson(this);


}