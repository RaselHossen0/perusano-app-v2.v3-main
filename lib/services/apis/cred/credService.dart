import 'dart:convert';
import 'package:perusano/util/globalVariables.dart';
import 'package:http/http.dart' as http;
import 'package:perusano/util/headers.dart';

class CredService {
  // Get all vaccine names and extra data from network database
  Future<List> getAllVaccines() async {
    http.Response response = await http.get(
        Uri.parse('${GlobalVariables.endpoint}/vaccines/'),
        headers: await Headers.getTokenHeaders());
    List data = json.decode(response.body);
    return data;
  }

  // Get all kid vaccines from network database
  Future<List> getVaccinesByKidId(int id) async {
    http.Response response = await http.get(
        Uri.parse('${GlobalVariables.endpoint}/vaccines/${id}'),
        headers: await Headers.getTokenHeaders());
    List data = json.decode(response.body);

    return data;
  }

  // Get all kid anemia check from network database
  Future<List> getAnemiaCheckByKidId(int id) async {
    http.Response response = await http.get(
        Uri.parse('${GlobalVariables.endpoint}/anemia_control/${id}'),
        headers: await Headers.getTokenHeaders());
    List data = json.decode(response.body);
    return data;
  }

  // Get all kid appointments from network database
  Future<List> getAppointmentsByKidId(int id) async {
    http.Response response = await http.get(
        Uri.parse('${GlobalVariables.endpoint}/appointments/${id}'),
        headers: await Headers.getTokenHeaders());
    List data = json.decode(response.body);
    return data;
  }

  // Get all kid weight and height from network database
  Future<List> getWeightAndHeightByKidId(int id) async {
    http.Response response = await http.get(
        Uri.parse('${GlobalVariables.endpoint}/size_kid/${id}'),
        headers: await Headers.getTokenHeaders());
    List data = json.decode(response.body);
    return data;
  }

  // Get all kid iron supplements from network database
  Future<List> getIronSupplementByKidId(int id) async {
    http.Response response = await http.get(
        Uri.parse('${GlobalVariables.endpoint}/iron_supplement/${id}'),
        headers: await Headers.getTokenHeaders());

    List data = json.decode(response.body);
    return data;
  }

  // Get more information for a kid from network database
  Future<Map> getPrincipalDataByKidId(int id) async {
    http.Response response = await http.get(
        Uri.parse('${GlobalVariables.endpoint}/kid/${id}'),
        headers: await Headers.getTokenHeaders());
    Map data = json.decode(response.body);
    return data;
  }

  // Get all iron supplement types from network database
  Future<List> getIronSupplement() async {
    http.Response response = await http.get(
        Uri.parse('${GlobalVariables.endpoint}/iron_supplement_names'),
        headers: await Headers.getTokenHeaders());
    List data = json.decode(response.body);
    return data;
  }

  // Get all iron supplement types from network database
  Future<List> getIronSupplementTypes() async {
    http.Response response = await http.get(
        Uri.parse('${GlobalVariables.endpoint}/iron_supplement_types'),
        headers: await Headers.getTokenHeaders());
    List data = json.decode(response.body);
    return data;
  }
}
