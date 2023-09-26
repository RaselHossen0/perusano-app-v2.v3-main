import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:perusano/components/bottomNavigation.dart';
import 'package:perusano/pages/cred/healthAndNutrition/inside_health_and_nutriotion.dart';
import 'package:perusano/util/globalVariables.dart';

import '../../../services/translateService.dart';
import '../../../util/myColors.dart';

class HealthNutritionPage extends StatefulWidget {
  int idKid;
  String name;

  HealthNutritionPage({super.key, required this.idKid, required this.name});

  @override
  State<StatefulWidget> createState() =>
      _HealthNutritionPage(idKid: idKid, name: name);
}

class _HealthNutritionPage extends State<HealthNutritionPage> {
  int idKid;
  String name;

  _HealthNutritionPage({required this.idKid, required this.name});

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Flexible(
              fit: FlexFit.tight,
              child: Text(
                '${TranslateService.translate('homePage.cred')} - $name',
                style: const TextStyle(color: Colors.black),
                overflow: TextOverflow.visible,
              ),
            ),
            const Spacer(),
          ],
        ),
        backgroundColor: AppColors.colorCREDBoy,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 5.0),
                    blurStyle: BlurStyle.normal,
                    blurRadius: 2,
                  ),
                ],
              ),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InsideHealthNutritionPage(
                        idKid: idKid,
                        name: name,
                        pageId: 1,
                      ),
                    ),
                  );
                },
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          child: Image.asset(
                              '${GlobalVariables.logosCREDAddress}feeding.png'),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                              child: const Text(
                                'Lactancia Materna',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              //     direction: Axis.vertical,
                              height: 70,
                              width: 190,
                              margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                              padding: const EdgeInsets.fromLTRB(5, 5, 3, 0),
                              // children: [
                              // const Expanded(
                              //   flex: 1,
                              child: const Text(
                                '¿Por qué es importante dar de lactar en los primeros meses de vida?',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 4,
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black45),
                              ),
                            ),
                            // ],),
                            Container(
                              margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                              padding: const EdgeInsets.fromLTRB(5, 5, 3, 0),
                              child: Text(
                                TranslateService.translate(
                                    'healthAndNutrition.readMore'),
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.black54),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    Row(
                      children: const [],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 5.0),
                    blurStyle: BlurStyle.normal,
                    blurRadius: 2,
                  ),
                ],
              ),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InsideHealthNutritionPage(
                        idKid: idKid,
                        name: name,
                        pageId: 2,
                      ),
                    ),
                  );
                },
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          child: Image.asset(
                              '${GlobalVariables.logosCREDAddress}complementary_feeding.png'),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                              child: const Text(
                                'Alimentación complementaria',
                                style: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              //     direction: Axis.vertical,
                              height: 70,
                              width: 190,
                              margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                              padding: const EdgeInsets.fromLTRB(5, 5, 3, 0),
                              // children: [
                              // const Expanded(
                              //   flex: 1,
                              child: const Text(
                                '¿Por qué es importante complementar la alimentación?',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 4,
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black45),
                              ),
                            ),
                            // ],),
                            Container(
                              margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                              padding: const EdgeInsets.fromLTRB(5, 5, 3, 0),
                              child: Text(
                                TranslateService.translate(
                                    'healthAndNutrition.readMore'),
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.black54),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    Row(
                      children: const [],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 5.0),
                    blurStyle: BlurStyle.normal,
                    blurRadius: 2,
                  ),
                ],
              ),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InsideHealthNutritionPage(
                        idKid: idKid,
                        name: name,
                        pageId: 3,
                      ),
                    ),
                  );
                },
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          child: Image.asset(
                              '${GlobalVariables.logosCREDAddress}healthy_feeding_1.jpg'),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                              child: const Text(
                                'Alimentación saludable',
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              //     direction: Axis.vertical,
                              height: 70,
                              width: 190,
                              margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                              padding: const EdgeInsets.fromLTRB(5, 5, 3, 0),
                              // children: [
                              // const Expanded(
                              //   flex: 1,
                              child: const Text(
                                '¿Por qué es importante alimentar de manera saludable?',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 4,
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black45),
                              ),
                            ),
                            // ],),
                            Container(
                              margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                              padding: const EdgeInsets.fromLTRB(5, 5, 3, 0),
                              child: Text(
                                TranslateService.translate(
                                    'healthAndNutrition.readMore'),
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.black54),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    Row(
                      children: const [],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        // child: Column(
        //   children: [
        //     Container(
        //       height: 150,
        //       decoration: BoxDecoration(
        //         borderRadius: BorderRadius.circular(20),
        //         color: AppColors.colorOverview,
        //         boxShadow: const [
        //           BoxShadow(
        //             color: Colors.grey,
        //             offset: Offset(0.0, 5.0),
        //             blurStyle: BlurStyle.normal,
        //             blurRadius: 2,
        //           ),
        //         ],
        //       ),
        //       margin: const EdgeInsets.fromLTRB(
        //           20, 20, 20, 20),
        //       child: InkWell(
        //         onTap: () {
        //           InternVariables.kid['id'] =
        //               text['id'];
        //           InternVariables.kid['idLocal'] =
        //               text['idLocal'];
        //           InternVariables.kid['names'] =
        //               text['names'];
        //           InternVariables.kid['birthday'] =
        //               text['dateRaw'];
        //           InternVariables.kid['gender'] =
        //               text['gender'];
        //           Navigator.push(
        //             context,
        //             MaterialPageRoute(
        //                 builder: (context) =>
        //                     CredPrincipalPage(
        //                         idKid:
        //                             text['idLocal'])),
        //           );
        //         },
        //         child: Row(
        //           mainAxisAlignment:
        //               MainAxisAlignment.spaceAround,
        //           children: [
        //             Container(
        //               margin: const EdgeInsets.fromLTRB(
        //                   20, 20, 20, 20),
        //               child: Image.asset(
        //                 '${GlobalVariables.publicAddress}${text['url_photo']}',
        //               ),
        //             ),
        //             Container(
        //               margin: const EdgeInsets.fromLTRB(
        //                   0, 0, 40, 0),
        //               child: Column(
        //                 mainAxisAlignment:
        //                     MainAxisAlignment
        //                         .spaceEvenly,
        //                 children: [
        //                   Container(
        //                     child: Text(
        //                       text['names'][0]
        //                               .toUpperCase() +
        //                           text['names']
        //                               .substring(1),
        //                     ),
        //                   ),
        //                   Container(
        //                     child: Text(calculateAge(
        //                             text['dateRaw'])
        //                         .toString()),
        //                   ),
        //                 ],
        //               ),
        //             ),
        //           ],
        //         ),
        //       ),
        //     ),
        //     // Container(
        //     //   padding: const EdgeInsets.fromLTRB(
        //     //       15, 10, 0, 10),
        //     //   child: Text(
        //     //     text['names'][0].toUpperCase() +
        //     //         text['names'].substring(1),
        //     //     style: const TextStyle(
        //     //         color: Colors.black, fontSize: 18),
        //     //   ),
        //     // ),
        //     StaggeredGrid.count(
        //       crossAxisCount: 2,
        //       mainAxisSpacing: 10,
        //       crossAxisSpacing: 0,
        //       children: [
        //         // // Image
        //         // StaggeredGridTile.count(
        //         //   crossAxisCellCount: 2,
        //         //   mainAxisCellCount: 1,
        //         //   child: InkWell(
        //         //     onTap: () {
        //         //       InternVariables.kid['id'] =
        //         //           text['id'];
        //         //       InternVariables.kid['idLocal'] =
        //         //           text['idLocal'];
        //         //       InternVariables.kid['names'] =
        //         //           text['names'];
        //         //       InternVariables.kid['birthday'] =
        //         //           text['dateRaw'];
        //         //       InternVariables.kid['gender'] =
        //         //           text['gender'];
        //         //       Navigator.push(
        //         //         context,
        //         //         MaterialPageRoute(
        //         //             builder: (context) =>
        //         //                 CredPrincipalPage(
        //         //                     idKid: text[
        //         //                         'idLocal'])),
        //         //       );
        //         //     },
        //         //     child: Image.asset(
        //         //       '${GlobalVariables.publicAddress}${text['url_photo']}',
        //         //     ),
        //         //   ),
        //         // ),
        //         StaggeredGridTile.count(
        //           crossAxisCellCount: 1,
        //           mainAxisCellCount: 1,
        //           // Cred tile
        //           child: InkWell(
        //             child: Container(
        //               padding: const EdgeInsets.all(8),
        //               margin: EdgeInsets.all(
        //                   containerMargin.toDouble()),
        //               decoration: BoxDecoration(
        //                   borderRadius:
        //                       BorderRadius.circular(
        //                           containerRadius
        //                               .toDouble()),
        //                   boxShadow: const [
        //                     BoxShadow(
        //                       color: Colors.grey,
        //                       offset: Offset(0.0, 5.0),
        //                       blurStyle:
        //                           BlurStyle.normal,
        //                       blurRadius: 2,
        //                     ),
        //                   ],
        //                   color: text['gender'] == 1
        //                       ? AppColors.colorCREDBoy
        //                       : AppColors
        //                           .colorCREDGirl),
        //               child: Column(
        //                 children: [
        //                   Container(
        //                     margin:
        //                         const EdgeInsets.all(0),
        //                     child: Image.asset(
        //                         '${GlobalVariables.logosAddress}cred_logo.png',
        //                         height: 90,
        //                         width: 90),
        //                   ),
        //                   Text(
        //                       TranslateService
        //                           .translate(
        //                               'homePage.cred'),
        //                       style: TextStyle(
        //                           fontSize: sizeOfFont
        //                               .toDouble(),
        //                           fontWeight:
        //                               weightOfFont),
        //                       textAlign:
        //                           TextAlign.center)
        //                 ],
        //               ),
        //             ),
        //             onTap: () {
        //               InternVariables.kid['id'] =
        //                   text['id'];
        //               InternVariables.kid['idLocal'] =
        //                   text['idLocal'];
        //               InternVariables.kid['names'] =
        //                   text['names'];
        //               InternVariables.kid['birthday'] =
        //                   text['dateRaw'];
        //               InternVariables.kid['gender'] =
        //                   text['gender'];
        //               Navigator.push(
        //                 context,
        //                 MaterialPageRoute(
        //                     builder: (context) =>
        //                         CredPrincipalPage(
        //                             idKid: text[
        //                                 'idLocal'])),
        //               );
        //             },
        //           ),
        //         ),
        //         // Recipe tile
        //         StaggeredGridTile.count(
        //           crossAxisCellCount: 1,
        //           mainAxisCellCount: 1,
        //           child: InkWell(
        //             child: Container(
        //               padding: const EdgeInsets.all(8),
        //               margin: EdgeInsets.all(
        //                   containerMargin.toDouble()),
        //               decoration: BoxDecoration(
        //                   borderRadius:
        //                       BorderRadius.circular(
        //                           containerRadius
        //                               .toDouble()),
        //                   boxShadow: const [
        //                     BoxShadow(
        //                       color: Colors.grey,
        //                       offset: Offset(0.0, 5.0),
        //                       blurStyle:
        //                           BlurStyle.normal,
        //                       blurRadius: 2,
        //                     ),
        //                   ],
        //                   color: text['gender'] == 1
        //                       ? AppColors.colorCREDBoy
        //                       : AppColors
        //                           .colorCREDGirl),
        //               child: Column(
        //                 children: [
        //                   Container(
        //                     margin:
        //                         const EdgeInsets.all(0),
        //                     child: Image.asset(
        //                       '${GlobalVariables.logosAddress}recetas_logo.png',
        //                       height: 90,
        //                       width: 90,
        //                     ),
        //                   ),
        //                   Text(
        //                       TranslateService.translate(
        //                           'homePage.recipes'),
        //                       style: TextStyle(
        //                           fontSize: sizeOfFont
        //                               .toDouble(),
        //                           fontWeight:
        //                               weightOfFont),
        //                       textAlign:
        //                           TextAlign.center)
        //                 ],
        //               ),
        //             ),
        //             onTap: () async {
        //               InternVariables.kid['id'] =
        //                   text['id'];
        //               InternVariables.kid['idLocal'] =
        //                   text['idLocal'];
        //               InternVariables.kid['names'] =
        //                   text['names'];
        //               InternVariables.kid['birthday'] =
        //                   text['dateRaw'];
        //               InternVariables.kid['gender'] =
        //                   text['gender'];
        //               Navigator.push(
        //                   context,
        //                   MaterialPageRoute(
        //                       builder: (context) =>
        //                           RecipesPage())
        //                   // MaterialPageRoute(
        //                   //     builder: (context) => RecipesPage(
        //                   //         idKid: text['idLocal'])),
        //                   );
        //             },
        //           ),
        //         ),
        //       ],
        //     ),
        //   ],
        // ),
      ),

      //endDrawer: LateralMenuCenter.fromInsideCRED(1, idKid, name),
      //onEndDrawerChanged: actualizar(),
      bottomNavigationBar: BottomNavigationPage(),
    );
  }
}
