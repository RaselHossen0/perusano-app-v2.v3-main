import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class IronSupplementTypeFM {

  //Get local storage path
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  // Get the file
  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/ironSupplementType.json');
  }

  // Obtain all the events information from local storage
  Future<List> readFile() async {
    try {

      final file = await _localFile;

      // Read the file
      String contents = await file.readAsString();

      List data = json.decode(contents);

      print('qaqui');
      print(data);
      print(data[0]);
      print(data[0]['idKid']);
      //print(contents[1]);
      print('endsadadasdaa');

      //print(data);
      //print(data['idKid']);
      print('endsada');

      return data;
    } catch (e) {
      print('dentro del catch');
      print(e.printError);
      print(e.toString());

      // If encountering an error, return 0
      return [];
    }
  }

  // Write new register in local storage
  Future<File> writeRegister(Map data) async {

    final file = await _localFile;

    try{
      print('dentro del try');
      List leido = await readFile();
      print(leido.length);
      print(leido);

      if(leido.length == 0){
        print('Dentro del id ACFM');
        leido.add(data);
        print(leido);
        String json = jsonEncode(leido);
        // Escribir archivo
        file.writeAsString(json);
      }else{
        print('Dentro del else ACFM');
        int ultimoId = leido[leido.length-1]['idLocal'];
        int nuevoId = ultimoId+1;
        data['idLocal']=nuevoId;
        leido.add(data);
        print(leido);
        String json = jsonEncode(leido);
        // Escribir archivo
        file.writeAsString(json);
      }
    }catch(e){
      print('dentro del catch');
      print(e.toString());
      List temp = [];
      temp.add(data);
      String json = jsonEncode(temp);
      file.writeAsString(json);
    }


    return file;
  }

  // Delete a register in local storage
  Future<Map> deleteRegister(int idKid, int idLocal) async{

    final file = await _localFile;

    List leido = await readFile();

    List nuevaLista = [];
    Map eliminado = {};

    for(var value in leido){
      if(value['idKid'] == idKid && value['idLocal'] == idLocal){
        eliminado = value;
      }else{
        nuevaLista.add(value);
      }
    }

    if(leido.length == nuevaLista.length){
      Map vacio = {'idLocal': 0};
      return vacio;
    }else{
      String json = jsonEncode(nuevaLista);
      // Escribir archivo
      file.writeAsString(json);
      return eliminado;
    }

  }

  // Empty local storage file
  Future<void> emptyFile() async {
    final file = await _localFile;
    List temp = [];
    String json = jsonEncode(temp);
    file.writeAsString(json);
  }
}