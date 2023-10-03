import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:perusano/pages/cred/cred_principal_page.dart';
import 'package:perusano/pages/progress/track_progress.dart';

import 'package:perusano/pages/recipes/recipes_page.dart';
import 'package:perusano/pages/sharedExperiences/shared_experiences.dart';
import 'package:perusano/util/globalVariables.dart';
import 'package:perusano/util/myColors.dart';
import 'package:perusano/components/bottomNavigation.dart';
import 'package:perusano/components/lateralMenu.dart';

import '../services/fileManagement/family/kidFM.dart';
import '../services/translateService.dart';
import '../util/internVariables.dart';
import 'calendar/calendar_page.dart';
import 'family/kids/create_kid_page.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int idFamily = InternVariables.idFamily;
  var imageHeight = 75;
  var imageWidth = 75;
  var sizeOfFont = 18;
  var weightOfFont = FontWeight.bold;
  var containerRadius = 20;
  var containerMargin = 15;

  final KidFM storage = KidFM();

  List data = [];
  List dataObt = [];

  bool cargado = false;

  //This method calculates the age of the kid
  calculateAge(String birthday) {
    String difference =
        DateTime.now().difference(DateTime.parse(birthday)).toString();
    DateTime nacimiento = DateTime.parse(birthday);
    DateTime fechaRegistro = DateTime.now();

    int edadMeses = 0;

    int anios = fechaRegistro.year - nacimiento.year;
    if (fechaRegistro.month < nacimiento.month) {
      anios = anios - 1;
      edadMeses = anios * 12;
      int meses = 12 - (nacimiento.month - fechaRegistro.month);
      if (fechaRegistro.day < nacimiento.day) {
        meses = meses - 1;
        edadMeses = edadMeses + meses;
      } else {
        edadMeses = edadMeses + meses;
      }
    } else if (fechaRegistro.month == nacimiento.month) {
      if (fechaRegistro.day < nacimiento.day) {
        anios = anios - 1;
        edadMeses = (anios * 12) + 11;
      } else {
        edadMeses = anios * 12;
      }
    } else {
      edadMeses = anios * 12;
      int meses = fechaRegistro.month - nacimiento.month;
      if (fechaRegistro.day < nacimiento.day) {
        meses = meses - 1;
        edadMeses = edadMeses + meses;
      } else {
        edadMeses = edadMeses + meses;
      }
    }
    if (edadMeses < 1) {
      int age = (double.parse(difference.split(':')[0]) / 24).round();
      return '${age} ${TranslateService.translate('homePage.days')}';
    }
    return '${edadMeses} ${TranslateService.translate('homePage.months')}';
  }

  // Loads the data from local storage
  loadKids() async {
    dataObt = await storage.readFile();

    setState(() {
      data = dataObt;
    });

    setState(() {
      cargado = true;
    });
  }

  actualizar() {
    setState(() {
      loadKids();
    });
  }

  @override
  initState() {
    super.initState();
    loadKids();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              GlobalVariables.appName,
              style: const TextStyle(color: Colors.black),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.search),
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
      body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 50),
          child: Container(
            margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: Text(
                    TranslateService.translate('homePage.overview_title'),
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Builder(
                  builder: (context) {
                    if (data.isNotEmpty && cargado) {
                      return Column(
                        children: data.map(
                          (text) {
                            return Container(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: AppColors.colorOverview,
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.grey,
                                      offset: Offset(0.0, 5.0),
                                      blurStyle: BlurStyle.normal,
                                      blurRadius: 2,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      height: 150,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: AppColors.colorOverview,
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Colors.grey,
                                            offset: Offset(0.0, 5.0),
                                            blurStyle: BlurStyle.normal,
                                            blurRadius: 2,
                                          ),
                                        ],
                                      ),
                                      margin: const EdgeInsets.fromLTRB(
                                          20, 20, 20, 20),
                                      child: InkWell(
                                        onTap: () {
                                          InternVariables.kid['id'] =
                                              text['id'];
                                          InternVariables.kid['idLocal'] =
                                              text['idLocal'];
                                          InternVariables.kid['names'] =
                                              text['names'];
                                          InternVariables.kid['birthday'] =
                                              text['dateRaw'];
                                          InternVariables.kid['gender'] =
                                              text['gender'];
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CredPrincipalPage(
                                                        idKid:
                                                            text['idLocal'])),
                                          );
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.fromLTRB(
                                                  20, 20, 20, 20),
                                              child: Image.asset(
                                                '${GlobalVariables.publicAddress}${text['url_photo']}',
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.fromLTRB(
                                                  0, 0, 40, 0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Container(
                                                    child: Text(
                                                      text['names'][0]
                                                              .toUpperCase() +
                                                          text['names']
                                                              .substring(1),
                                                    ),
                                                  ),
                                                  Container(
                                                    child: Text(calculateAge(
                                                            text['dateRaw'])
                                                        .toString()),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    // Container(
                                    //   padding: const EdgeInsets.fromLTRB(
                                    //       15, 10, 0, 10),
                                    //   child: Text(
                                    //     text['names'][0].toUpperCase() +
                                    //         text['names'].substring(1),
                                    //     style: const TextStyle(
                                    //         color: Colors.black, fontSize: 18),
                                    //   ),
                                    // ),
                                    StaggeredGrid.count(
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 10,
                                      crossAxisSpacing: 0,
                                      children: [
                                        // // Image
                                        // StaggeredGridTile.count(
                                        //   crossAxisCellCount: 2,
                                        //   mainAxisCellCount: 1,
                                        //   child: InkWell(
                                        //     onTap: () {
                                        //       InternVariables.kid['id'] =
                                        //           text['id'];
                                        //       InternVariables.kid['idLocal'] =
                                        //           text['idLocal'];
                                        //       InternVariables.kid['names'] =
                                        //           text['names'];
                                        //       InternVariables.kid['birthday'] =
                                        //           text['dateRaw'];
                                        //       InternVariables.kid['gender'] =
                                        //           text['gender'];
                                        //       Navigator.push(
                                        //         context,
                                        //         MaterialPageRoute(
                                        //             builder: (context) =>
                                        //                 CredPrincipalPage(
                                        //                     idKid: text[
                                        //                         'idLocal'])),
                                        //       );
                                        //     },
                                        //     child: Image.asset(
                                        //       '${GlobalVariables.publicAddress}${text['url_photo']}',
                                        //     ),
                                        //   ),
                                        // ),
                                        StaggeredGridTile.count(
                                          crossAxisCellCount: 1,
                                          mainAxisCellCount: 1,
                                          // Cred tile
                                          child: InkWell(
                                            child: Container(
                                              padding: const EdgeInsets.all(8),
                                              margin: EdgeInsets.all(
                                                  containerMargin.toDouble()),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          containerRadius
                                                              .toDouble()),
                                                  boxShadow: const [
                                                    BoxShadow(
                                                      color: Colors.grey,
                                                      offset: Offset(0.0, 5.0),
                                                      blurStyle:
                                                          BlurStyle.normal,
                                                      blurRadius: 2,
                                                    ),
                                                  ],
                                                  color: text['gender'] == 1
                                                      ? AppColors.colorCREDBoy
                                                      : AppColors
                                                          .colorCREDGirl),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.all(0),
                                                    child: Image.asset(
                                                        '${GlobalVariables.logosAddress}cred_logo.png',
                                                        height: 80,
                                                        width: 80),
                                                  ),
                                                  Text(
                                                      TranslateService
                                                          .translate(
                                                              'homePage.cred'),
                                                      style: TextStyle(
                                                          fontSize: sizeOfFont
                                                              .toDouble(),
                                                          fontWeight:
                                                              weightOfFont),
                                                      textAlign:
                                                          TextAlign.center)
                                                ],
                                              ),
                                            ),
                                            onTap: () {
                                              InternVariables.kid['id'] =
                                                  text['id'];
                                              InternVariables.kid['idLocal'] =
                                                  text['idLocal'];
                                              InternVariables.kid['names'] =
                                                  text['names'];
                                              InternVariables.kid['birthday'] =
                                                  text['dateRaw'];
                                              InternVariables.kid['gender'] =
                                                  text['gender'];
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        CredPrincipalPage(
                                                            idKid: text[
                                                                'idLocal'])),
                                              );
                                            },
                                          ),
                                        ),
                                        // Recipe tile
                                        StaggeredGridTile.count(
                                          crossAxisCellCount: 1,
                                          mainAxisCellCount: 1,
                                          child: InkWell(
                                            child: Container(
                                              padding: const EdgeInsets.all(8),
                                              margin: EdgeInsets.all(
                                                  containerMargin.toDouble()),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          containerRadius
                                                              .toDouble()),
                                                  boxShadow: const [
                                                    BoxShadow(
                                                      color: Colors.grey,
                                                      offset: Offset(0.0, 5.0),
                                                      blurStyle:
                                                          BlurStyle.normal,
                                                      blurRadius: 2,
                                                    ),
                                                  ],
                                                  color: AppColors.colorRecipes
                                                  // text['gender'] == 1
                                                  //     ? AppColors.colorCREDBoy
                                                  //     : AppColors
                                                  //         .colorCREDGirl
                                                  ),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.all(0),
                                                    child: Image.asset(
                                                      '${GlobalVariables.logosAddress}recipe_square2.png',
                                                      height: 80,
                                                      width: 80,
                                                    ),
                                                  ),
                                                  Text(
                                                      TranslateService.translate(
                                                          'homePage.recipes'),
                                                      style: TextStyle(
                                                          fontSize: sizeOfFont
                                                              .toDouble(),
                                                          fontWeight:
                                                              weightOfFont),
                                                      textAlign:
                                                          TextAlign.center),
                                                ],
                                              ),
                                            ),
                                            onTap: () async {
                                              InternVariables.kid['id'] =
                                                  text['id'];
                                              InternVariables.kid['idLocal'] =
                                                  text['idLocal'];
                                              InternVariables.kid['names'] =
                                                  text['names'];
                                              InternVariables.kid['birthday'] =
                                                  text['dateRaw'];
                                              InternVariables.kid['gender'] =
                                                  text['gender'];
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          RecipesPage(
                                                              text['dateRaw']))
                                                  // MaterialPageRoute(
                                                  //     builder: (context) => RecipesPage(
                                                  //         idKid: text['idLocal'])),
                                                  );
                                            },
                                          ),
                                        ),
                                        //progress tracker
                                        StaggeredGridTile.count(
                                          crossAxisCellCount: 1,
                                          mainAxisCellCount: 1,
                                          child: InkWell(
                                            child: Container(
                                              padding: const EdgeInsets.all(8),
                                              margin: EdgeInsets.all(
                                                  containerMargin.toDouble()),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          containerRadius
                                                              .toDouble()),
                                                  boxShadow: const [
                                                    BoxShadow(
                                                      color: Colors.grey,
                                                      offset: Offset(0.0, 5.0),
                                                      blurStyle:
                                                          BlurStyle.normal,
                                                      blurRadius: 2,
                                                    ),
                                                  ],
                                                  color: AppColors.colorRecipes
                                                  // text['gender'] == 1
                                                  //     ? AppColors.colorCREDBoy
                                                  //     : AppColors
                                                  //         .colorCREDGirl
                                                  ),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.all(0),
                                                    child: Image.asset(
                                                      '${GlobalVariables.logosAddress}recipe_square2.png',
                                                      height: 80,
                                                      width: 80,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                        TranslateService.translate(
                                                            'homePage.progress_tracker'),
                                                        style: TextStyle(
                                                            fontSize: sizeOfFont
                                                                .toDouble(),
                                                            fontWeight:
                                                                weightOfFont),
                                                        textAlign:
                                                            TextAlign.center),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            onTap: () async {
                                              InternVariables.kid['id'] =
                                                  text['id'];
                                              InternVariables.kid['idLocal'] =
                                                  text['idLocal'];
                                              InternVariables.kid['names'] =
                                                  text['names'];
                                              InternVariables.kid['birthday'] =
                                                  text['dateRaw'];
                                              InternVariables.kid['gender'] =
                                                  text['gender'];
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          TrackProgress())
                                                  // MaterialPageRoute(
                                                  //     builder: (context) => RecipesPage(
                                                  //         idKid: text['idLocal'])),
                                                  );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ).toList(),
                      );
                    } else if (!cargado) {
                      // Forever loading
                      return Container(
                        margin: const EdgeInsets.all(20),
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    } else {
                      // No children added
                      return Container(
                        margin: const EdgeInsets.all(20),
                        child: Center(
                          child: Container(
                            child: Column(
                              children: [
                                Text(TranslateService.translate(
                                    'homePage.empty')),
                                Container(
                                  width: 230,
                                  margin:
                                      const EdgeInsets.fromLTRB(0, 15, 0, 0),
                                  child: Container(
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                AppColors.colorAddButtons),
                                        foregroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.white),
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Text(
                                            TranslateService.translate(
                                                'homePage.add_kid'),
                                            style:
                                                const TextStyle(fontSize: 18),
                                          ),
                                          const Spacer(),
                                          const Icon(Icons.person_add),
                                        ],
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CreateKidPage(idFamily)),
                                        ).then((value) => actualizar());
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
                // General tiles
                data.isNotEmpty
                    ? StaggeredGrid.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        children: [
                          // Calendar Tile
                          InkWell(
                            child: Container(
                              height: 170,
                              padding: const EdgeInsets.all(8),
                              margin: EdgeInsets.only(
                                  top: containerMargin.toDouble()),
                              // margin: EdgeInsets.all(containerMargin.toDouble()),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      containerRadius.toDouble()),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.grey,
                                      offset: Offset(0.0, 5.0),
                                      blurStyle: BlurStyle.normal,
                                      blurRadius: 2,
                                    ),
                                  ],
                                  color: AppColors.colorCalendar),
                              child: Column(
                                children: [
                                  Container(
                                    child: Image.asset(
                                      '${GlobalVariables.logosAddress}calendario_logo.png',
                                      height: 100,
                                    ),
                                  ),
                                  Text(
                                      TranslateService.translate(
                                          'homePage.calendar'),
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
                                    builder: (context) => CalendarPage()),
                              );
                            },
                          ),
                          // Shared Experiences Tile
                          InkWell(
                            child: Container(
                              height: 170,
                              padding: const EdgeInsets.all(8),
                              margin: EdgeInsets.only(
                                  top: containerMargin.toDouble()),
                              // margin: EdgeInsets.all(containerMargin.toDouble()),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      containerRadius.toDouble()),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.grey,
                                      offset: Offset(0.0, 5.0),
                                      blurStyle: BlurStyle.normal,
                                      blurRadius: 2,
                                    ),
                                  ],
                                  color: AppColors.colorShareExpeirence),
                              child: Column(
                                children: [
                                  Container(
                                    child: Image.asset(
                                      '${GlobalVariables.logosAddress}grupos_de_apoyo_logo.png',
                                      height: 100,
                                    ),
                                  ),
                                  Text(
                                      TranslateService.translate(
                                          'homePage.support_groups'),
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
                                    builder: (context) =>
                                        SharedExperiencesPage()),
                              );
                            },
                          ),
                        ],
                      )
                    : Container(),
              ],
            ),
          )),
      bottomNavigationBar: BottomNavigationPage(),
      floatingActionButton: data.isNotEmpty
          ? Container(
              width: GlobalVariables.language == 'ES' ? 230 : 175,
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Container(
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        AppColors.colorAddButtons),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        TranslateService.translate('homePage.add_kid'),
                        style: const TextStyle(fontSize: 17),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Spacer(),
                      const Icon(
                        Icons.person_add,
                        size: 20,
                      ),
                    ],
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateKidPage(idFamily)),
                    ).then((value) => actualizar());
                  },
                ),
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
