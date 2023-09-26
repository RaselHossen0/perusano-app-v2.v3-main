import 'dart:convert';
import 'package:perusano/util/globalVariables.dart';
import 'package:perusano/util/headers.dart';
import 'package:http/http.dart' as http;

class CalendarService {
  // Gets events from network database
  Future<List> getEventsByFamilyId(int id) async {
    http.Response response = await http.get(
        Uri.parse('${GlobalVariables.endpoint}/events_by_family/${id}'),
        headers: await Headers.getTokenHeaders());
    List data = json.decode(response.body);

    return data;
  }
}
