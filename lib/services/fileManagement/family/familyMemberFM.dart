import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class FamilyMemberFM {

  //Get local storage path
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  // Get the file
  Future<File> get _localFile async {
    final path = await _localPath;

    return File('$path/familyMember.json');
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

  // Get not updated to network database registers
  Future<List> getNotUpdated() async {
    try {
      final file = await _localFile;
      // Read the file
      String contents = await file.readAsString();
      List data = json.decode(contents);
      List filtrado= [];
      for (var value in data){
        if(value['id']==0){
          filtrado.add(value);
        }
      }
      return filtrado;
    } catch (e) {
      // If encountering an error, return 0
      return [];
    }
  }

  // Write new register in local storage
  Future<Map> writeRegister(Map data) async {

    final file = await _localFile;


    try{

      List leido = await readFile();

      if(leido.length == 0){

        leido.add(data);

        String json = jsonEncode(leido);
        // Escribir archivo
        file.writeAsString(json);
      }else{

        int ultimoId = leido[leido.length-1]['idLocal'];
        int nuevoId = ultimoId+1;
        data['idLocal']=nuevoId;
        leido.add(data);

        String json = jsonEncode(leido);
        // Escribir archivo
        file.writeAsString(json);
      }
    }catch(e){

      List temp = [];
      temp.add(data);


      String json = jsonEncode(temp);
      file.writeAsString(json);
    }


    return data;
  }

  // Update id in local storage registers
  Future<void> updateIdRegister(int idLocal, int id) async{
    final file = await _localFile;
    List leido = await readFile();
    Map actualizado = {};
     for(var value in leido) {
        if (value['idLocal'] == idLocal) {
          value['id'] = id;
          actualizado = value;
        }
    }
    if(actualizado.isNotEmpty){
      String json = jsonEncode(leido);
      // Escribir archivo
      file.writeAsString(json);
    }
  }

}