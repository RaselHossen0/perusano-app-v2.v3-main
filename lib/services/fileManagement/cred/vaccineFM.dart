import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class VaccineFM {

  //Get local storage path
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  // Get the file
  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/vaccine.json');
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

  // Obtain vaccines from a specific kid from local storage
  Future<List> readFileById(int idLocalKid) async {
    try {

      final file = await _localFile;

      // Read the file
      String contents = await file.readAsString();

      List data = json.decode(contents);

      List single = [];
      for (var value in data){
        if(value['idLocalKid']==idLocalKid){
          single.add(value);
        }
      }


      return single;
    } catch (e) {

      // If encountering an error, return 0
      return [];
    }
  }

  // Get not updated to network database registers
  Future<List> getNotUploaded() async {
    try {
      final file = await _localFile;
      // Read the file
      String contents = await file.readAsString();
      List data = json.decode(contents);
      List filtrado= [];
      for (var value in data){
        if(value['idKid']==0){
          filtrado.add(value);
        }
      }
      return filtrado;
    } catch (e) {
      // If encountering an error, return 0
      return [];
    }
  }

  // Get not changed in network database registers
  Future<List> getChanged() async {
    try {
      final file = await _localFile;
      // Read the file
      String contents = await file.readAsString();
      List data = json.decode(contents);
      List filtrado= [];
      for (var value in data){
        List doses = value['dosis'];
        for (var dose in doses){
          if(dose['wasChanged']){
            filtrado.add(dose);
          }
        }
      }
      return filtrado;
    } catch (e) {
      // If encountering an error, return 0
      return [];
    }
  }

  // Update wasChanged flag to true in local storage
  Future<Map> changeWasChangedToTrue(int idLocal) async{

    final file = await _localFile;

    List leido = await readFile();

    Map cambiado = {};


    for(var value in leido) {
      List dosis = value['dosis'];
      for (var value2 in dosis){
        if (value2['idLocal'] == idLocal) {
          value2['wasChanged'] = true;
          cambiado = value2;
        }
      }
    }

    if(cambiado.isEmpty){
      Map vacio = {'id': -1};
      return vacio;
    }else{
      String json = jsonEncode(leido);
      // Escribir archivo
      file.writeAsString(json);
      return cambiado;
    }

  }

  // Update wasChanged flag to false in local storage
  Future<Map> changeWasChangedToFalse(int idLocal) async{

    final file = await _localFile;

    List leido = await readFile();

    Map cambiado = {};

    for(var value in leido) {
      List dosis = value['dosis'];
      for (var value2 in dosis){
        if (value2['idLocal'] == idLocal) {
          value2['wasChanged'] = false;
          cambiado = value2;
        }
      }
    }

    if(cambiado.isEmpty){
      Map vacio = {'id': -1};
      return vacio;
    }else{
      String json = jsonEncode(leido);
      // Escribir archivo
      file.writeAsString(json);
      return cambiado;
    }

  }

  // Write new register in local storage
  Future<File> writeRegister(Map data) async {

    final file = await _localFile;

    try{

      List leido = await readFile();


      if(leido.isEmpty){


        int idLocalInicial = 1;
        for(var value in data['dosis']){
          value['idLocal'] = idLocalInicial;
          idLocalInicial++;
        }

        leido.add(data);

        String json = jsonEncode(leido);
        // Escribir archivo
        file.writeAsString(json);
      }else{

        List tempDosis = leido[leido.length-1]['dosis'];

        int ultimoId = tempDosis[tempDosis.length-1]['idLocal'];

        ultimoId++;

        for(var value in data['dosis']){
          value['idLocal'] = ultimoId;
          ultimoId++;
        }

        leido.add(data);

        String json = jsonEncode(leido);
        // Escribir archivo
        file.writeAsString(json);
      }
    }catch(e){

      List temp = [];


      int idLocalInicial = 1;
      for(var value in data['dosis']){

        value['idLocal'] = idLocalInicial;
        idLocalInicial++;
      }


      temp.add(data);
      String json = jsonEncode(temp);
      file.writeAsString(json);

    }


    return file;
  }

  // Update applied Date in a dose
  Future<Map> updateVaccineState(int idKid, int idVaccine, int idLocal, String applied_date) async{

    final file = await _localFile;

    List leido = await readFile();

    Map actualizado = {};

    String formattedDate = DateFormat('dd-MMM-yyyy').format(DateTime.parse(applied_date));

    for(var value in leido) {
      if (value['idLocalKid'] == idKid && value['id'] == idVaccine) {
        List tempDosis = value['dosis'];
        for (var value2 in tempDosis) {
          if (value2['idLocal'] == idLocal) {
            value2['applied_date'] = formattedDate;
            value2['applied_date_raw'] = applied_date;
            actualizado = value2;
          }
        }
      }
    }

    if(actualizado.isEmpty){
      Map vacio = {'idLocal': -1};
      return vacio;
    }else{
      String json = jsonEncode(leido);
      // Escribir archivo
      file.writeAsString(json);
      return actualizado;
    }

  }

  // Delete applied date in a dose
  Future<Map> reverseVaccineState(int idKid, int idVaccine, int idLocal) async{

    final file = await _localFile;

    List leido = await readFile();

    Map actualizado = {};

    for(var value in leido) {
      if (value['idLocalKid'] == idKid && value['id'] == idVaccine) {
        List tempDosis = value['dosis'];
        for (var value2 in tempDosis) {
          if (value2['idLocal'] == idLocal) {
            value2['applied_date'] = null;
            value2['applied_date_raw'] = null;
            actualizado = value2;
          }
        }
      }
    }

    if(actualizado.isEmpty){
      Map vacio = {'idLocal': -1};
      return vacio;
    }else{
      String json = jsonEncode(leido);
      // Escribir archivo
      file.writeAsString(json);
      return actualizado;
    }

  }

  // Update kidId in local storage registers
  Future<void> updateIdKidInVaccines(int idLocalKid, int idKid) async{
    final file = await _localFile;
    List leido = await readFile();
    for(var value in leido) {
      if (value['idLocalKid'] == idLocalKid) {
        value['idKid'] = idKid;
      }
    }
    String json = jsonEncode(leido);
    // Escribir archivo
    file.writeAsString(json);
  }

  // Update doseId in local storage registers
  Future<void> updateIdDoseInVaccines(int idKid, int idVaccine, int idLocal, int id) async{

    final file = await _localFile;
    List leido = await readFile();
    for(var value in leido) {
      if (value['idKid'] == idKid && value['id']==idVaccine) {

        List vaccineDoses = value['dosis'];

        for (var value2 in vaccineDoses){


          if(value2['idLocal'] == idLocal){
            value2['id']=id;
          }
        }
      }
    }
    String json = jsonEncode(leido);
    // Escribir archivo
    file.writeAsString(json);
  }





}