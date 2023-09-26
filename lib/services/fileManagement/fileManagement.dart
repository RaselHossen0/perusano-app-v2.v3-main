import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class FileManagement {

  static Future<String> localPath() async {
    final directory = await getApplicationDocumentsDirectory();
    print('Aqui dentro');
    print(directory.path);
    return directory.path;
  }

  Future<File> _localFile(String fileName) async {
    final path = await localPath;
    return File('$path/$fileName');
  }

  Future<int> readCounter(String fileName) async {
    try {
      final file = await _localFile(fileName);

      // Read the file
      final contents = await file.readAsString();

      return int.parse(contents);
    } catch (e) {
      // If encountering an error, return 0
      return 0;
    }
  }

  Future<File> writeCounter(int counter, String fileName) async {
    final file = await _localFile(fileName);

    // Write the file

    return file.writeAsString('$counter');
  }
}