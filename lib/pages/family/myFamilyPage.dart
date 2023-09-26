/*
* This class will be use like a family profile, but is not implemmented yet
* */

import 'package:flutter/material.dart';
import 'package:perusano/components/bottomNavigation.dart';
import 'package:perusano/components/lateralMenu.dart';
import 'package:perusano/util/myColors.dart';

import '../../util/globalVariables.dart';

class MyFamilyPage extends StatelessWidget {
  var imageHeight = 75;
  var imageWidth = 75;
  var sizeOfFont = 22;
  var weightOfFont = FontWeight.bold;
  var containerRadius = 10;
  var containerMargin = EdgeInsets.fromLTRB(30, 30, 30, 0);
  var containerPadding = 20;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              "App title",
              style: TextStyle(color: Colors.white),
            ),
            Spacer(),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {},
              color: Colors.black,
            )
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      /*
      endDrawer: Drawer(
          child: ListView(padding: EdgeInsets.zero, children: <Widget>[
            DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.lightBlue,
                ),
                child: Column(
                  children: [],
                )),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Configuración'),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Redirigiendo a página de configuración')));
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Cerrar sesión'),
              onTap: () {},
            ),
          ])),*/

      endDrawer: LateralMenu(),
      body: ListView(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(0, 50, 0, 50),
            width: 100,
            height: 100,
            decoration:
                BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
            // child: Image.asset(
            //     '${GlobalVariables.publicAddress}familia_logo.png',
            //     height: imageHeight.toDouble(),
            //     width: imageWidth.toDouble()),
          ),
          Container(
            child: Text(
              'Mi familia',
              style: TextStyle(
                  fontSize: sizeOfFont.toDouble(), fontWeight: weightOfFont),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            padding: EdgeInsets.all(containerPadding.toDouble()),
            margin: containerMargin,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(containerRadius.toDouble()),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Image.asset(
                      '${GlobalVariables.publicAddress}madre_logo.png',
                      height: imageHeight.toDouble(),
                      width: imageWidth.toDouble()),
                ),
                Text('María Apellido',
                    style: TextStyle(
                        fontSize: sizeOfFont.toDouble(),
                        fontWeight: weightOfFont),
                    textAlign: TextAlign.center),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(containerPadding.toDouble()),
            margin: containerMargin,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(containerRadius.toDouble()),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Image.asset(
                      '${GlobalVariables.publicAddress}padre_logo.png',
                      height: imageHeight.toDouble(),
                      width: imageWidth.toDouble()),
                ),
                Text('José Apellido',
                    style: TextStyle(
                        fontSize: sizeOfFont.toDouble(),
                        fontWeight: weightOfFont),
                    textAlign: TextAlign.center),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(containerPadding.toDouble()),
            margin: containerMargin,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(containerRadius.toDouble()),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Image.asset(
                      '${GlobalVariables.publicAddress}bebe_logo.png',
                      height: imageHeight.toDouble(),
                      width: imageWidth.toDouble()),
                ),
                Text('Bebé Apellido',
                    style: TextStyle(
                        fontSize: sizeOfFont.toDouble(),
                        fontWeight: weightOfFont),
                    textAlign: TextAlign.center),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(containerPadding.toDouble()),
            margin: containerMargin,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(containerRadius.toDouble()),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Image.asset(
                      '${GlobalVariables.publicAddress}abuela_logo.png',
                      height: imageHeight.toDouble(),
                      width: imageWidth.toDouble()),
                ),
                Text('Abuelita Apellido',
                    style: TextStyle(
                        fontSize: sizeOfFont.toDouble() - 1,
                        fontWeight: weightOfFont),
                    textAlign: TextAlign.center),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationPage(),
    );
  }
}
