import 'package:json_annotation/json_annotation.dart';
//import 'package:build_runner/build_runner.dart';

/// Esto permite a la clase `User` acceder a las propiedades privadas
/// en el fichero generado. El valor para esto es *.g.dart, donde
/// el asterisco denota el nombre del fichero fuente.
part 'appointmentClass.g.dart';

/// Una anotación para el auto-generador de código para que sepa que en esta clase
/// necesita generarse lógica de serialización JSON.
@JsonSerializable()


class AppointmentRegister {

  AppointmentRegister(this.idKid, this.idLocalKid, this.id, this.date_format, this.date, this.attendanceDate, this.attendanceDate_format, this.description, this.state_value, this.state_id, this.wasChanged, this.wasRemove);

  int idKid;
  int idLocalKid;
  int id;
  int idLocal = 1;
  String date_format;
  String date;
  String? attendanceDate;
  String? attendanceDate_format;
  String description;
  String state_value;
  int state_id;
  bool wasChanged;
  bool wasRemove;

  /// Un método constructor de tipo factory es necesario para crear una nueva instancia User
  /// desde un mapa. Pasa el mapa al constructor auto-generado `_$UserFromJson()`.
  /// El constructor es nombrado después de la clase fuente, en este caso User.
  factory AppointmentRegister.fromJson(Map<String, dynamic> json) => _$AppointmentRegisterFromJson(json);

  /// `toJson` es la convención para una clase declarar que soporta serialización
  /// a JSON. La implementación simplemente llama al método de ayuda privado
  /// `_$UserToJson`.
  Map<String, dynamic> toJson() => _$AppointmentRegisterToJson(this);

}