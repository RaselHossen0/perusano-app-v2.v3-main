import 'package:flutter/material.dart';
import 'package:perusano/util/globalVariables.dart';
import 'package:perusano/util/myColors.dart';
import 'package:perusano/components/bottomNavigation.dart';

import '../../services/translateService.dart';

class SettingsHome extends StatefulWidget {
  const SettingsHome({super.key});

  @override
  State<SettingsHome> createState() => _SettingsHomeState();
}

class _SettingsHomeState extends State<SettingsHome> {
  late int idFamily;
  List listaKid = [];

  var imageHeight = 75;
  var imageWidth = 75;
  var sizeOfFont = 18;
  var weightOfFont = FontWeight.bold;
  var containerRadius = 20;
  var containerMargin = 5;

  @override
  initState() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              '${GlobalVariables.appName} - ${TranslateService.translate('sidebar.settings')}',
              style: const TextStyle(color: Colors.black),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      bottomNavigationBar: BottomNavigationPage(),
    );
  }
}
