import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class RecipeFM {
  //Get local storage path
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  // Get the file
  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/recipe.json');
  }

  // Obtain all the events information from local storage
  Future<List> readFile() async {
    try {
      final file = await _localFile;

      // Read the file
      String contents = await file.readAsString();

      List data = json.decode(contents);

      return data;
    } catch (e) {
      // If encountering an error, return 0
      return [];
    }
  }

  // Get recipe by localId
  Future<Map> findRecipeById(id) async {
    Map recipeById = {};
    List recipes = await readFile();
    final result = recipes.where((recipe) => recipe['idLocal'] == id);
    recipeById = result.first as Map;
    return recipeById;
  }

  // Get recipe by globalId
  Future<Map> findRecipeByRealId(id) async {
    Map recipeById = {};
    try {
      List recipes = await readFile();
      final result = recipes.where((recipe) => recipe['id'] == id);
      if (result.isNotEmpty) {
        recipeById = result.first as Map;
      }
    } catch (e) {
      log(e.toString());
    }

    return recipeById;
  }

  // Write new register in local storage
  Future<File> writeRegister(Map data) async {
    final file = await _localFile;

    try {
      List leido = await readFile();

      if (leido.isEmpty) {
        leido.add(data);
        String json = jsonEncode(leido);
        // Escribir archivo
        file.writeAsString(json);
      } else {
        int ultimoId = leido[leido.length - 1]['idLocal'];
        int nuevoId = ultimoId + 1;
        data['idLocal'] = nuevoId;
        leido.add(data);
        String json = jsonEncode(leido);
        // Escribir archivo
        file.writeAsString(json);
      }
    } catch (e) {
      List temp = [];
      temp.add(data);
      String json = jsonEncode(temp);
      file.writeAsString(json);
    }

    return file;
  }

  // Delete a register in local storage
  Future<Map> deleteRegister(int idKid, int idLocal) async {
    final file = await _localFile;

    List leido = await readFile();

    List nuevaLista = [];
    Map eliminado = {};

    for (var value in leido) {
      if (value['idKid'] == idKid && value['idLocal'] == idLocal) {
        eliminado = value;
      } else {
        nuevaLista.add(value);
      }
    }

    if (leido.length == nuevaLista.length) {
      Map vacio = {'idLocal': -1};
      return vacio;
    } else {
      String json = jsonEncode(nuevaLista);
      // Escribir archivo
      file.writeAsString(json);
      return eliminado;
    }
  }

  // Update id in local storage registers
  Future<void> updateIdRegister(int idLocal, int id) async {
    final file = await _localFile;
    List leido = await readFile();
    Map actualizado = {};
    for (var value in leido) {
      if (value['idLocal'] == idLocal) {
        value['id'] = id;
        actualizado = value;
      }
    }
    if (actualizado.isNotEmpty) {
      String json = jsonEncode(leido);
      // Escribir archivo
      file.writeAsString(json);
    }
  }

  // Get not updated to network database registers
  Future<List> getNotUpdated() async {
    try {
      final file = await _localFile;
      // Read the file
      String contents = await file.readAsString();
      List data = json.decode(contents);
      List filtrado = [];
      for (var value in data) {
        if (value['id'] == 0) {
          filtrado.add(value);
        }
      }
      return filtrado;
    } catch (e) {
      // If encountering an error, return 0
      return [];
    }
  }
}
