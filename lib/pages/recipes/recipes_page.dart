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
import 'create_recipe_page.dart';

class RecipesPage extends StatefulWidget {
  final String age;
  RecipesPage(this.age);
  @override
  State<RecipesPage> createState() => _RecipesPage();
}

// const List tags = [
//   'recipePage.allTag',
//   'recipePage.fruitTag',
//   'recipePage.vegTag',
//   'recipePage.nutrientTag'
// ];

const List tags = ['0-2', '3-5', '6-8', '9-11', '12-23'];

class _RecipesPage extends State<RecipesPage> {
  late int recipeChoosen;

  List dataObt = [];
  List data = [];
  List visibleTiles = [];
  var sizeOfFont = 48;
  var weightOfFont = FontWeight.bold;
  var imageHeight = 25;
  var imageWidth = 25;

  final List<bool> _selectedTag = [true, false, false, false];
  String _selectedTagValue = '0-2';

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
      // if (_selectedTagValue == 'recipePage.allTag') {
      //   visibleTiles = data;
      // } else {
      visibleTiles = data.where(
        (recipe) {
          print(_selectedTagValue);
          return recipe['age_tag']['value']
              .toString()
              .contains(_selectedTagValue);
        },
      ).toList();
      //   }
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

  int calculateAgeInMonths(String birthday) {
    DateTime nacimiento = DateTime.parse(birthday);
    DateTime fechaRegistro = DateTime.now();

    int edadMeses = 0;

    int anios = fechaRegistro.year - nacimiento.year;
    if (fechaRegistro.month < nacimiento.month ||
        (fechaRegistro.month == nacimiento.month &&
            fechaRegistro.day < nacimiento.day)) {
      anios--;
    }

    edadMeses = anios * 12 + (fechaRegistro.month - nacimiento.month);

    return edadMeses;
  }

  int selectTagByAge(int ageInMonths, List<String> tags) {
    if (ageInMonths <= 2) {
      return 0; // 'recipePage.allTag'
    } else if (ageInMonths <= 5) {
      return 1;
    } else if (ageInMonths <= 8) {
      return 2; // '6-8'
    } else if (ageInMonths <= 11) {
      return 3; // '9-11'
    } else {
      return 4; // '12-23'
    }
  }

  @override
  initState() {
    super.initState();
    loadRecipe();

    setState(() {
      int index = selectTagByAge(calculateAgeInMonths(widget.age),
          ['0-2', '3-5', '6-8', '9-11', '12-23']);
      visibleTiles.clear();
      print(index);
      // The button that is tapped is set to true, and the others to false.
      for (int i = 0; i < _selectedTag.length; i++) {
        _selectedTag[i] = i == index;
      }
      _selectedTagValue = tags[index];
    });
    actualizar();
    loadRecipe();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              TranslateService.translate('homePage.recipes'),
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
      body: Container(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
          child: Column(
            children: [
              // SingleChildScrollView(
              //   scrollDirection: Axis.horizontal,
              //   child: ToggleButtons(
              //     direction: Axis.horizontal,
              //     onPressed: (int index) {
              //       setState(() {
              //         visibleTiles.clear();
              //         // The button that is tapped is set to true, and the others to false.
              //         for (int i = 0; i < _selectedTag.length; i++) {
              //           _selectedTag[i] = i == index;
              //         }
              //         _selectedTagValue = tags[index];
              //       });
              //       actualizar();
              //       loadRecipe();
              //     },
              //     fillColor: Colors.white,
              //     splashColor: Colors.white,
              //     renderBorder: false,
              //     constraints: const BoxConstraints(
              //       minHeight: 40.0,
              //       minWidth: 80.0,
              //     ),
              //     isSelected: _selectedTag,
              //     children: List.generate(
              //       tags.length,
              //       (index) => Container(
              //         margin: const EdgeInsets.fromLTRB(5, 10, 5, 10),
              //         height: 40,
              //         width: 80,
              //         alignment: Alignment.center,
              //         decoration: BoxDecoration(
              //             border: Border.all(color: Colors.blueGrey),
              //             borderRadius: BorderRadius.circular(20),
              //             color: _selectedTag[index]
              //                 ? AppColors.colorRecipes
              //                 : null),
              //         child: Text(
              //           TranslateService.translate(tags[index]),
              //           style: const TextStyle(color: Colors.black),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              Expanded(
                child: GridView.builder(
                  itemCount: visibleTiles.length,
                  itemBuilder: (BuildContext context, int index) {
                    // print('');
                    // print(data[index]['title']);
                    // if (_selectedTagValue == 'recipePage.allTag') {
                    //   print('all tag');
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color.fromARGB(255, 236, 239, 241),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0.0, 5.0),
                            blurStyle: BlurStyle.normal,
                            blurRadius: 2,
                          ),
                        ],
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      child: Container(
                        child: OutlinedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20))),
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.black),
                            padding: MaterialStateProperty.all(
                              const EdgeInsets.fromLTRB(20, 10, 20, 5),
                            ),
                          ),
                          onPressed: () async {
                            if (await isConnected) {
                              asignRecipe(visibleTiles[index]['id']);
                            } else {
                              asignRecipe(visibleTiles[index]['idLocal']);
                            }
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => InsideRecipesPage(
                                        idRecipeChoosen: recipeChoosen,
                                      )),
                            );
                          },
                          child: Column(
                            children: [
                              Flexible(
                                flex: 4,
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    '${visibleTiles[index]['title']}',
                                    style: TextStyle(
                                        fontSize: 16, fontWeight: weightOfFont),
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.visible,
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 8,
                                child: Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 5),
                                  child: FutureBuilder(
                                    future: obtenerImagen(
                                        visibleTiles[index]['id'],
                                        visibleTiles[index]['url_photo'] ?? ''),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return snapshot.requireData;
                                      } else {
                                        return const CircularProgressIndicator();
                                      }
                                    },
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 2,
                                child: Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Container(
                                      //   margin: const EdgeInsets.fromLTRB(
                                      //       0, 0, 0, 0),
                                      //   child: Text(
                                      //     '${visibleTiles[index]['age_tag']['value']} ${TranslateService.translate('recipePage.months')}',
                                      //     style: const TextStyle(fontSize: 10),
                                      //   ),
                                      // ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.fromLTRB(
                                                0, 0, 0, 0),
                                            child: Text(
                                                '${visibleTiles[index]['total_likes']}'),
                                          ),
                                          Container(
                                            child: IconButton(
                                              padding: const EdgeInsets.all(0),
                                              constraints: BoxConstraints.tight(
                                                  const Size.fromWidth(20)),
                                              onPressed: () {
                                                visibleTiles[index]
                                                        ['is_liked_by_me'] =
                                                    !visibleTiles[index]
                                                        ['is_liked_by_me'];
                                              },
                                              icon: visibleTiles[index]
                                                      ['is_liked_by_me']
                                                  ? const Icon(
                                                      Icons.favorite,
                                                      color: Colors.red,
                                                    )
                                                  : const Icon(
                                                      Icons.favorite_border),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: const [
                                    Text('Ver Receta'),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 15,
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      childAspectRatio: 0.75),
                ),
              ),
            ],
          )),
      bottomNavigationBar: BottomNavigationPage(),
      // floatingActionButton: Container(
      //   height: 50,
      //   width: GlobalVariables.language == 'ES' ? 150 : 135,
      //   decoration: BoxDecoration(
      //     borderRadius: BorderRadius.circular(20),
      //   ),
      //   child: ElevatedButton(
      //     onPressed: () {
      //       Navigator.push(
      //         context,
      //         MaterialPageRoute(builder: (context) => CreateRecipesPage()),
      //       ).then(onGoBack);
      //     },
      //     style: ButtonStyle(
      //       backgroundColor:
      //           MaterialStateProperty.all<Color>(AppColors.colorAddButtons),
      //       foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
      //       shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      //         RoundedRectangleBorder(
      //           borderRadius: BorderRadius.circular(25),
      //         ),
      //       ),
      //     ),
      //     child: Row(
      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //       children: [
      //         const Icon(Icons.add_circle),
      //         Text(
      //           TranslateService.translate('recipePage.add_recipe'),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
