import 'package:flutter/material.dart';
import 'package:perusano/pages/join/loginPage.dart';
import 'package:perusano/pages/settings/settings_home.dart';
import 'package:perusano/services/translateService.dart';
import 'package:perusano/util/globalVariables.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/synchronization/upload.dart';
import '../util/controller/connectionStatus/connectionStatusController.dart';

final internetController = Get.put(ConnectionStatusController());

class LateralMenu extends StatelessWidget {
  //permitirDeslogueo will show us logout button, but is just for tests because the app will no allow to logout to the families.
  permitirDeslogueo(BuildContext context) async {
    bool isConnected = await GlobalVariables.isConnected();

    if (isConnected) {
      await cerrarSesion();
      /*Navigator.popUntil(context, ModalRoute.withName('/'));
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );*/
      Navigator.of(context).popUntil(ModalRoute.withName("/login"));
    } else {}
  }

  //CerrarSesion allow us to logout, but is just for tests because the app will no allow to logout to the families.
  cerrarSesion() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', '');
    prefs.setInt('idUser', 0);
    prefs.setString('username', '');
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(padding: EdgeInsets.zero, children: <Widget>[
      DrawerHeader(
          decoration: const BoxDecoration(
            color: Colors.lightBlue,
          ),
          child: Column(
            children: [],
          )),
      ListTile(
        leading: const Icon(Icons.settings),
        title: Text(TranslateService.translate('sidebar.settings')),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SettingsHome()),
          );
          //UploadService().uploadData();
        },
      ),
      ListTile(
        leading: const Icon(Icons.language),
        title: Text(TranslateService.translate('settings.language')),
        onTap: () {
          if (GlobalVariables.language == 'ES') {
            GlobalVariables.language = 'EN';
          } else if (GlobalVariables.language == 'EN') {
            GlobalVariables.language = 'ES';
          }
          TranslateService.load();
        },
      ),
      ListTile(
        leading: const Icon(Icons.logout),
        title: Text('${TranslateService.translate('sidebar.exit')}(Test only)'),
        onTap: () {
          //permitirDeslogueo(context);
        },
      ),
    ]));
  }
}
