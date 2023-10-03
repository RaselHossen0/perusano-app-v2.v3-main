import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

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

  var allTasks = [
    'Control de cabeza y tronco sentado',
    'Control de Apoyo inable светра cabeza y tronco rotaciones',
    'Control de cabeza y tronco de marcha',
    'Uso del brazo y mano',
    'Vision',
    'Audición',
    'Lenguaje comprensivo',
    'Lenguaje expresivo',
    'Juego',
    "Identifica fu inteligencia y aprendizaje",
    'Lenguaje expresivo',
    'Juego',
    "Identifica fu inteligencia y aprendizaje"
  ];

  @override
  Widget build(BuildContext context) {
    var wid = MediaQuery.of(context).size.width;
    var hi = MediaQuery.of(context).size.height;
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
              top: hi * 0.09,
              width: MediaQuery.of(context).size.width,
              child: ClipPath(
                clipper: BottomClipper(),
                child: Container(
                  height: hi * 0.18,
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
                        ClipRRect(
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
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Container(
                            height: 60,
                            width: 60,
                            color: Color(0xff8AD879),
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
                color: Color(0xffA2B9EE),
                child: Center(
                  child: Text(
                    TranslateService.translate('progress.roadmap'),
                    style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 18),
                  ),
                ),
              ),
            ),
            Positioned(
                top: hi * 0.235,
                height: MediaQuery.of(context).size.height * 0.56,
                // width: MediaQuery.of(context).size.width,
                left: 10,
                right: 10,
                child: SingleChildScrollView(
                  reverse: true,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    verticalDirection: VerticalDirection.up,
                    children: [
                      for (var index = 0; index < allTasks.length; index++)
                        //odd number
                        if ((index + 1) % 2 != 0) ...[
                          if (index != 0) ...[
                            SizedBox(
                              height: hi * 0.07,
                            ),
                            CustomPaint(
                              size: Size(MediaQuery.of(context).size.width,
                                  20), // Adjust the size as needed
                              painter: CurvedDashedLinePainter1(),
                            )
                          ],
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              //task number with tick check
                              Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                          color: Colors.pink[600],
                                          border: Border.all(
                                            color: Colors.pinkAccent.shade100,
                                            width: 3,
                                          ),
                                          shape: BoxShape.circle),
                                      child: Center(
                                        child: Text(
                                          '${index + 1}',
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ),
                                  ),
                                  //tick icon
                                  Positioned(
                                    left: 36,
                                    child: Container(
                                      height: 14,
                                      width: 14,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          color: Colors.blueAccent),
                                      child: Icon(
                                        Icons.check,
                                        size: 14,
                                        color: Colors.white,
                                        weight: 30,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              //task description
                              ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Container(
                                  height: hi * 0.13,
                                  width: wid * 0.69,
                                  padding: EdgeInsets.all(8),
                                  color: Color(0xffd4af37),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: Center(
                                              child: Text('${allTasks[index]}',
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w500,
                                                  )))),
                                      Expanded(
                                        child: Container(
                                          height: 70,
                                          padding: EdgeInsets.only(left: 18),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: Color(0xfff53e05)),
                                          child: Center(
                                            child: Text(
                                                "Click to complete the challenge!",
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white)),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ] else ...[
                          if (index == 0)
                            SizedBox(
                              height: hi * 0.01,
                            ),
                          if (index != 0) ...[
                            // SizedBox(
                            //   height: hi * 0.07,
                            // ),
                            // CustomPaint(
                            //   size: Size(MediaQuery.of(context).size.width,
                            //       20), // Adjust the size as needed
                            //   painter: CurvedDashedLinePainter(),
                            // )
                          ],
                          SizedBox(
                            height: hi * 0.07,
                          ),
                          CustomPaint(
                            size: Size(MediaQuery.of(context).size.width,
                                20), // Adjust the size as needed
                            painter: CurvedDashedLinePainter(),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Container(
                                  padding: EdgeInsets.all(9),
                                  height: hi * 0.15,
                                  width: wid * 0.65,
                                  color: Color(0xff8AD879),
                                  child: Center(
                                      child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text('${allTasks[index]}'),
                                      const Divider(
                                        color: Color(0xffAAAFB4),
                                        height: 3,
                                        thickness: 2,
                                        indent: 50,
                                        endIndent: 50,
                                      ),
                                      Text(
                                        'Date: 25.08.2023',
                                        style:
                                            TextStyle(color: Color(0xffF53E05)),
                                      )
                                    ],
                                  )),
                                ),
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                      color: Colors.deepPurpleAccent,
                                      border: Border.all(
                                        color: Colors.pink,
                                        width: 3,
                                      ),
                                      shape: BoxShape.circle),
                                  child: Center(
                                    child: Text(
                                      '${index + 1}',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ]
                    ],
                  ),
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

class CurvedDashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0xffAAAFB4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0
      ..strokeCap = StrokeCap.round // Use round caps for dots
      ..strokeJoin = StrokeJoin.round; // Use round joins for dots

    final path = Path()
      ..moveTo(size.width * 0.06, size.height * 21.8) // Start point on the left
      ..quadraticBezierTo(
        size.width * 0.31, size.height * 20, // Control point
        size.width * 0.93, size.height * 15.6, // End point on the right
      );
    // Calculate the length of the path
    final pathLength = _computePathLength(path);

    final double dashWidth = 5.0; // Width of each dash
    final double dashSpace = 20.0; // Space between dashes
    double currentDashStart = 0.0;

    while (currentDashStart < pathLength) {
      // Calculate the position on the curve for the start and end of the dash
      final dashStartPoint = _getPointOnPath(path, currentDashStart);
      final dashEndPoint = _getPointOnPath(path, currentDashStart + dashWidth);

      canvas.drawLine(dashStartPoint!, dashEndPoint!, paint);

      // Move to the starting point of the next dash
      currentDashStart += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

  // Calculate the length of a path by iterating through its segments
  double _computePathLength(Path path) {
    double length = 0;
    final pathMetrics = path.computeMetrics();
    for (final pathMetric in pathMetrics) {
      length += pathMetric.length;
    }
    return length;
  }

  // Get a point on the path at a specific distance from the start
  Offset? _getPointOnPath(Path path, double distance) {
    final pathMetrics = path.computeMetrics();
    for (final pathMetric in pathMetrics) {
      if (pathMetric.length >= distance) {
        return pathMetric.getTangentForOffset(distance)?.position;
      }
      distance -= pathMetric.length;
    }
    return Offset(
        0, 0); // Handle the case where distance exceeds the path length
  }
}

class CurvedDashedLinePainter1 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0xff7FD8BE)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0
      ..strokeCap = StrokeCap.round // Use round caps for dots
      ..strokeJoin = StrokeJoin.round; // Use round joins for dots

    final path = Path()
      ..moveTo(size.width * 0.1, -size.height) // Start point on the left
      ..quadraticBezierTo(
        size.width * 0.59, size.height * 3, // Control point
        size.width * 0.94, size.height * 5, // End point on the right
      );
    // Calculate the length of the path
    final pathLength = _computePathLength(path);

    final double dashWidth = 5.0; // Width of each dash
    final double dashSpace = 20.0; // Space between dashes
    double currentDashStart = 0.0;

    while (currentDashStart < pathLength) {
      // Calculate the position on the curve for the start and end of the dash
      final dashStartPoint = _getPointOnPath(path, currentDashStart);
      final dashEndPoint = _getPointOnPath(path, currentDashStart + dashWidth);

      canvas.drawLine(dashStartPoint!, dashEndPoint!, paint);

      // Move to the starting point of the next dash
      currentDashStart += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

  // Calculate the length of a path by iterating through its segments
  double _computePathLength(Path path) {
    double length = 0;
    final pathMetrics = path.computeMetrics();
    for (final pathMetric in pathMetrics) {
      length += pathMetric.length;
    }
    return length;
  }

  // Get a point on the path at a specific distance from the start
  Offset? _getPointOnPath(Path path, double distance) {
    final pathMetrics = path.computeMetrics();
    for (final pathMetric in pathMetrics) {
      if (pathMetric.length >= distance) {
        return pathMetric.getTangentForOffset(distance)?.position;
      }
      distance -= pathMetric.length;
    }
    return Offset(
        0, 0); // Handle the case where distance exceeds the path length
  }
}
