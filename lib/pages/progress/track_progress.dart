import 'dart:async';
import 'dart:convert';
import 'dart:developer';


import 'package:flutter/material.dart';
import 'package:perusano/pages/recipes/inside_recipes_page.dart';
import 'package:perusano/services/apis/recipe/recipesService.dart';
import 'package:perusano/util/myColors.dart';
import 'package:perusano/components/bottomNavigation.dart';
import 'package:perusano/components/lateralMenu.dart';

import '../../services/fileManagement/recipes/recipeFM.dart';
import '../../services/translateService.dart';
import '../../util/globalVariables.dart';

class TrackProgress extends StatefulWidget {
  @override
  State<TrackProgress> createState() => _RecipesPage();
}

// const List tags = [
//   'recipePage.allTag',
//   'recipePage.fruitTag',
//   'recipePage.vegTag',
//   'recipePage.nutrientTag'
// ];

const List tags = ['recipePage.allTag', '6-8', '9-11', '12-23'];

class _RecipesPage extends State<TrackProgress> {
  late int recipeChoosen;

  List dataObt = [];
  List data = [];
  List visibleTiles = [];
  var sizeOfFont = 48;
  var weightOfFont = FontWeight.bold;
  var imageHeight = 25;
  var imageWidth = 25;

  final List<bool> _selectedTag = [true, false, false, false];
  String _selectedTagValue = 'recipePage.allTag';

  var lightColor = const Color.fromRGBO(189, 236, 182, 100);
  var buttonColor = const Color.fromRGBO(61, 141, 10, 100);

  final isConnected = GlobalVariables.isConnected();
  final RecipeFM _recipeStorage = RecipeFM();

  // Gets download recipes from local storage or, if exist a connection, all recipes from network database.
  loadRecipe() async {
    if (await isConnected) {
      dataObt = await RecipesService().getRecipes();
    } else {
      dataObt = await _recipeStorage.readFile();
    }
    String recipesFile = await DefaultAssetBundle.of(context)
        .loadString('assets/documents/recipes.json');
    List jsonResult = jsonDecode(recipesFile);

    if (!dataObt.toString().contains(jsonResult.toString())) {
      registerDefaultRecipe(jsonResult);
    }

    List dataFiltrada = [];
    for (var value in dataObt) {
      if (value['statusId'] == 1) {
        dataFiltrada.add(value);
      }
    }
    setState(() {
      data = dataFiltrada;
      if (_selectedTagValue == 'recipePage.allTag') {
        visibleTiles = data;
      } else {
        visibleTiles = data.where(
          (recipe) {
            return recipe['age_tag']['value']
                .toString()
                .contains(_selectedTagValue);
          },
        ).toList();
      }
      // for (var recipe in data) {
      //   String dataTags = recipe['age_tag']['value'].toString();
      //   print('here');
      //   if (dataTags.contains(_selectedTagValue)) {
      //     visibleTiles.add(recipe);
      //   }
      // }
    });
  }

  registerDefaultRecipe(recipes) async {
    for (var recipe in recipes) {
      await _recipeStorage.writeRegister(recipe);
    }
    loadRecipe();
  }

  // Gets recipes image from local storage or, if exist a connection, from network database.
  Future<Widget> obtenerImagen(int id, String urlLocal) async {
    if (await isConnected) {
      Map dataTemp = await RecipesService().getRecipeImageById(id);
      return Image.network(
        '${GlobalVariables.endpoint}/' + dataTemp['path'],
        height: 200,
        width: 300,
      );
    } else {
      return Image.asset(
        urlLocal,
        // File(urlLocal),
        height: 200,
        width: 300,
      );
    }
  }

  // Asign recipe tag
  asignRecipe(int id) {
    recipeChoosen = id;
  }

  actualizar() {
    setState(() {
      loadRecipe();
    });
  }

  FutureOr onGoBack(dynamic value) {
    loadRecipe();
    setState(() {});
  }

  @override
  initState() {
    super.initState();
    loadRecipe();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              TranslateService.translate('homePage.progress_tracker'),
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.colorRecipes,
        elevation: 0,
      ),
      endDrawer: LateralMenu(),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            //roadmap text
            Container(
              margin: const EdgeInsets.fromLTRB(0, 7, 0, 0),
              height: MediaQuery.of(context).size.height * 0.09,
              width: MediaQuery.of(context).size.width,
              color: Colors.indigo[300]?.withOpacity(0.8),
              child: Center(
                child: Text(
                  TranslateService.translate('progress.roadmap'),
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 16),
                ),
              ),
            ),
            Container(
              color: Colors.white,
              child: Row(
                children: [],
              ),
            ),

          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationPage(),
    );
  }
}
