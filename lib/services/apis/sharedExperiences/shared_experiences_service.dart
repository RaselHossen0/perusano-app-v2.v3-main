import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:perusano/util/globalVariables.dart';
import 'package:perusano/util/headers.dart' as customHeaders;
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class SharedExperiencesService {
// Get all shared experiences from the network database
  Future<List> getSharedExperiences() async {
    http.Response response = await http.get(
        Uri.parse('${GlobalVariables.endpoint}/shared_experiences'),
        headers: await customHeaders.Headers.getTokenHeaders());
    List data = json.decode(response.body);
    return data;
  }

  // Get shared experience more information from network database
  Future<Map> getSharedExperienceById(String id) async {
    http.Response response = await http.get(
        Uri.parse('${GlobalVariables.endpoint}/shared_experience/${id}'),
        headers: await customHeaders.Headers.getTokenHeaders());
    Map data = json.decode(response.body);
    return data;
  }
}
