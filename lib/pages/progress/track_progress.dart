import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:perusano/pages/progress/viewTasks.dart';
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
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              color: Colors.grey[100],
            ),
            //3 buttons
            Positioned(
              top: 60,
              width: MediaQuery.of(context).size.width,
              child: ClipPath(
                clipper: BottomClipper(),
                child: Container(
                  height: 130,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 18.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Container(
                            height: 60,
                            width: 60,
                            color: Colors.orange,
                            child: Center(
                              child: Icon(
                                Icons.manage_accounts,
                                size: 40,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            print("hi");
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>viewAllTasks()));
                          //  Get.to(()=>viewAllTasks());
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Container(
                              height: 60,
                              width: 60,
                              color: Colors.deepPurpleAccent,
                              child: Center(
                                child: Icon(
                                  Icons.manage_accounts,
                                  size: 40,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Container(
                            height: 60,
                            width: 60,
                            color: Colors.green,
                            child: Center(
                              child: Icon(
                                Icons.manage_accounts,
                                size: 40,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            //roadmap text
            Positioned(
              top: 0,
              // bottom: MediaQuery.of(context).size.height * 0.09,
              child: Container(
                margin: const EdgeInsets.fromLTRB(0, 3, 0, 0),
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
            ),
            Positioned(
                top: 170,
                height: MediaQuery.of(context).size.height * 0.55,
                // width: MediaQuery.of(context).size.width,
                left: 10,
                right: 10,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  //  verticalDirection: VerticalDirection.up,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Container(
                            height: 50,
                            width: 50,
                            color: Colors.deepPurpleAccent,
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Container(
                            height: 70,
                            width: 250,
                            color: Colors.greenAccent,
                          ),
                        ),
                      ],
                    )
                  ],
                ))
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationPage(),
    );
  }
}

class AdditionalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 0); // Start from the top-left
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close(); // Close the path
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class BottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 50); // Start from the top-left
    path.quadraticBezierTo(size.width / 2, size.height, size.width,
        size.height - 50); // Create a quadratic Bezier curve for the bottom
    path.lineTo(size.width, 0); // Close the path
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
