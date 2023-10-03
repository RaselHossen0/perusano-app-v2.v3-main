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

class task{
  final  path;
  final  text1;
  final  text2;
  bool selected = false;
  task(this.path, this.text1, this.text2,{required this.selected});
}

class viewAllTasks extends StatefulWidget {
  @override
  State<viewAllTasks> createState() => _RecipesPage();
}

// const List tags = [
//   'recipePage.allTag',
//   'recipePage.fruitTag',
//   'recipePage.vegTag',
//   'recipePage.nutrientTag'
// ];

const List tags = ['recipePage.allTag', '6-8', '9-11', '12-23'];

class _RecipesPage extends State<viewAllTasks> {
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

  var images=[
    'assets/taskPicture/1month1.png',
    'assets/taskPicture/1month2.png',
    'assets/taskPicture/1month3.png',
    'assets/taskPicture/1month14.png',
    'assets/taskPicture/1month5.png',
    'assets/taskPicture/1month6.png',
    'assets/taskPicture/1month7.png',
    'assets/taskPicture/1month8.png',
    'assets/taskPicture/1month8.png',
    'assets/taskPicture/1month10.png',
    'assets/taskPicture/1month11.png',
    'assets/taskPicture/2month1.png',
    'assets/taskPicture/2months2.png',
    'assets/taskPicture/2months3.png',
    'assets/taskPicture/2months4.png',
    'assets/taskPicture/2months5.png',
    'assets/taskPicture/3months1.png',
    'assets/taskPicture/3months2.png',
    'assets/taskPicture/3months3.png',
    'assets/taskPicture/3months4.png',
    'assets/taskPicture/3months5.png',
    'assets/taskPicture/3months6.png',
    'assets/taskPicture/3months7.png',
    'assets/taskPicture/3months8.png',
    'assets/taskPicture/4months1.png',
    'assets/taskPicture/7months1.png',
    'assets/taskPicture/10months1.png',
    'assets/taskPicture/11months1.png',
    'assets/taskPicture/21months1.png',


  ];
  var text1s = [
    'Seated head ad trunk control:',
    'Seated head and trunk control:',
    'Seated head and trunk control:',
    'Seated head and trunk control:',
    'Seated head and trunk control:',
    'Seated head and trunk control:',
    'Seated head and trunk control:',
    'Seated head and trunk control:',
    'Seated head and trunk control:',
    'Seated head and trunk control:',
    'Seated head and trunk control:',
    'Seated head and trunk control:',
    'Seated head and trunk control:',
    'Seated head and trunk control:','Seated head and trunk control:','Seated head and trunk control:','Seated head and trunk control:',
    'Seated head and trunk control:','Seated head and trunk control:','Seated head and trunk control:','Seated head and trunk control:',
    'Seated head and trunk control:','Seated head and trunk control:','Seated head and trunk control:','Seated head and trunk control:',
    'Seated head and trunk control:','Seated head and trunk control:','Seated head and trunk control:','Seated head and trunk control:',


  ];

  var text2s = [
    'symmetrical arm and leg movements','symmetrical arm and leg movements','symmetrical arm and leg movements','symmetrical arm and leg movements',
    'symmetrical arm and leg movements','symmetrical arm and leg movements','symmetrical arm and leg movements','symmetrical arm and leg movements',
    'symmetrical arm and leg movements','symmetrical arm and leg movements','symmetrical arm and leg movements','symmetrical arm and leg movements',
    'symmetrical arm and leg movements','symmetrical arm and leg movements','symmetrical arm and leg movements','symmetrical arm and leg movements',
    'symmetrical arm and leg movements','symmetrical arm and leg movements','symmetrical arm and leg movements','symmetrical arm and leg movements',
    'symmetrical arm and leg movements','symmetrical arm and leg movements','symmetrical arm and leg movements','symmetrical arm and leg movements',
    'symmetrical arm and leg movements','symmetrical arm and leg movements','symmetrical arm and leg movements','symmetrical arm and leg movements',
    'symmetrical arm and leg movements',


  ];
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
            Container(
           decoration: BoxDecoration(
           color: Color(0xffa2b9ee)
            ),

              height: MediaQuery.of(context).size.height  * 0.1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(

                      width: MediaQuery.of(context).size.width *.4 ,
                      child: Text('Progress tracket for your child')
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 13.0), // Add padding only from the left
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.3,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    child: Center(
                      child: Text('4/11 events completed'),
                    ),
                  )


                ],
              ),

            ),
            SizedBox(
              height: 20.0,
            ),
            SizedBox(height: MediaQuery.of(context).size.height*0.68,
            child: ListView.builder(
              itemCount: images.length,
                itemBuilder: (context,index){
                return Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            "${index+1}. Seated head and trunk control:",
                            style: TextStyle(
                              fontSize: 15.9,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          // Add more widgets or text here if needed
                        ],
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      Row(
                        children: [
                          // Child 1: Picture
                          Image.asset(
                            images[index], // Replace with your image asset path
                            width: 50, // Adjust the width as needed
                            height: 50, // Adjust the height as needed
                          ),

                          // Child 2: Text
                          Text(
                            'symmetrical arm and leg movements',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 1.0),
                            height: 50,
                            width: MediaQuery.of(context).size.width * 0.3,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                            child: Center(
                              child: Text('YES'), // Wrap the Text widget inside Center's child property
                            ),
                          ),

                          Container(
                            // padding: EdgeInsets.only(left: 13.0),
                            height: 50,
                            width: MediaQuery.of(context).size.width * 0.3,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                            child: Center(
                              child: Text('NO'),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(
                        height: 8.0,
                      ),
                      Container(
                        width: 300.0, // Set the desired width
                        child: Divider(
                          color: Colors.black, // You can specify the color of the divider
                          thickness: 1.0,     // You can adjust the thickness of the divider
                        ),
                      )


                    ],
                  ),
                );

            }),),



          ],

        ),

      ),
      bottomNavigationBar: BottomNavigationPage(),
    );
  }
}


