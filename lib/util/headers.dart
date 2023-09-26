import 'package:shared_preferences/shared_preferences.dart';

class Headers {
  static Future<Map<String, String>> getTokenHeaders () async {
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    final String? token = prefs.getString('token');
    return {"x-access-token": token != null ? token.toString() : ""};
  }
  static Future<Map<String, String>> getAllHeaders () async {
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    final String? token = prefs.getString('token');
    return {"Content-Type": "application/json", "x-access-token": token != null ? token.toString() : ""};
  }

  static Future<String> getToken() async {
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    final String? token = prefs.getString('token');
    return token != null ? token.toString() : "";
  }
}