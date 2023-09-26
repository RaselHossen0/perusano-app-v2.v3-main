import 'package:perusano/util/class/join/userClass.dart';

class FamilyClass {
  final int id;
  UserClass user;
  String photo_url;

  FamilyClass({required this.id, required this.user, required this.photo_url});

  Map<String, dynamic> toMap() {
    return {'id': id, 'user': user, 'photo_url': photo_url};
  }
}
