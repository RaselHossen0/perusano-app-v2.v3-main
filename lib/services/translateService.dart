import 'package:flutter/services.dart';
import 'package:perusano/util/globalVariables.dart';
import 'package:get/get.dart';
import 'package:yaml/yaml.dart';

class TranslateService {
  static YamlMap translations = loadYaml('assets/lang/EN.yml');
  //YamlMap translationsFallback;

  static Future load() async {
    print('lang/${GlobalVariables.language}.yml');
    String yamlString = await rootBundle
        .loadString('assets/lang/${GlobalVariables.language}.yml');
    //print(yamlString);
    translations = loadYaml(yamlString);
    //String yamlString1 = await rootBundle.loadString('lang/en.yml');
    //translationsFallback = loadYaml(yamlString1);
  }

  static String translate(String key) {
    //print(key);
    try {
      //print('dentro del try');
      var keys = key.split(".");
      //print(keys);
      dynamic translated = translations;
      keys.forEach((k) => translated = translated[k]);
      if (translated == null) {
        //print('No encuentra traducción');
        return key;
      }
      //print('Encontró traducción: ');
      //print(translated.toString());
      return translated.toString();
    } catch (e) {
      if (key == 'loginPage.user') {
        return 'Usuario';
      } else if (key == 'loginPage.password') {
        return 'Contraseña';
      } else if (key == 'loginPage.submit') {
        return 'Ingresar';
      }
      //print(e.toString());
      //print('dentro del catch');
      //print(key);
      return key;
    }
  }
}
