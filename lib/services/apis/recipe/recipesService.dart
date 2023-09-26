import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:perusano/util/globalVariables.dart';
import 'package:perusano/util/headers.dart' as customHeaders;
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class RecipesService {
  //Get information
  // Get all recipes from network database
  Future<List> getRecipes() async {
    http.Response response = await http.get(
        Uri.parse('${GlobalVariables.endpoint}/recipes'),
        headers: await customHeaders.Headers.getTokenHeaders());
    List data = json.decode(response.body);
    return data;
  }

  // Get recipe image from network database
  Future<Map> getRecipeImageById(int id) async {
    http.Response response = await http.get(
        Uri.parse('${GlobalVariables.endpoint}/recipe_image_url/${id}'),
        headers: await customHeaders.Headers.getTokenHeaders());
    Map data = json.decode(response.body);

    return data;
  }

  // Get recipe video from network database
  Future<Map> getRecipeVideoById(int id) async {
    http.Response response = await http.get(
        Uri.parse('${GlobalVariables.endpoint}/recipe_video_url/${id}'),
        headers: await customHeaders.Headers.getTokenHeaders());
    Map data = json.decode(response.body);
    return data;
  }

  // Get recipe more information from network database
  Future<Map> getRecipeById(String id) async {
    http.Response response = await http.get(
        Uri.parse('${GlobalVariables.endpoint}/recipe/${id}'),
        headers: await customHeaders.Headers.getTokenHeaders());
    Map data = json.decode(response.body);
    return data;
  }

  // Get ingredients from network database
  Future<List> getIngredients() async {
    http.Response response = await http.get(
        Uri.parse('${GlobalVariables.endpoint}/ingredients'),
        headers: await customHeaders.Headers.getTokenHeaders());
    List data = json.decode(response.body);
    return data;
  }

  // Get amounts from network database
  Future<List> getAmounts() async {
    http.Response response = await http.get(
        Uri.parse('${GlobalVariables.endpoint}/amounts'),
        headers: await customHeaders.Headers.getTokenHeaders());
    List data = json.decode(response.body);
    return data;
  }

  // Get units from network database
  Future<List> getUnits() async {
    http.Response response = await http.get(
        Uri.parse('${GlobalVariables.endpoint}/units'),
        headers: await customHeaders.Headers.getTokenHeaders());
    List data = json.decode(response.body);
    return data;
  }

  // Get age tags from network database
  Future<List> getTags() async {
    http.Response response = await http.get(
        Uri.parse('${GlobalVariables.endpoint}/age_tags/'),
        headers: await customHeaders.Headers.getTokenHeaders());
    List data = json.decode(response.body);
    return data;
  }

  // Add information
  // Add recipe into network database
  Future<Map> addRecipe(Map receta) async {
    try {
      final response = await http.post(
          Uri.parse('${GlobalVariables.endpoint}/recipe/'),
          body: jsonEncode(receta),
          headers: await customHeaders.Headers.getAllHeaders());
      Map data = json.decode(response.body);
      if (response.statusCode == 200 || response.statusCode == 400) {
        return data;
      } else {
        return {'id': 0};
      }
    } catch (e) {
      return {'id': 0};
    }
  }

  // Add recipe image into network database
  Future<bool> addImage(File file, int recipe_id) async {
    String url = '${GlobalVariables.endpoint}/recipe_image/';
    final dio = Dio();

    final formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(
        file.path,
        filename: file.path.split('/').last,
        // ここ↓
        contentType: MediaType.parse('image/jpeg'),
      ),
      'recipe_id': recipe_id
    });

    dio.options.headers['x-access-token'] =
        await customHeaders.Headers.getToken();
    final response = await dio.post(
      data: formData,
      url,
    );

    if (response.statusCode == 200 || response.statusCode == 400) {
      return true;
    } else {
      return false;
    }
  }

  // Add recipe video into network database
  Future<bool> addVideo(File file, int recipe_id) async {
    String url = '${GlobalVariables.endpoint}/recipe_video/';
    final dio = Dio();

    final formData = FormData.fromMap({
      'video': await MultipartFile.fromFile(
        file.path,
        filename: file.path.split('/').last,
        // ここ↓
        contentType: MediaType.parse('video/mp4'),
      ),
      'recipe_id': recipe_id
    });

    dio.options.headers['x-access-token'] =
        await customHeaders.Headers.getToken();
    final response = await dio.post(
      data: formData,
      url,
    );

    if (response.statusCode == 200 || response.statusCode == 400) {
      return true;
    } else {
      return false;
    }
  }

  // Download media
  // Download recipe image from network database
  Future<String> downloadRecipeImage(int id) async {
    final request = await HttpClient()
        .getUrl(Uri.parse('${GlobalVariables.endpoint}/recipe_image/${id}'));
    request.headers
        .add('x-access-token', await customHeaders.Headers.getToken());
    final response = await request.close();
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final recipePathImage = '${path}/images/recipe_${id}.png';
    new File(recipePathImage).createSync(recursive: true);
    response.pipe(File(recipePathImage).openWrite());
    return recipePathImage;
  }

  // Download recipe video from network database
  Future<String> downloadRecipeVideo(int id) async {
    final request = await HttpClient()
        .getUrl(Uri.parse('${GlobalVariables.endpoint}/recipe_video/${id}'));
    request.headers
        .add('x-access-token', await customHeaders.Headers.getToken());
    final response = await request.close();
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final recipePathVideo = '${path}/videos/recipe_${id}.mp4';
    new File(recipePathVideo).createSync(recursive: true);
    response.pipe(File(recipePathVideo).openWrite());
    return recipePathVideo;
  }

  // Save media in locale storage
  // Save image in locale storage
  Future<String> storeLocalImage(File _image) async {
    String imageName = basename(_image?.path ?? '');
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final recipePathImage = '${path}/images/${imageName}';
    File(recipePathImage).createSync(recursive: true);
    _image.copy(recipePathImage);

    return recipePathImage;
  }

  // Save video in locale storage
  Future<String> storeLocalVideo(File _video) async {
    String videoName = basename(_video?.path ?? '');
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final recipePathVideo = '${path}/videos/${videoName}';
    File(recipePathVideo).createSync(recursive: true);
    _video.copy(recipePathVideo);

    return recipePathVideo;
  }
}
