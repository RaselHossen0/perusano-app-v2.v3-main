import 'dart:convert';
import 'package:perusano/util/globalVariables.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LoginService {
  // Validate the login and save in local storage ids and token
  static Future<Map> validate(String user, String pass) async {
    if (user == "usario1" && pass == "1") {
      Map vacio = {'id': 2, 'user': '', 'is_health_person': false};
      return vacio;
    } else if (user == "usario2" && pass == "2") {
      Map vacio = {'id': 3, 'user': '', 'is_health_person': false};
      return vacio;
    } else if (user == "usario3" && pass == "3") {
      Map vacio = {'id': 4, 'user': '', 'is_health_person': false};
      return vacio;
    } else if (user == "usario4" && pass == "4") {
      Map vacio = {'id': 5, 'user': '', 'is_health_person': false};
      return vacio;
    } else if (user == "usario5" && pass == "5") {
      Map vacio = {'id': 6, 'user': '', 'is_health_person': false};
      return vacio;
    } else {
      Map vacio = {'id': 1, 'user': '', 'is_health_person': false};
      return vacio;
    }
    // try {
    //   final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    //   final SharedPreferences prefs = await _prefs;

    //   final response = await http.post(
    //     Uri.parse('${GlobalVariables.endpoint}/api/auth/signin/'),
    //     body: jsonEncode({
    //       'user': user.replaceAll(' ', ''),
    //       'password': pass.replaceAll(' ', '')
    //     }),
    //     headers: {"Content-Type": "application/json"},
    //   );

    //   Map data = json.decode(response.body);

    //   if (response.statusCode == 200 || response.statusCode == 400) {
    //     final accessToken = data['accessToken'];
    //     final idUser = data['id'];
    //     final idFamily = data['idFamily'];
    //     prefs.setString('token', accessToken);
    //     prefs.setInt('idUser', idUser);
    //     prefs.setInt('idFamily', idFamily);
    //     prefs.setString('username', user);
    //     return data;
    //   } else {
    //     Map vacio = {'id': 0, 'user': '', 'is_health_person': false};
    //     return vacio;
    //   }
    // } catch (e) {
    //   Map vacio = {'id': 0, 'user': '', 'is_health_person': false};
    //   return vacio;
    // }
  }
}
