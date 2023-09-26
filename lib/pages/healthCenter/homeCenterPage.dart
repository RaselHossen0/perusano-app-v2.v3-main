/*
* This class is not used but it could be useful to health center view
* */

import 'package:flutter/material.dart';
import 'package:perusano/pages/cred/cred_principal_page.dart';
import 'package:perusano/pages/recipes/recipes_page.dart';
import 'package:perusano/util/myColors.dart';
import 'package:perusano/components/bottomNavigation.dart';
import 'package:perusano/components/lateralMenu.dart';

import '../../services/translateService.dart';
import '../../util/globalVariables.dart';
import 'chooseFamilyCenterPage.dart';

class HomeCenterPage extends StatefulWidget {
  @override
  State<HomeCenterPage> createState() => _HomeCenterPage();
}

class _HomeCenterPage extends State<HomeCenterPage> {
  var imageHeight = 75;
  var imageWidth = 75;
  var sizeOfFont = 18;
  var weightOfFont = FontWeight.bold;
  var containerRadius = 20;
  var containerMargin = 5;

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //getDestinos();
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              GlobalVariables.appName,
              style: TextStyle(color: Colors.black),
            ),
            Spacer(),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {},
              color: Colors.black,
            )
          ],
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      endDrawer: LateralMenu(),
      body: Container(
          child: GridView.count(
        primary: false,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 2,
        children: <Widget>[
          InkWell(
            child: Container(
              padding: const EdgeInsets.all(8),
              margin: EdgeInsets.all(containerMargin.toDouble()),
              decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(containerRadius.toDouble()),
                  color: AppColors.primary),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 5, 0, 10),
                    child: Image.asset('assets/images/cred_logo.png',
                        height: 90, width: 90),
                  ),
                  Text(TranslateService.translate('homePage.cred'),
                      style: TextStyle(
                          fontSize: sizeOfFont.toDouble(),
                          fontWeight: weightOfFont),
                      textAlign: TextAlign.center)
                ],
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChooseFamilyCenterPage()),
              );
            },
          ),
          Container(
            padding: const EdgeInsets.all(8),
            margin: EdgeInsets.all(containerMargin.toDouble()),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(containerRadius.toDouble()),
                color: AppColors.primary),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 5),
                  child: Image.asset(
                    'assets/images/informacion_logo.png',
                    height: 90,
                  ),
                ),
                Text(TranslateService.translate('homePage.information'),
                    style: TextStyle(
                        fontSize: sizeOfFont.toDouble(),
                        fontWeight: weightOfFont),
                    textAlign: TextAlign.center)
              ],
            ),
          ),
          InkWell(
            child: Container(
              padding: const EdgeInsets.all(8),
              margin: EdgeInsets.all(containerMargin.toDouble()),
              decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(containerRadius.toDouble()),
                  color: AppColors.primary),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 5, 0, 4),
                    child: Image.asset(
                      'assets/images/recetas_logo.png',
                      height: 100,
                    ),
                  ),
                  Text(TranslateService.translate('homePage.recipes'),
                      style: TextStyle(
                          fontSize: sizeOfFont.toDouble(),
                          fontWeight: weightOfFont),
                      textAlign: TextAlign.center)
                ],
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RecipesPage()),
              );
            },
          ),
          Container(
            padding: const EdgeInsets.all(8),
            margin: EdgeInsets.all(containerMargin.toDouble()),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(containerRadius.toDouble()),
                color: AppColors.primary),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 8),
                  child: Image.asset(
                    'assets/images/calendario_logo.png',
                    height: 100,
                  ),
                ),
                Text(TranslateService.translate('homePage.calendar'),
                    style: TextStyle(
                        fontSize: sizeOfFont.toDouble(),
                        fontWeight: weightOfFont),
                    textAlign: TextAlign.center)
              ],
            ),
          ),
          /*Container(
                padding: const EdgeInsets.all(8),
                margin: EdgeInsets.all(containerMargin.toDouble()),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(containerRadius.toDouble()),
                    color: AppColors.primary),
                child: Column(
                  children: [
                    Container(
                      child: Image.asset(
                        'assets/images/preguntas_frecuentes_logo.png',
                        height: 100,
                      ),
                    ),
                    Text(TranslateService.translate('homePage.common_questions'),
                        style: TextStyle(
                            fontSize: sizeOfFont.toDouble(),
                            fontWeight: weightOfFont),
                        textAlign: TextAlign.center)
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                margin: EdgeInsets.all(containerMargin.toDouble()),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(containerRadius.toDouble()),
                    color: AppColors.primary),
                child: Column(
                  children: [
                    Container(
                      child: Image.asset(
                        'assets/images/grupos_de_apoyo_logo.png',
                        height: 100,
                      ),
                    ),
                    Text(TranslateService.translate('homePage.support_groups'),
                        style: TextStyle(
                            fontSize: sizeOfFont.toDouble(),
                            fontWeight: weightOfFont),
                        textAlign: TextAlign.center)
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                margin: EdgeInsets.all(containerMargin.toDouble()),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(containerRadius.toDouble()),
                    color: AppColors.primary),
                child: Column(
                  children: [
                    Container(
                      child: Image.asset(
                        'assets/images/recordatorios_logo.png',
                        height: 100,
                      ),
                    ),
                    Text(TranslateService.translate('homePage.reminders'),
                        style: TextStyle(
                            fontSize: sizeOfFont.toDouble(),
                            fontWeight: weightOfFont),
                        textAlign: TextAlign.center)
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                margin: EdgeInsets.all(containerMargin.toDouble()),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(containerRadius.toDouble()),
                    color: AppColors.primary),
                child: Column(
                  children: [
                    Container(
                      child: Image.asset(
                        'assets/images/buzon_de_sugerencias_logo.png',
                        height: 100,
                      ),
                    ),
                    Text(TranslateService.translate('homePage.suggestion_box'),
                        style: TextStyle(
                            fontSize: sizeOfFont.toDouble(),
                            fontWeight: weightOfFont),
                        textAlign: TextAlign.center)
                  ],
                ),
              ),*/
        ],
      )),
      bottomNavigationBar: BottomNavigationPage(),
    );
  }
}
