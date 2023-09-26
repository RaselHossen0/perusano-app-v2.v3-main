import 'dart:convert';
import 'package:perusano/util/globalVariables.dart';
import 'package:perusano/util/headers.dart';
import 'package:perusano/util/internVariables.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class FamilyService {
  // Get all families from network database
  static Future<List> getFamilies() async {
    http.Response response = await http.get(
        Uri.parse('${GlobalVariables.endpoint}/families/'),
        headers: await Headers.getTokenHeaders());
    List data = json.decode(response.body);
    return data;
  }

  // Assign family data into intern variables
  static Future asignFamilyData(int id) async {
    try {
      http.Response response = await http.get(
          Uri.parse('${GlobalVariables.endpoint}/family_by_userId/${id}'),
          headers: await Headers.getTokenHeaders());
      Map data = json.decode(response.body);

      InternVariables.family['id'] = data['id'];
      InternVariables.family['url_photo'] = data['urlPhoto'];
      InternVariables.family['health_center'] = data['healthCenter'];
    } catch (e) {
      InternVariables.family['id'] = InternVariables.idUser;
    }
  }

  // Gets all the kid of specific family from network database
  static Future<List> getKidsByFamilyId(int id) async {
    http.Response response = await http.get(
        Uri.parse('${GlobalVariables.endpoint}/kid_by_family/${id}'),
        headers: await Headers.getTokenHeaders());

    List data = json.decode(response.body);
    return data;
  }

  // Gets all the family members of specific family from network database
  static Future<List> getMembersByFamilyId(int id) async {
    print('dentro del getfammemb');
    print(id);
    http.Response response = await http.get(
        Uri.parse('${GlobalVariables.endpoint}/family_members/${id}'),
        headers: await Headers.getTokenHeaders());
    print('despues del response');
    print(response.body);
    List data = json.decode(response.body);
    print(data);
    return data;
  }
}
