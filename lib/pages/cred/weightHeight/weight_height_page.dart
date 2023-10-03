import 'dart:math';

import 'package:charts_painter/chart.dart';
import 'package:draw_graph/draw_graph.dart';
import 'package:draw_graph/models/feature.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:perusano/components/bottomNavigation.dart';
import 'package:perusano/services/fileManagement/cred/weightHeightFM.dart';
import 'package:stacked_bar_chart/stacked_bar_chart.dart';

import '../../../services/apis/cred/credRegisterCenter.dart';
import '../../../services/translateService.dart';
import '../../../util/globalVariables.dart';
import '../../../util/myColors.dart';

import 'package:syncfusion_flutter_charts/charts.dart';

import 'add_weight_and_height.dart';

class WHData {
  WHData({required this.date, required this.weight, required this.height});
  final String date;
  final double weight;
  final double height;
}

class WeightHeightPage extends StatefulWidget {
  int idKid;
  String name;
  int gender;
  WeightHeightPage(
      {super.key,
      required this.idKid,
      required this.name,
      required this.gender});

  @override
  State<StatefulWidget> createState() =>
      _WeightHeightPage(idKid: idKid, name: name, gender: gender);
}

class _WeightHeightPage extends State<WeightHeightPage> {
  int idKid;
  String name;
  List data = [];
  List dataObt = [];
  int gender;

  final WeightHeightFM storage = WeightHeightFM();

  bool cargado = false;

  //Limites inferiores
  double limiteObesidad = 3.0;
  double limiteSobrepeso = 2.0;
  //Limites superiores
  double limiteDesnutricionAguda = -2.0;
  double limiteDesnutricionSevera = -3.0;

  final double width = 300;
  final double height = 20;
  final double radius = 8;

  List<WHData> dataGrafico = [];
  List<WHData> dataGraficoReal = [];

  bool presentaHistorial = false;

  _WeightHeightPage(
      {required this.idKid, required this.name, required this.gender});

  // Loads all Weight and Height register from local storage
  loadWeightHeight() async {
    //bool isConnected = await GlobalVariables.isConnected();

    dataObt = await storage.readFile();
    List dataFiltrada = [];
    for (var value in dataObt) {
      if (value['idLocalKid'] == idKid && value['wasRemove'] == false) {
        dataFiltrada.add(value);
      }
    }
    setState(() {
      data = dataFiltrada;
      data.sort((a, b) {
        var adate =
            DateTime.parse(a['dateRaw']); //before -> var adate = a.expiry
        var bdate =
            DateTime.parse(b['dateRaw']); //before -> var bdate = b.expiry
        return bdate.compareTo(
            adate); //to get the order other way just switch `adate & bdate`
      });
    });

    await formarListaGrafico();
    await generateFeatures();
    cargado = true;
  }

  // Delete the register in local storage and, if exist a connection, in the network database
  Future<bool> deleteRegister(int idData, int idLocal) async {
    Map answer = {};
    if (idData == 0) {
      answer = await storage.deleteRegister(idLocal);
    } else {
      answer = await storage.changeWasDeleted(idLocal);

      bool isConnected = await GlobalVariables.isConnected();
      if (isConnected) {
        await CredRegisterCenter().deleteWeightHeight(idData);
        await storage.deleteRegister(idLocal);
      }
    }
    generateFeatures();

    if (answer['id'] > 0) {
      return true;
    }
    return false;
  }

  // Shows the record
  Widget showRecord() {
    if (presentaHistorial) {
      return Container(
        child: Builder(
          builder: (context) {
            if (data.isNotEmpty) {
              return Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                child: Column(
                    children: data.map((text) {
                  return Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.colorCREDBoy,
                          offset: const Offset(0.0, 5.0),
                          blurStyle: BlurStyle.normal,
                          blurRadius: 2,
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Container(
                            alignment: Alignment.topRight,
                            //color: Colors.redAccent,
                            //height: 1,
                            child: FittedBox(
                              fit: BoxFit.cover,
                              child: IconButton(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                constraints: BoxConstraints.loose(
                                    const Size.fromWidth(20)),
                                onPressed: () => showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    content: Container(
                                      child: Text(TranslateService.translate(
                                          'weightHeightPage.dialogBody')),
                                    ),
                                    actions: [
                                      ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  AppColors.colorCREDBoy),
                                          foregroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  AppColors.font_primary),
                                        ),
                                        child: Text(TranslateService.translate(
                                            'weightHeightPage.cancel')),
                                        onPressed: () => Navigator.pop(context),
                                      ),
                                      ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  AppColors.colorCREDBoy),
                                          foregroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  AppColors.font_primary),
                                        ),
                                        child: Text(TranslateService.translate(
                                            'weightHeightPage.accept')),
                                        onPressed: () async {
                                          bool answer;
                                          answer = await deleteRegister(
                                              text['id'], text['idLocal']);

                                          if (answer == true) {
                                            final snackBar = SnackBar(
                                              content: Text(
                                                  TranslateService.translate(
                                                      'weightHeightPage.confirmDelete')),
                                            );
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(snackBar);
                                            Navigator.pop(context);
                                          } else {
                                            final snackBar = SnackBar(
                                              content: Text(
                                                  TranslateService.translate(
                                                      'weightHeightPage.errorDelete')),
                                            );
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(snackBar);
                                          }
                                          actualizar();
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                icon: const Icon(Icons.delete),
                              ),
                            )),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              margin: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                              child: Text(
                                text['date'],
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 16),
                              ),
                            ),
                            Column(
                              children: [
                                Container(
                                  child: Text(
                                    '${TranslateService.translate('weightHeightPage.weight')}: ${text['weight']} kg',
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    '${TranslateService.translate('weightHeightPage.height')}: ${text['height']} cm',
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.black),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList()),
              );
            } else {
              return Container(
                margin: const EdgeInsets.all(20),
                child: const Center(child: CircularProgressIndicator()),
              );
            }
          },
        ),
      );
    } else {
      return Container();
    }
  }

  // Create the graphic of height and weight
  formarListaGrafico() {
    for (var value in data) {
      WHData clase = WHData(
          date: value['date'],
          weight: value['weight'].toDouble(),
          height: value['height'].toDouble());
      setState(() {
        dataGrafico.add(clase);
        dataGraficoReal.add(clase);
      });
    }
    heightsDividedBy100.clear();
    List<WHData> reversedList = List.from(dataGrafico.reversed);
    dataGrafico = reversedList;
  }

  // Returns a widget with the diagnostic
  Widget obtenerDiagnostico(
      int lengthDiagnosticNumber,
      String lengthDiagnostic,
      int weigthForLengthDiagnosticNumber,
      String weigthForLengthDiagnostic,
      String type) {
    if (type == 'length') {
      if (lengthDiagnosticNumber == 3) {
        return Container(
          padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
          decoration: const BoxDecoration(
              color: Colors.greenAccent,
              borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(20), right: Radius.circular(20))),
          child: Text(
            TranslateService.translate(lengthDiagnostic),
            style: const TextStyle(color: Colors.black, fontSize: 16),
          ),
        );
      } else if (lengthDiagnosticNumber == 2) {
        return Container(
          padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
          decoration: const BoxDecoration(
              color: Colors.orangeAccent,
              borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(20), right: Radius.circular(20))),
          child: Text(
            TranslateService.translate(lengthDiagnostic),
            style: const TextStyle(color: Colors.black, fontSize: 16),
          ),
        );
      } else if (lengthDiagnosticNumber == 1) {
        return Container(
          padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
          decoration: const BoxDecoration(
              color: Colors.redAccent,
              borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(20), right: Radius.circular(20))),
          child: Text(
            TranslateService.translate(lengthDiagnostic),
            style: const TextStyle(color: Colors.black, fontSize: 16),
          ),
        );
      } else {
        return Container(
          //padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
          child: Text(
            TranslateService.translate(lengthDiagnostic),
            style: const TextStyle(color: Colors.black, fontSize: 16),
          ),
        );
      }
    } else {
      if (weigthForLengthDiagnosticNumber == 5) {
        return Container(
          padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
          decoration: const BoxDecoration(
              color: Colors.redAccent,
              borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(20), right: Radius.circular(20))),
          child: Text(
            TranslateService.translate(weigthForLengthDiagnostic),
            style: const TextStyle(color: Colors.black, fontSize: 16),
          ),
        );
      } else if (weigthForLengthDiagnosticNumber == 4) {
        return Container(
          padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
          decoration: const BoxDecoration(
              color: Colors.orangeAccent,
              borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(20), right: Radius.circular(20))),
          child: Text(
            TranslateService.translate(weigthForLengthDiagnostic),
            style: const TextStyle(color: Colors.black, fontSize: 16),
          ),
        );
      } else if (weigthForLengthDiagnosticNumber == 3) {
        return Container(
          padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
          decoration: const BoxDecoration(
              color: Colors.greenAccent,
              borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(20), right: Radius.circular(20))),
          child: Text(
            TranslateService.translate(weigthForLengthDiagnostic),
            style: const TextStyle(color: Colors.black, fontSize: 16),
          ),
        );
      } else if (weigthForLengthDiagnosticNumber == 2) {
        return Container(
          padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
          decoration: const BoxDecoration(
              color: Colors.orangeAccent,
              borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(20), right: Radius.circular(20))),
          child: Text(
            TranslateService.translate(weigthForLengthDiagnostic),
            style: const TextStyle(color: Colors.black, fontSize: 16),
          ),
        );
      } else if (weigthForLengthDiagnosticNumber == 1) {
        return Container(
          padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
          decoration: const BoxDecoration(
              color: Colors.redAccent,
              borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(20), right: Radius.circular(20))),
          child: Text(
            TranslateService.translate(weigthForLengthDiagnostic),
            style: const TextStyle(color: Colors.black, fontSize: 16),
          ),
        );
      } else {
        return Container(
          //padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
          child: Text(
            TranslateService.translate(weigthForLengthDiagnostic),
            style: const TextStyle(color: Colors.black, fontSize: 16),
          ),
        );
      }
    }
  }

  // Shows the picture which represents kid's health
  presentaGrafico(
      int lengthDiagnosticNumber, int weightForLengthDiagnositicNumber) {
    if (weightForLengthDiagnositicNumber == 5) {
      return Container(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Color.fromRGBO(255, 0, 0, 0.2),
              ),
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Row(
                children: [
                  Container(
                    child: const Icon(Icons.warning, color: Colors.red),
                  ),
                  Expanded(
                    child: Text(
                      '$name '
                      '${TranslateService.translate('weightHeightPage.badMessageOne')} '
                      '${TranslateService.translate('weightHeightPage.obesity').toLowerCase()} '
                      '${TranslateService.translate('weightHeightPage.badMessageTwo')}',
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
              height: 150,
              width: 150,
              child: (gender == 1)
                  ? Image.asset(
                      '${GlobalVariables.logosCREDAddress}nina-crece.png',
                      height: 25,
                      width: 25)
                  : Image.asset(
                      '${GlobalVariables.logosCREDAddress}nina-crece.png',
                      height: 25,
                      width: 25),
            ),
          ],
        ),
      );
    } else if (weightForLengthDiagnositicNumber == 4) {
      return Container(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Color.fromRGBO(255, 0, 0, 0.2),
              ),
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Row(
                children: [
                  Container(
                    child: const Icon(Icons.warning, color: Colors.red),
                  ),
                  Expanded(
                    child: Text(
                      '$name '
                      '${TranslateService.translate('weightHeightPage.badMessageOne')} '
                      '${TranslateService.translate('weightHeightPage.overweight').toLowerCase()} '
                      '${TranslateService.translate('weightHeightPage.badMessageTwo')}',
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
              height: 150,
              width: 150,
              child: (gender == 1)
                  ? Image.asset(
                      '${GlobalVariables.logosCREDAddress}nina-crece.png',
                      height: 25,
                      width: 25)
                  : Image.asset(
                      '${GlobalVariables.logosCREDAddress}nina-crece.png',
                      height: 25,
                      width: 25),
            ),
          ],
        ),
      );
    } else if (weightForLengthDiagnositicNumber == 3) {
      return Container(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              // child: Expanded(
              //   child: Text(
              //     '${TranslateService.translate('weightHeightPage.goodMessage')} $name!',
              //     style: const TextStyle(
              //       fontSize: 16,
              //     ),
              //     textAlign: TextAlign.center,
              //   ),
              // ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
              height: 150,
              width: 150,
              child: (gender == 1)
                  ? Image.asset(
                      '${GlobalVariables.logosCREDAddress}nina-crece.png',
                      height: 25,
                      width: 25)
                  : Image.asset(
                      '${GlobalVariables.logosCREDAddress}nina-crece.png',
                      height: 25,
                      width: 25),
            ),
          ],
        ),
      );
    } else if (weightForLengthDiagnositicNumber == 2) {
      return Container(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Color.fromRGBO(255, 0, 0, 0.2),
              ),
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Row(
                children: [
                  Container(
                    child: const Icon(Icons.warning, color: Colors.red),
                  ),
                  Expanded(
                    child: Text(
                      '$name '
                      '${TranslateService.translate('weightHeightPage.badMessageOne')} '
                      '${TranslateService.translate('weightHeightPage.mildMalnutrition').toLowerCase()} '
                      '${TranslateService.translate('weightHeightPage.badMessageTwo')}',
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
              height: 150,
              width: 150,
              child: (gender == 1)
                  ? Image.asset(
                      '${GlobalVariables.logosCREDAddress}nina-crece.png',
                      height: 25,
                      width: 25)
                  : Image.asset(
                      '${GlobalVariables.logosCREDAddress}nina-crece.png',
                      height: 25,
                      width: 25),
            ),
          ],
        ),
      );
    } else if (weightForLengthDiagnositicNumber == 1) {
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Color.fromRGBO(255, 0, 0, 0.2),
              ),
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Row(
                children: [
                  Container(
                    child: const Icon(Icons.warning, color: Colors.red),
                  ),
                  Expanded(
                    child: Text(
                      '$name '
                      '${TranslateService.translate('weightHeightPage.badMessageOne')} '
                      '${TranslateService.translate('weightHeightPage.seriousMalnutrition').toLowerCase()} '
                      '${TranslateService.translate('weightHeightPage.badMessageTwo')}',
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
              height: 150,
              width: 150,
              child: (gender == 1)
                  ? Image.asset(
                      '${GlobalVariables.logosCREDAddress}nina-crece.png',
                      height: 25,
                      width: 25)
                  : Image.asset(
                      '${GlobalVariables.logosCREDAddress}nina-crece.png',
                      height: 25,
                      width: 25),
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  Widget createLengthDiagnosticGauge(int diagnosticNumber, String diagnostic,
      double length, BuildContext context) {
    String title;
    String text1;
    String text2;
    switch (diagnosticNumber) {
      case 1:
        diagnosticNumber = -2;
        break;
      case 2:
        diagnosticNumber = -1;
        break;
      case 3:
        diagnosticNumber = 0;
        break;
      default:
    }
    double hArrowPositioning;
    if (diagnosticNumber == -2) {
      title = 'Retardo de crecimiento';
      text1 =
          'Significado: La longitud de su bebé es muy baja para la edad que tiene.';
      text2 =
          'Incluya diariamente alimentos de origen animal como hígado, bazo, pescado, huevo y otras carnes para el buen crecimiento y desarrollo.';
      // hArrowPositioning = 0;
      // hArrowPositioning = (hValue * (severeAnemiaLimit / width)) * width;
      // print("severe");
      // print(hValue);
      // print(hArrowPositioning);
      hArrowPositioning = width / 3 * 0.5;
    } else if (diagnosticNumber == -1) {
      title = 'Riesgo de Retardo en el Crecimiento';
      text1 = '';
      text2 = '';
      // hArrowPositioning =
      //     (hValue * ((moderateAnemiaLimit - severeAnemiaLimit) / width)) *
      //             width +
      //         (width);
      // print("moderate");
      // print(hValue);
      // print(hArrowPositioning);
      hArrowPositioning = width / 3 * 1.5;
    } else if (diagnosticNumber == 0) {
      title = 'Normal';
      text1 = '¡Felicidades! 🎉'
          '$name está creciendo muy bien 🥳'
          'Continúe alimentándolo con alimentos de origen animal, verduritas, frutas, cereales, tubérculos y menestras.';
      text2 = '';
      // hArrowPositioning =
      //     (hValue * ((lightAnemiaLimit - moderateAnemiaLimit) / width)) *
      //             width +
      //         (width + 2);
      // print("light");
      // print(hValue);
      // print(hArrowPositioning);
      hArrowPositioning = width / 3 * 2.5;
    } else {
      title = 'Error';
      text1 = '';
      text2 = '';
      // hArrowPositioning =
      //     (hValue * ((noAnemiaLimit - lightAnemiaLimit) / width)) * width +
      //         (width * 3);
      // print("no");
      // print(hValue);
      // print(hArrowPositioning);
      hArrowPositioning = -20;
    }
    if (hArrowPositioning > width) {
      hArrowPositioning = (width) - 20;
    }
    return SizedBox(
      height: height * 6,
      child: Stack(
        children: <Widget>[
          Positioned(
            bottom: height + 20,
            child: SizedBox(
              height: height * 2,
              child: Row(
                children: [
                  SizedBox(
                    width: width / 3,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius:
                            BorderRadius.horizontal(left: Radius.circular(20)),
                      ),
                      child: Center(
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: Text(
                            TranslateService.translate(
                              'weightHeightPage.slowGrowth',
                            ),
                            style: const TextStyle(
                              color: Color.fromARGB(255, 243, 243, 243),
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width / 3,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.orangeAccent,
                      ),
                      child: Center(
                        child: Text(
                          TranslateService.translate(
                              'weightHeightPage.riskSlowGrowth'),
                          style: const TextStyle(
                            fontSize: 11.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width / 3,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.greenAccent,
                        borderRadius:
                            BorderRadius.horizontal(right: Radius.circular(20)),
                      ),
                      child: Center(
                        child: Text(
                          TranslateService.translate('weightHeightPage.normal'),
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: height * 2 + 12,
            left: hArrowPositioning,
            child: const Icon(
              Icons.arrow_drop_down,
              size: 60,
            ),
          ),
          Positioned(
            bottom: height + 10,
            left: hArrowPositioning,
            child: Transform.rotate(
              angle: 90 * pi / 180,
              child: const Icon(
                Icons.horizontal_rule,
                size: 60,
              ),
            ),
          ),
          Positioned(
            bottom: height * 4 + 10,
            left: hArrowPositioning,
            child: Center(
              child: Text(
                '$length cm',
              ),
            ),
          ),
          Positioned(
            height: height,
            bottom: 0,
            right: 0,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(AppColors.colorAddButtons),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
              onPressed: () => _showMyDialog(context, title, text1, text2),
              child: Text(
                '${TranslateService.translate('anemiaCheckPage.moreInfo')} ${TranslateService.translate(diagnostic).toLowerCase()}',
                style: const TextStyle(fontSize: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget createWeightForLengthDiagnosticGauge(int diagnosticNumber,
      String diagnostic, double weight, BuildContext context) {
    print(diagnostic);
    String title;
    String text1;
    String text2;
    switch (diagnosticNumber) {
      case 1:
        diagnosticNumber = -2;
        break;
      case 2:
        diagnosticNumber = -1;
        break;
      case 3:
        diagnosticNumber = 0;
        break;
      case 4:
        diagnosticNumber = 1;
        break;
      case 5:
        diagnosticNumber = 2;
        break;
      default:
    }
    double hArrowPositioning;
    if (diagnosticNumber == -2) {
      title = 'Desnutrición Aguda';
      text1 =
          'Significado: El peso de su bebé es muy bajo para la talla que tiene.';
      text2 =
          'A partir de los 6 meses ofrezca a su bebé alimentos espesos todos los días. Incremente la cantidad de alimentos que le ofrece a su bebé de acuerdo a la edad que tiene. ';
      // hArrowPositioning = 0;
      // hArrowPositioning = (hValue * (severeAnemiaLimit / width)) * width;
      // print("severe");
      // print(hValue);
      // print(hArrowPositioning);
      hArrowPositioning = 20;
    } else if (diagnosticNumber == -1) {
      title = 'Desnutrición Aguda';
      text1 =
          'Significado: El peso de su bebé es muy bajo para la talla que tiene.';
      text2 =
          'A partir de los 6 meses ofrezca a su bebé alimentos espesos todos los días. Incremente la cantidad de alimentos que le ofrece a su bebé de acuerdo a la edad que tiene. ';
      // hArrowPositioning =
      //     (hValue * ((moderateAnemiaLimit - severeAnemiaLimit) / width)) *
      //             width +
      //         (width);
      // print("moderate");
      // print(hValue);
      // print(hArrowPositioning);
      hArrowPositioning = 70;
    } else if (diagnosticNumber == 0) {
      title = 'Normal';
      text1 =
          'Significado: El peso de su bebé es adecuado para la talla que tiene.';
      text2 =
          'Recuerde ofrecer a su bebé una alimentación variada que incluya alimentos de origen animal, verduras, frutas, cereales, tubérculos, menestras.';
      // hArrowPositioning =
      //     (hValue * ((lightAnemiaLimit - moderateAnemiaLimit) / width)) *
      //             width +
      //         (width + 2);
      // print("light");
      // print(hValue);
      // print(hArrowPositioning);
      hArrowPositioning = 120;
    } else if (diagnosticNumber == 1) {
      title = 'Sobrepeso';
      text1 =
          'Significado: El peso de su bebé está por encima de lo que se considera saludable para la talla que tiene.';
      text2 =
          'Cuidar la cantidad de alimentos que le ofrece a su bebé y también la frecuencia con la que se los ofrece. Es importante que su bebé se acostumbre a consumir alimentos sin azúcar agregada.  ';
      // hArrowPositioning =
      //     (hValue * ((noAnemiaLimit - lightAnemiaLimit) / width)) * width +
      //         (width * 3);
      // print("no");
      // print(hValue);
      // print(hArrowPositioning);
      hArrowPositioning = 170;
    } else if (diagnosticNumber == 2) {
      title = 'Obesidad';
      text1 =
          'Significado: El peso de su bebé está por muy por encima de lo que se considera saludable para la talla que tiene.';
      text2 =
          'Cuidar la cantidad de alimentos que le ofrece a su bebé y también la frecuencia con la que se los ofrece. Es importante que su bebé se acostumbre a consumir alimentos sin azúcar agregada. Promueva la actividad física en los niños como correr, saltar, jugar diariamente. Importante continuar con la lactancia materna.';
      hArrowPositioning = 220;
    } else {
      title = '';
      text1 = '';
      text2 = '';
      hArrowPositioning = -10;
    }
    if (hArrowPositioning > width) {
      hArrowPositioning = (width) - 20;
    }
    return SizedBox(
      height: height * 6,
      child: Stack(
        children: <Widget>[
          Positioned(
            bottom: height + 20,
            child: SizedBox(
              height: height * 2,
              child: Row(
                children: [
                  SizedBox(
                    width: width / 5,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius:
                            BorderRadius.horizontal(left: Radius.circular(20)),
                      ),
                      child: Center(
                        child: Text(
                          TranslateService.translate(
                            'weightHeightPage.seriousMalnutrition',
                          ),
                          style: const TextStyle(
                            color: Color.fromARGB(255, 243, 243, 243),
                            fontSize: 9,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width / 5,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.orangeAccent,
                      ),
                      child: Center(
                        child: Text(
                          TranslateService.translate(
                              'weightHeightPage.mildMalnutrition'),
                          style: const TextStyle(
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width / 5,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.greenAccent,
                      ),
                      child: Center(
                        child: Text(
                          TranslateService.translate('weightHeightPage.normal'),
                          style: const TextStyle(
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width / 5,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.orangeAccent,
                      ),
                      child: Center(
                        child: Text(
                          TranslateService.translate(
                              'weightHeightPage.overweight'),
                          style: const TextStyle(
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width / 5,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius:
                            BorderRadius.horizontal(right: Radius.circular(20)),
                      ),
                      child: Center(
                        child: Text(
                          TranslateService.translate(
                            'weightHeightPage.obesity',
                          ),
                          style: const TextStyle(
                            color: Color.fromARGB(255, 243, 243, 243),
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: height * 2 + 12,
            left: hArrowPositioning,
            child: const Icon(
              Icons.arrow_drop_down,
              size: 60,
            ),
          ),
          Positioned(
            bottom: height + 10,
            left: hArrowPositioning,
            child: Transform.rotate(
              angle: 90 * pi / 180,
              child: const Icon(
                Icons.horizontal_rule,
                size: 60,
              ),
            ),
          ),
          Positioned(
            bottom: height * 4 + 10,
            left: hArrowPositioning + 5,
            child: Text(
              '$weight kg',
            ),
          ),
          Positioned(
            height: height,
            bottom: 0,
            right: 0,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(AppColors.colorAddButtons),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
              onPressed: () => _showMyDialog(context, title, text1, text2),
              child: Text(
                '${TranslateService.translate('anemiaCheckPage.moreInfo')} ${TranslateService.translate(diagnostic).toLowerCase()}',
                style: const TextStyle(fontSize: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showMyDialog(
      BuildContext context, String title, String text1, String text2) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          // icon: Image.asset(
          //   '${GlobalVariables.logosAddress}hemoglobina_logo.png',
          //   width: 40,
          //   height: 40,
          // ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(text1),
                SizedBox(
                  height: 10,
                ),
                Text(text2)
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  actualizar() {
    setState(() {
      loadWeightHeight();
    });
  }

  @override
  initState() {
    super.initState();
    loadWeightHeight();
    generateFeatures();
  }

  List<double> heightsDividedBy100 = [];
  List<double> generateFeatures() {
    heightsDividedBy100.clear();
    for (var item in dataGrafico) {
      double heightInCM = item.height; // Assuming height is in centimeters
      double heightDividedBy100 = heightInCM;
      heightsDividedBy100.add(heightDividedBy100);
    }

    List<Feature> features = [
      Feature(
        title: "Height at months",
        color: Color(0xffFFAB41),
        data: heightsDividedBy100,
      ),
      Feature(
        title: "Ideal Height",
        color: Color(0xfff53d07),
        data: [
          0.48,
          0.525,
          0.57,
          0.6,
          0.625,
          0.645,
          0.66,
          0.675,
          0.685,
          0.7,
          0.715,
          0.73,
          0.725,
          0.75,
          0.765,
          0.78,
          0.795,
          0.815
        ],
      ),
    ];

    return heightsDividedBy100;
  }

  List<Color> colors = [
    Color(0xff4d504d),
    Color(0xff6b79a6),
    Color(0xffd6dcd6),
    Color(0xff779b73),
    Color(0xffa9dda5),
    Color(0xff9aaced),
  ];
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
          ],
        ),
        backgroundColor: AppColors.colorCREDBoy,
        elevation: 0,
      ),

      //endDrawer: LateralMenuCenter.fromInsideCRED(4, idKid, name),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 50),
        child: Container(
          margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                      height: 50,
                      width: 50,
                      child: Image.asset(
                          '${GlobalVariables.logosAddress}altura_logo.png',
                          height: 25,
                          width: 25),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: Text(
                        TranslateService.translate('weightHeightPage.title'),
                        style: const TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              Builder(
                builder: (context) {
                  if (data.isNotEmpty && cargado) {
                    return Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            color: AppColors.colorCREDBoy,
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.grey,
                                offset: Offset(0.0, 3.0),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Table(
                                defaultVerticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                //mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  TableRow(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.fromLTRB(
                                            0, 0, 0, 15),
                                        child: Text(
                                          '${TranslateService.translate('weightHeightPage.date')}: ',
                                          textAlign: TextAlign.start,
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.fromLTRB(
                                            0, 0, 0, 15),
                                        child: Text(
                                          data[0]['date'],
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 16),
                                        ),
                                      ),
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.fromLTRB(
                                            0, 0, 0, 15),
                                        child: Text(
                                          '${TranslateService.translate('anemiaCheckPage.age')}: ',
                                          textAlign: TextAlign.start,
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.fromLTRB(
                                            0, 0, 0, 15),
                                        child: Text(
                                          '${data[0]['age']} ${TranslateService.translate('anemiaCheckPage.month')}',
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 16),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            color: AppColors.colorCREDBoy,
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.grey,
                                offset: Offset(0.0, 3.0),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                          child: Column(
                            children: [
                              Text(
                                TranslateService.translate(
                                    'weightHeightPage.height'),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Text(
                                '${data[0]["height"]} cm '
                                '(${name[0].toUpperCase() + name.substring(1)} '
                                '${TranslateService.translate('weightHeightPage.growth')} '
                                '${data[0]["height"] - (data.length > 1 ? data[1]['height'] : 0)} cm '
                                '${TranslateService.translate('weightHeightPage.sinceLastMonth')})',
                                style: const TextStyle(fontSize: 13),
                              ),
                              createLengthDiagnosticGauge(
                                  data[0]['lengthDiagnosticNumber'],
                                  data[0]['lengthDiagnostic'],
                                  data[0]['height'],
                                  context),
                            ],
                          ),
                        ),
                        Container(
                            margin: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              color: AppColors.colorCREDBoy,
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(0.0, 3.0),
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: Chart(
                              state: ChartState<void>(
                                data: ChartData.fromList(generateFeatures()
                                    .map((e) => BubbleValue<void>(e.toDouble()))
                                    .toList()),
                                // axisMax: 9,
                                itemOptions: BubbleItemOptions(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 2.0),
                                  bubbleItemBuilder: (_) => BubbleItem(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      border: BorderSide()),
                                  maxBarWidth: 3.0,
                                ),
                                backgroundDecorations: [
                                  GridDecoration(
                                    // showHorizontalValues: true,
                                    showVerticalGrid: false,
                                    horizontalAxisStep: 10,
                                    gridColor: Theme.of(context).dividerColor,
                                  ),
                                  SparkLineDecoration(
                                    lineWidth: 2.0,
                                    lineColor:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ],
                              ),
                            )

                            // Graph(
                            //   GraphData(
                            //       'Height',
                            //       [
                            //         GraphBar(
                            //           DateTime(2020, 01),
                            //           [
                            //             GraphBarSection(200, color: Colors.pink),
                            //           ],
                            //         ),
                            //         GraphBar(
                            //           DateTime(2020, 2),
                            //           [
                            //             GraphBarSection(300, color: Colors.pink),
                            //           ],
                            //         ),
                            //         GraphBar(
                            //           DateTime(2020, 3),
                            //           [
                            //             GraphBarSection(400, color: Colors.pink),
                            //           ],
                            //         ),
                            //         GraphBar(
                            //           DateTime(2020, 4),
                            //           [
                            //             GraphBarSection(400, color: Colors.pink),
                            //           ],
                            //         ),
                            //         GraphBar(
                            //           DateTime(2020, 5),
                            //           [
                            //             GraphBarSection(700, color: Colors.pink),
                            //           ],
                            //         ),
                            //         GraphBar(
                            //           DateTime(2020, 6),
                            //           [
                            //             GraphBarSection(900, color: Colors.pink),
                            //           ],
                            //         ),
                            //         GraphBar(
                            //           DateTime(2020, 7),
                            //           [
                            //             GraphBarSection(300, color: Colors.pink),
                            //           ],
                            //         ),
                            //         GraphBar(
                            //           DateTime(2020, 8),
                            //           [
                            //             GraphBarSection(250, color: Colors.pink),
                            //           ],
                            //         ),
                            //         GraphBar(
                            //           DateTime(2020, 9),
                            //           [
                            //             GraphBarSection(300, color: Colors.pink),
                            //           ],
                            //         ),
                            //         // GraphBar.fromMap({"30": {}}),
                            //       ],
                            //       AppColors.colorCREDBoy),
                            //   graphType: GraphType.LineGraph,
                            //   netLine: NetLine(
                            //     showPointOnly: false,
                            //     showLine: true,
                            //     lineColor: Colors.white,
                            //     pointBorderColor: Color(0xffFFAB41),
                            //     coreColor: Color(0xffFFAB41),
                            //   ),
                            //   yLabelConfiguration: YLabelConfiguration(
                            //     labelStyle: TextStyle(
                            //       color: Colors.grey,
                            //       fontSize: 11,
                            //     ),
                            //     interval: 10,
                            //     labelCount: 15,
                            //     labelMapper: (num value) {
                            //       print(value);
                            //       return value.toString();
                            //     },
                            //   ),
                            //   xLabelConfiguration: XLabelConfiguration(
                            //     labelStyle: TextStyle(
                            //       color: Colors.grey,
                            //       fontSize: 11,
                            //     ),
                            //     labelMapper: (DateTime date) {
                            //       return date.month.toString();
                            //     },
                            //   ),
                            //   barWidth: 14,
                            // )
                            // LineGraph(
                            //   features: generateFeatures(dataGraficoReal),
                            //   size: Size(MediaQuery.of(context).size.width, 300),
                            //   labelX: [
                            //     '1',
                            //     '2',
                            //     '3',
                            //     '4',
                            //     '5',
                            //     '6',
                            //     '7',
                            //     '8',
                            //     '9',
                            //     '10',
                            //     '11',
                            //     '12',
                            //     '15',
                            //     '18',
                            //     '21',
                            //     '24',
                            //     '30'
                            //   ],
                            //   labelY: [
                            //     '10',
                            //     '20',
                            //     '30',
                            //     '40',
                            //     '50',
                            //     '60',
                            //     '70',
                            //     '80',
                            //     '90',
                            //     '100'
                            //   ],
                            //   showDescription: false,
                            //   graphColor: Colors.black,
                            //   graphOpacity: 0,
                            //   verticalFeatureDirection: true,
                            //   // descriptionHeight: 130,
                            // )

                            ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            color: AppColors.colorCREDBoy,
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.grey,
                                offset: Offset(0.0, 3.0),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                          child: Column(
                            children: [
                              Text(
                                TranslateService.translate(
                                    'weightHeightPage.weight'),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Text(
                                '${data[0]["weight"]} kg '
                                '(${name[0].toUpperCase() + name.substring(1)} '
                                '${TranslateService.translate('weightHeightPage.gained')} '
                                '${data[0]["weight"] - (data.length > 1 ? data[1]['weight'] : 0)} kg '
                                '${TranslateService.translate('weightHeightPage.sinceLastMonth')})',
                                style: const TextStyle(fontSize: 13),
                              ),
                              createWeightForLengthDiagnosticGauge(
                                  data[0]['weightForLengthDiagnosticNumber'],
                                  data[0]['weightForLengthDiagnostic'],
                                  data[0]['weight'],
                                  context)
                            ],
                          ),
                        ),
                        presentaGrafico(data[0]['lengthDiagnosticNumber'],
                            data[0]['weightForLengthDiagnosticNumber']),
                        // Divider(
                        //     color: AppColors.colorCREDBoy,
                        //     thickness: 5,
                        //     height: 30),
                        // Container(child: FutureBuilder(
                        //   builder: (context, snapshot) {
                        //     if (dataGrafico.isNotEmpty) {
                        //       return SfCartesianChart(
                        //           primaryXAxis: CategoryAxis(
                        //             isVisible: true,
                        //             // Mostrar cronología en la parte superior
                        //             opposedPosition: false,
                        //             // El eje del tiempo se invierte
                        //             isInversed: false,
                        //           ),
                        //           //Título
                        //           title: ChartTitle(
                        //               text: TranslateService.translate(
                        //                   'weightHeightPage.lineChart')),
                        //           // Tipo seleccionado
                        //           selectionType: SelectionType.series,
                        //           // Transposición de eje de tiempo y eje de valor
                        //           isTransposed: false,
                        //           // Seleccionar gesto
                        //           selectionGesture: ActivationMode.singleTap,
                        //           //Ilustración
                        //           legend: Legend(
                        //               isVisible: true,
                        //               iconHeight: 10,
                        //               iconWidth: 10,
                        //               // Pantalla de la serie de interruptores
                        //               toggleSeriesVisibility: true,
                        //               // Posición de visualización de la ilustración
                        //               position: LegendPosition.bottom,
                        //               overflowMode: LegendItemOverflowMode.wrap,
                        //               // Ilustración posición izquierda y derecha
                        //               alignment: ChartAlignment.center),
                        //           //Cruzar
                        //           crosshairBehavior: CrosshairBehavior(
                        //             lineType: CrosshairLineType
                        //                 .horizontal, // Indicador de selección horizontal
                        //             enable: true,
                        //             shouldAlwaysShow:
                        //                 false, // La cruz siempre se muestra (indicador de selección horizontal)
                        //             activationMode: ActivationMode.singleTap,
                        //           ),
                        //           // Seguimiento de la pelota
                        //           trackballBehavior: TrackballBehavior(
                        //             lineType: TrackballLineType
                        //                 .vertical, // Indicador de selección vertical
                        //             activationMode: ActivationMode.singleTap,
                        //             enable: true,
                        //             tooltipAlignment: ChartAlignment
                        //                 .near, // Posición de la información sobre herramientas (arriba)
                        //             shouldAlwaysShow:
                        //                 true, // Track ball siempre se muestra (indicador de selección vertical)
                        //             tooltipDisplayMode: TrackballDisplayMode
                        //                 .groupAllPoints, // Modo de información sobre herramientas (agrupar todos)
                        //           ),
                        //           // Abrir información sobre herramientas
                        //           tooltipBehavior: TooltipBehavior(
                        //             enable: true,
                        //             shared: true,
                        //             activationMode: ActivationMode.singleTap,
                        //           ),
                        //           // SplineSeries es una curva LineSeries es una polilínea ChartSeries
                        //           series: <ChartSeries<WHData, String>>[
                        //             LineSeries<WHData, String>(
                        //               name: TranslateService.translate(
                        //                   'weightHeightPage.weight'),
                        //               dataSource: dataGrafico,
                        //               xValueMapper: (WHData sales, _) =>
                        //                   sales.date,
                        //               yValueMapper: (WHData sales, _) =>
                        //                   sales.weight,
                        //               // Mostrar etiqueta de datos
                        //               dataLabelSettings:
                        //                   const DataLabelSettings(
                        //                 isVisible: false,
                        //               ),
                        //               // Modificar puntos de datos (mostrar círculos)
                        //               markerSettings:
                        //                   const MarkerSettings(isVisible: true),
                        //             ),
                        //             LineSeries<WHData, String>(
                        //               name: TranslateService.translate(
                        //                   'weightHeightPage.height'),
                        //               dataSource: dataGrafico,
                        //               xValueMapper: (WHData sales, _) =>
                        //                   sales.date,
                        //               yValueMapper: (WHData sales, _) =>
                        //                   sales.height,
                        //               // Mostrar etiqueta de datos
                        //               dataLabelSettings:
                        //                   const DataLabelSettings(
                        //                 isVisible: false,
                        //               ),
                        //               // Modificar puntos de datos (mostrar círculos)
                        //               markerSettings:
                        //                   const MarkerSettings(isVisible: true),
                        //             ),
                        //           ]);
                        //     } else {
                        //       return Container(
                        //         margin: const EdgeInsets.all(20),
                        //         child: const Center(
                        //             child: CircularProgressIndicator()),
                        //       );
                        //     }
                        //   },
                        // ),
                        // ),
                        Divider(
                            color: AppColors.colorCREDBoy,
                            thickness: 5,
                            height: 30),
                        Container(
                            margin: const EdgeInsets.fromLTRB(0, 20, 0, 15),
                            child: InkWell(
                              onTap: () {
                                if (presentaHistorial) {
                                  setState(() {
                                    presentaHistorial = false;
                                  });
                                } else {
                                  setState(() {
                                    presentaHistorial = true;
                                  });
                                }
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    TranslateService.translate(
                                        'weightHeightPage.record'),
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Icon(presentaHistorial
                                      ? Icons.arrow_drop_up
                                      : Icons.arrow_drop_down)
                                ],
                              ),
                            )),
                        showRecord(),
                      ],
                    );
                  } else if (!cargado) {
                    return Container(
                      margin: const EdgeInsets.all(20),
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  } else {
                    return Container(
                      margin: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Center(
                            child: Text(TranslateService.translate(
                                'weightHeightPage.empty')),
                          ),
                          Container(
                            margin: const EdgeInsets.fromLTRB(25, 5, 25, 0),
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
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                              ),
                              child: Text(
                                TranslateService.translate(
                                    'weightHeightPage.addCheck'),
                                style: const TextStyle(fontSize: 18),
                                softWrap: true,
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        AddWeightAndHeightPage(
                                      idKid: idKid,
                                      kidName: name,
                                    ),
                                  ),
                                ).then((value) => actualizar());
                              },
                            ),
                          )
                        ],
                      ),
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationPage(),
      floatingActionButton: data.isNotEmpty
          ? Container(
              margin: const EdgeInsets.fromLTRB(25, 5, 25, 0),
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
                child: Text(
                  TranslateService.translate('anemiaCheckPage.addCheck'),
                  style: const TextStyle(fontSize: 18),
                  softWrap: true,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddWeightAndHeightPage(
                              idKid: idKid,
                              kidName: name,
                            )),
                  ).then((value) => actualizar());
                },
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
