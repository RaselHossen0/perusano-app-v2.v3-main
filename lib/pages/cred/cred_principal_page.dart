import 'package:flutter/material.dart';
import 'package:perusano/pages/cred/anemiaCheck/anemia_check_page.dart';
import 'package:perusano/pages/cred/childDevelopment/early_child_development.dart';
import 'package:perusano/pages/cred/healthAndNutrition/health_and_nutrition.dart';
import 'package:perusano/pages/cred/vaccines/vaccinePage.dart';
import 'package:perusano/pages/cred/weightHeight/weight_height_page.dart';
import 'package:perusano/util/internVariables.dart';
import 'package:perusano/util/myColors.dart';
import 'package:perusano/components/bottomNavigation.dart';

import '../../components/lateralMenuCenter.dart';
import '../../services/translateService.dart';
import '../../util/globalVariables.dart';
import 'appointments/appointment_page.dart';
import 'ironSupplement/iron_supplement_page.dart';

class CredPrincipalPage extends StatefulWidget {
  int idKid;
  CredPrincipalPage({super.key, required this.idKid});

  @override
  State<StatefulWidget> createState() => _CredPrincipalPage(idKid: idKid);
}

class _CredPrincipalPage extends State<CredPrincipalPage> {
  int idKid;
  _CredPrincipalPage({required this.idKid});

  Map data = {};
  Map dataObt = {};

  // Asign the kid data
  asignData() async {
    /*
    dataObt = await CredService.getPrincipalDataByKidId(idKid);
    setState(() {
      data = dataObt;
    });*/

    data = {
      'names': InternVariables.kid['names'],
      'birthday': InternVariables.kid['birthday'],
      'gender': InternVariables.kid['gender'],
    };
    cargarColor();
  }

  // Change the cred color
  cargarColor() {
    if (data['gender'] == 1) {
      AppColors.colorCREDBoy = const Color.fromRGBO(195, 234, 255, 1.0);
    } else {
      AppColors.colorCREDBoy = const Color.fromRGBO(255, 229, 236, 1.0);
    }
  }

  @override
  void initState() {
    asignData();
    super.initState();
  }

  var imageHeight = 75;
  var imageWidth = 70;
  var sizeOfFont = 20;
  var weightOfFont = FontWeight.bold;
  var containerRadius = 10;
  var containerMargin = const EdgeInsets.fromLTRB(30, 30, 30, 0);
  var containerPadding = 20;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              child: Builder(
                builder: (context) {
                  if (data.isNotEmpty) {
                    return Flexible(
                      fit: FlexFit.tight,
                      child: Text(
                        'CRED - ${data['names'].toString()}',
                        style: const TextStyle(color: Colors.black),
                        overflow: TextOverflow.visible,
                      ),
                    );
                  } else {
                    return Container(
                      margin: const EdgeInsets.all(20),
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  }
                },
              ),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {},
              color: Colors.black,
            ),
          ],
        ),
        backgroundColor:
            data.isNotEmpty ? AppColors.colorCREDBoy : Colors.white,
        elevation: 0,
      ),
      endDrawer: LateralMenuCenter.fromKid(idKid),
      body: Container(
        child: Builder(
          builder: (context) {
            if (data.isNotEmpty) {
              return ListView(
                children: [
                  Container(
                    padding: EdgeInsets.all(containerPadding.toDouble()),
                    margin: containerMargin,
                    decoration: BoxDecoration(
                      color: AppColors.colorCREDBoy,
                      borderRadius:
                          BorderRadius.circular(containerRadius.toDouble()),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 5.0),
                          blurStyle: BlurStyle.normal,
                          blurRadius: 2,
                        ),
                      ],
                    ),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side:
                            BorderSide(width: 0, color: AppColors.colorCREDBoy),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HealthNutritionPage(
                                    idKid: idKid,
                                    name: data['names'],
                                  )),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            flex: 1,
                            child: Text(
                              TranslateService.translate(
                                  'credPrincipalPage.health_and_nutrition'),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: sizeOfFont.toDouble(),
                                  fontWeight: weightOfFont),
                              overflow: TextOverflow.visible,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Container(
                              child: Image.asset(
                                  '${GlobalVariables.logosAddress}informacion_logo.png',
                                  height: imageHeight.toDouble(),
                                  width: imageWidth.toDouble()),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(containerPadding.toDouble()),
                    margin: containerMargin,
                    decoration: BoxDecoration(
                      color: AppColors.colorCREDBoy,
                      borderRadius:
                          BorderRadius.circular(containerRadius.toDouble()),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 5.0),
                          blurStyle: BlurStyle.normal,
                          blurRadius: 2,
                        ),
                      ],
                    ),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side:
                            BorderSide(width: 0, color: AppColors.colorCREDBoy),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WeightHeightPage(
                                    idKid: idKid,
                                    name: data['names'],
                                    gender: data['gender'],
                                  )),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            flex: 1,
                            child: Text(
                                TranslateService.translate(
                                    'credPrincipalPage.weight_and_height'),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: sizeOfFont.toDouble(),
                                    fontWeight: weightOfFont),
                                textAlign: TextAlign.center),
                          ),
                          Flexible(
                            flex: 1,
                            child: Container(
                              child: Image.asset(
                                  '${GlobalVariables.logosAddress}altura_logo.png',
                                  height: imageHeight.toDouble(),
                                  width: imageWidth.toDouble()),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(containerPadding.toDouble()),
                    margin: containerMargin,
                    decoration: BoxDecoration(
                      color: AppColors.colorCREDBoy,
                      borderRadius:
                          BorderRadius.circular(containerRadius.toDouble()),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 5.0),
                          blurStyle: BlurStyle.normal,
                          blurRadius: 2,
                        ),
                      ],
                    ),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          width: 0,
                          color: AppColors.colorCREDBoy,
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AnemiaCheckPage(
                                  idKid: idKid,
                                  name: data['names'],
                                  gender: data['gender'])),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            flex: 1,
                            child: Text(
                              TranslateService.translate(
                                  'credPrincipalPage.anemia_dismiss'),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: sizeOfFont.toDouble(),
                                  fontWeight: weightOfFont),
                              overflow: TextOverflow.visible,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Container(
                              child: Image.asset(
                                  data['gender'] == 1
                                      ? '${GlobalVariables.logosAddress}hemoglobina_logo_boy.png'
                                      : '${GlobalVariables.logosAddress}hemoglobina_logo_girl.png',
                                  height: imageHeight.toDouble(),
                                  width: imageWidth.toDouble()),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Container(
                  //     padding: EdgeInsets.all(containerPadding.toDouble()),
                  //     margin: containerMargin,
                  //     decoration: BoxDecoration(
                  //       color: AppColors.colorCREDBoy,
                  //       borderRadius:
                  //           BorderRadius.circular(containerRadius.toDouble()),
                  //     ),
                  //     child: OutlinedButton(
                  //       style: OutlinedButton.styleFrom(
                  //         side: BorderSide(
                  //           width: 0,
                  //           color: AppColors.colorCREDBoy,
                  //         ),
                  //       ),
                  //       onPressed: () {
                  //         Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //               builder: (context) => VaccinePage(
                  //                     idKid: idKid,
                  //                     name: data['names'],
                  //                   )),
                  //         );
                  //       },
                  //       child: Row(
                  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //         children: [
                  //           Flexible(
                  //             flex: 1,
                  //             child: Text(
                  //               TranslateService.translate(
                  //                   'credPrincipalPage.vaccines'),
                  //               style: TextStyle(
                  //                   color: Colors.black,
                  //                   fontSize: sizeOfFont.toDouble(),
                  //                   fontWeight: weightOfFont),
                  //               textAlign: TextAlign.center,
                  //             ),
                  //           ),
                  //           Flexible(
                  //             flex: 1,
                  //             child: Container(
                  //               child: Image.asset(
                  //                   '${GlobalVariables.logosAddress}vacuna_logo.png',
                  //                   height: imageHeight.toDouble(),
                  //                   width: imageWidth.toDouble()),
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  // ),
                  Container(
                    padding: EdgeInsets.all(containerPadding.toDouble()),
                    margin: containerMargin,
                    decoration: BoxDecoration(
                      color: AppColors.colorCREDBoy,
                      borderRadius:
                          BorderRadius.circular(containerRadius.toDouble()),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 5.0),
                          blurStyle: BlurStyle.normal,
                          blurRadius: 2,
                        ),
                      ],
                    ),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side:
                            BorderSide(width: 0, color: AppColors.colorCREDBoy),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => IronSupplementPage(
                                    idKid: idKid,
                                    name: data['names'],
                                  )),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            flex: 1,
                            child: Text(
                                TranslateService.translate(
                                    'credPrincipalPage.iron_supplement'),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: sizeOfFont.toDouble(),
                                    fontWeight: weightOfFont),
                                textAlign: TextAlign.center),
                          ),
                          Flexible(
                            flex: 1,
                            child: Container(
                              child: Image.asset(
                                  '${GlobalVariables.logosAddress}suplemento_logo.png',
                                  height: imageHeight.toDouble(),
                                  width: imageWidth.toDouble()),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(containerPadding.toDouble()),
                    margin: containerMargin,
                    decoration: BoxDecoration(
                      color: AppColors.colorCREDBoy,
                      borderRadius:
                          BorderRadius.circular(containerRadius.toDouble()),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 5.0),
                          blurStyle: BlurStyle.normal,
                          blurRadius: 2,
                        ),
                      ],
                    ),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side:
                            BorderSide(width: 0, color: AppColors.colorCREDBoy),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AppointmentPage(
                                    idKid: idKid,
                                    name: data['names'],
                                  )),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            flex: 1,
                            child: Text(
                                TranslateService.translate(
                                    'credPrincipalPage.appointment'),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: sizeOfFont.toDouble(),
                                    fontWeight: weightOfFont),
                                textAlign: TextAlign.center),
                          ),
                          Flexible(
                            flex: 1,
                            child: Container(
                              child: Image.asset(
                                  '${GlobalVariables.logosAddress}calendario_cred_logo.png',
                                  height: imageHeight.toDouble(),
                                  width: imageWidth.toDouble()),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Container(
                  //     padding: EdgeInsets.all(containerPadding.toDouble()),
                  //     margin: containerMargin,
                  //     decoration: BoxDecoration(
                  //       color: AppColors.colorCRED,
                  //       borderRadius:
                  //           BorderRadius.circular(containerRadius.toDouble()),
                  // boxShadow: const [
                  //                         BoxShadow(
                  //                           color: Colors.grey,
                  //                           offset: Offset(0.0, 5.0),
                  //                           blurStyle: BlurStyle.normal,
                  //                           blurRadius: 2,
                  //                         ),
                  //                       ],
                  //     ),
                  //     child: OutlinedButton(
                  //       style: OutlinedButton.styleFrom(
                  //         side:
                  //             BorderSide(width: 0, color: AppColors.colorCRED),
                  //       ),
                  //       onPressed: () {
                  //         Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //               builder: (context) => ChildDevelopmentPage(
                  //                     idKid: idKid,
                  //                     name: data['names'],
                  //                   )),
                  //         );
                  //       },
                  //       child: Row(
                  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //         children: [
                  //           Flexible(
                  //             flex: 1,
                  //             child: Text(
                  //                 TranslateService.translate(
                  //                     'credPrincipalPage.child_development'),
                  //                 style: TextStyle(
                  //                     color: Colors.black,
                  //                     fontSize: sizeOfFont.toDouble(),
                  //                     fontWeight: weightOfFont),
                  //                 textAlign: TextAlign.center),
                  //           ),
                  //           Flexible(
                  //             flex: 1,
                  //             child: Container(
                  //               child: Image.asset(
                  //                   '${GlobalVariables.logosAddress}hfeliz.png',
                  //                   height: imageHeight.toDouble(),
                  //                   width: imageWidth.toDouble()),
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     )),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              );
            } else {
              return Container(
                margin: const EdgeInsets.all(20),
                child: const Center(child: CircularProgressIndicator()),
              );
            }
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationPage() as Widget,
    );
  }
}

/*rosado: #FFE5ECrgb(255, 229, 236)

azul: #E4FAFrgb(228, 250, 255)*/
