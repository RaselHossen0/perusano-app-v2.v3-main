
class UserClass {

  final int id;
  String user;
  String password;
  String is_health_person;

  UserClass({required this.id, required this.user, required this.password, required this.is_health_person});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user': user,
      'password': password,
      'is_health_person': is_health_person
    };
  }

}