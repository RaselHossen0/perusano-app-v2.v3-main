import 'dart:convert';
import 'package:perusano/util/globalVariables.dart';
import 'package:perusano/util/headers.dart';
import 'package:http/http.dart' as http;

class FamilyRegisterCenter {
  // Add a family into network database
  Future<Map> addUser(String user, String pass, bool isHealthPerson,
      int healthCenter, String urlPhoto) async {
    print('object');
    try {
      final response = await http.post(
        Uri.parse('${GlobalVariables.endpoint}/api/auth/signup/'),
        body: jsonEncode({
          'user': user,
          'password': pass,
          'isHealthPerson': isHealthPerson,
          'healthCenter': healthCenter,
          'urlPhoto': urlPhoto
        }),
        headers: await Headers.getAllHeaders(),
      );
      print(response.body);
      Map data = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        return data;
      } else {
        Map vacio = {'id': 0, 'urlPhoto': '', 'healthCenter': 0};
        return vacio;
      }
    } catch (e) {
      Map vacio = {'id': 0, 'urlPhoto': '', 'healthCenter': 0};
      return vacio;
    }
  }

  // Add a kid into network database
  Future<Map> addKid(
      String names,
      String lastname,
      String motherLastname,
      String birthday,
      double weight,
      double size,
      int gender,
      String afiliateCode,
      int familyId) async {
    try {
      final response = await http.post(
        Uri.parse('${GlobalVariables.endpoint}/kid/'),
        body: jsonEncode({
          "names": names,
          "lastname": lastname,
          "motherLastname": motherLastname,
          "birthday": birthday,
          "weight": weight,
          "size": size,
          "gender": gender,
          "afiliateCode": afiliateCode,
          "familyId": familyId
        }),
        headers: await Headers.getAllHeaders(),
      );
      Map data = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        return data;
      } else {
        Map vacio = {'id': 0};
        return vacio;
      }
    } catch (e) {
      Map vacio = {'id': 0};
      return vacio;
    }
  }

  // Add a family member into network database
  Future<Map> addFamilyMember(
      String dni,
      String name,
      String lastname,
      String motherLastname,
      String relationship,
      String cellphone,
      String phone,
      String occupation,
      String email,
      bool isCaregiver,
      String urlPhoto,
      int familyId) async {
    try {
      final response = await http.post(
        Uri.parse('${GlobalVariables.endpoint}/family_member/'),
        body: jsonEncode({
          "dni": dni,
          "name": name,
          "lastname": lastname,
          "motherLastname": motherLastname,
          "relationship": relationship,
          "cellphone": cellphone,
          "phone": phone,
          "occupation": occupation,
          "email": email,
          "isCaregiver": isCaregiver,
          "urlPhoto": urlPhoto,
          "familyId": familyId
        }),
        headers: await Headers.getAllHeaders(),
      );
      Map data = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        return data;
      } else {
        Map vacio = {'id': 0};
        return vacio;
      }
    } catch (e) {
      Map vacio = {'id': 0};
      return vacio;
    }
  }
}
