import 'package:json_annotation/json_annotation.dart';
//import 'package:build_runner/build_runner.dart';

/// Esto permite a la clase `User` acceder a las propiedades privadas
/// en el fichero generado. El valor para esto es *.g.dart, donde
/// el asterisco denota el nombre del fichero fuente.
part 'anemiaCheckClass.g.dart';

/// Una anotación para el auto-generador de código para que sepa que en esta clase
/// necesita generarse lógica de serialización JSON.
@JsonSerializable()


class AnemiaCheckRegister {



  AnemiaCheckRegister(this.idKid, this.idLocalKid, this.id, this.result, this.date, this.dateRaw, this.age, this.wasChanged, this.wasRemove);

  int idKid;
  int idLocalKid;
  int id;
  int idLocal = 1;
  double result;
  String date;
  String dateRaw;
  int age;
  bool wasChanged;
  bool wasRemove;

  /// Un método constructor de tipo factory es necesario para crear una nueva instancia User
  /// desde un mapa. Pasa el mapa al constructor auto-generado `_$UserFromJson()`.
  /// El constructor es nombrado después de la clase fuente, en este caso User.
  factory AnemiaCheckRegister.fromJson(Map<String, dynamic> json) => _$AnemiaCheckRegisterFromJson(json);

  /// `toJson` es la convención para una clase declarar que soporta serialización
  /// a JSON. La implementación simplemente llama al método de ayuda privado
  /// `_$UserToJson`.
  Map<String, dynamic> toJson() => _$AnemiaCheckRegisterToJson(this);

  /*AnemiaCheckRegister.fromJson(Map<String, dynamic> json)
      : idKid = json['idKid'],
        id = json['id'],
        result = json['result'],
        date = json['date'],
        age = json['age'];

  Map<String, dynamic> toJson() =>
      {
        'idKid': idKid,
        'id': id,
        'result': result,
        'date': date,
        'age': age
      };*/

}