// ignore_for_file: avoid_unnecessary_containers

import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:perusano/components/bottomNavigation.dart';

import '../../../services/apis/cred/credRegisterCenter.dart';
import '../../../services/fileManagement/cred/anemiaCheckFM.dart';
import '../../../services/translateService.dart';
import '../../../util/globalVariables.dart';
import '../../../util/myColors.dart';
import 'add_anemia_check_page.dart';

class AnemiaCheckPage extends StatefulWidget {
  int idKid;
  String name;
  int gender;
  AnemiaCheckPage(
      {super.key,
      required this.idKid,
      required this.name,
      required this.gender});

  @override
  State<StatefulWidget> createState() =>
      _AnemiaCheckPage(idKid: idKid, name: name, gender: gender);
}

class _AnemiaCheckPage extends State<AnemiaCheckPage> {
  int idKid;
  String name;
  List data = [];
  List dataObt = [];
  int gender;

  final AnemiaCheckFM storage = AnemiaCheckFM();

  bool cargado = false;

  bool showHistory = false;
  double severeAnemiaLimit = 7.0;
  double moderateAnemiaLimit = 9.9;
  double lightAnemiaLimit = 10.9;
  double noAnemiaLimit = 15.0;

  // double severeAnemiaLimit = 6.3;
  // double moderateAnemiaLimit = 9.2;
  // double lightAnemiaLimit = 10.2;
  // double noAnemiaLimit = 14.3;

  final double width = 300;
  final double height = 20;
  final double radius = 10;

  _AnemiaCheckPage(
      {required this.idKid, required this.name, required this.gender});

  //This method loads the dara from local storage
  loadAnemiaCheck() async {
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

    cargado = true;
  }

  // This method deletes the register from local storage and prepares it for deletion from the database
  Future<bool> deleteRegister(int idData, int idLocal) async {
    Map answer = {};
    if (idData == 0) {
      answer = await storage.deleteRegister(idLocal);
    } else {
      answer = await storage.changeWasDeleted(idLocal);

      bool isConnected = await GlobalVariables.isConnected();
      if (isConnected) {
        await CredRegisterCenter().deleteAnemiaCheck(answer['id']);
        await storage.deleteRegister(idLocal);
      }
    }
    if (answer['id'] >= 0) {
      return true;
    }
    return false;
  }

  Widget createDiagnosticGauge(double hValue, BuildContext context) {
    String title = '';
    String text1 = '';
    String text2 = '';
    double hArrowPositioning;
    if (hValue < severeAnemiaLimit) {
      title = 'Anemia severa';
      text1 =
          'Significado: La hemoglobina de su niña/o está muy por debajo del nivel considerado como saludable y su niño está en alto riesgo de sufrir muchas complicaciones de salud. La anemia además afecta su crecimiento y también el desarrollo de su cerebro.';
      text2 =
          'Lleve inmediatamente a su niña/o al centro de salud para que reciba el tratamiento más adecuado.  Es muy importante seguir las recomendaciones del personal de salud para poder recuperar la salud de su niña/o';
      // hArrowPositioning = 0;
      hArrowPositioning = (hValue * (severeAnemiaLimit / width)) * width;
      print("severe");
      print(hValue);
      print(hArrowPositioning);
      hArrowPositioning = 20;
    } else if (hValue < moderateAnemiaLimit) {
      title = 'Anemia moderada';
      text1 =
          'Significado: La hemoglobina de su niña/o está muy por debajo del nivel considerado como saludable y eso impide su adecuado desarrollo. La anemia además afecta su crecimiento y también el desarrollo de su cerebro.';
      text2 =
          'Lleve a su niña/o al centro de salud para que reciba su suplemento de hierro y le indiquen cómo debe consumirlo. Es muy importante que consuma su suplemento todos los días para que pueda mejorar su nivel de hemoglobina.';
      hArrowPositioning =
          (hValue * ((moderateAnemiaLimit - severeAnemiaLimit) / width)) *
                  width +
              (width);
      print("moderate");
      print(hValue);
      print(hArrowPositioning);
      hArrowPositioning = 20 + 77;
    } else if (hValue < lightAnemiaLimit) {
      title = 'Anemia leve';
      text1 =
          'Significado: La hemoglobina de su niña/o está por debajo del nivel considerado como saludable y eso  impide su adecuado desarrollo. La anemia además afecta su crecimiento y también el desarrollo de su cerebro.';
      text2 =
          'Importante llevar a su niña/o al centro de salud para realizar sus controles de hemoglobina y que consuma su suplemento de hierro todos los días para mejorar su nivel de hemoglobina.'
          'Los alimentos de origen animal como el hígado, el bazo o la sangrecita son fuente de hierro y ayuda a mejorar su nivel de hemoglobina.';
      hArrowPositioning =
          (hValue * ((lightAnemiaLimit - moderateAnemiaLimit) / width)) *
                  width +
              (width + 2);
      print("light");
      print(hValue);
      print(hArrowPositioning);
      hArrowPositioning = 93 + 77;
    } else {
      title = 'Sin Anemia';
      text1 = '¡Muy bien!';
      text2 = '';
      hArrowPositioning =
          (hValue * ((noAnemiaLimit - lightAnemiaLimit) / width)) * width +
              (width * 3);
      print("no");
      print(hValue);
      print(hArrowPositioning);
      hArrowPositioning = 150 + 77;
      if (hArrowPositioning > width * 4) {
        hArrowPositioning = (width * 4) - 20;
      }
    }
    return SizedBox(
      height: height * 6,
      child: Stack(
        children: <Widget>[
          Positioned(
            bottom: height + 30,
            child: SizedBox(
              height: height * 2,
              child: Row(
                children: [
                  SizedBox(
                    width: width / 4,
                    child: Container(
                      padding: const EdgeInsets.all(3),
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
                              'anemiaCheckPage.strict',
                            ),
                            style: const TextStyle(
                              color: Color.fromARGB(255, 243, 243, 243),
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width / 4,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        color: Colors.orangeAccent,
                      ),
                      child: Center(
                        child: Text(
                          TranslateService.translate(
                              'anemiaCheckPage.moderate'),
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width / 4,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        color: Colors.yellow,
                      ),
                      child: Center(
                        child: Text(
                          TranslateService.translate('anemiaCheckPage.mild'),
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width / 4,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        color: Colors.greenAccent,
                        borderRadius:
                            BorderRadius.horizontal(right: Radius.circular(20)),
                      ),
                      child: Center(
                        child: Text(
                          TranslateService.translate('anemiaCheckPage.without'),
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
            bottom: height * 2 + 22,
            left: hArrowPositioning,
            child: const Icon(
              Icons.arrow_drop_down,
              size: 60,
            ),
          ),
          Positioned(
            bottom: height + 20,
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
            bottom: height * 4 + 20,
            left: hArrowPositioning + 5,
            child: Text(
              '${hValue}g/Dl',
            ),
          ),
          Positioned(
            bottom: height + 10,
            left: width / 4 - 10,
            child: Text(severeAnemiaLimit.toString()),
          ),
          Positioned(
            bottom: height + 10,
            left: ((width / 4) * 2) - 10,
            child: Text(moderateAnemiaLimit.toString()),
          ),
          Positioned(
            bottom: height + 10,
            left: ((width / 4) * 3) - 15,
            child: Text(lightAnemiaLimit.toString()),
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
                '${TranslateService.translate('anemiaCheckPage.moreInfo')} ${title.toLowerCase()}',
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
                const Text(''),
                Text(text2),
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

  // This method returns a widget with the diagnostic
  Widget obtenerDiagnostico(double resultado) {
    if (resultado < severeAnemiaLimit) {
      return Container(
        padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
        decoration: const BoxDecoration(
            color: Colors.redAccent,
            borderRadius: BorderRadius.horizontal(
                left: Radius.circular(20), right: Radius.circular(20))),
        child: Text(
          TranslateService.translate('anemiaCheckPage.strict'),
          style: const TextStyle(color: Colors.black, fontSize: 14),
        ),
      );
    } else if (resultado < moderateAnemiaLimit) {
      return Container(
        padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
        decoration: const BoxDecoration(
            color: Colors.orangeAccent,
            borderRadius: BorderRadius.horizontal(
                left: Radius.circular(20), right: Radius.circular(20))),
        child: Text(
          TranslateService.translate('anemiaCheckPage.moderate'),
          style: const TextStyle(color: Colors.black, fontSize: 14),
        ),
      );
    } else if (resultado < lightAnemiaLimit) {
      return Container(
        padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
        decoration: const BoxDecoration(
            color: Colors.yellow,
            borderRadius: BorderRadius.horizontal(
                left: Radius.circular(20), right: Radius.circular(20))),
        child: Text(
          TranslateService.translate('anemiaCheckPage.mild'),
          style: const TextStyle(color: Colors.black, fontSize: 14),
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
        decoration: const BoxDecoration(
            color: Colors.greenAccent,
            borderRadius: BorderRadius.horizontal(
                left: Radius.circular(20), right: Radius.circular(20))),
        child: Text(
          TranslateService.translate('anemiaCheckPage.without'),
          style: const TextStyle(color: Colors.black, fontSize: 14),
        ),
      );
    }
  }

  // This method show the picture that represents kid's health
  presentaGrafico(double resultado) {
    if (gender == 1) {
      if (resultado < lightAnemiaLimit) {
        return Container(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                height: 150,
                width: 150,
                child: Image.asset(
                    gender == 1
                        ? '${GlobalVariables.logosCREDAddress}htriste_boy.png'
                        : '${GlobalVariables.logosCREDAddress}htriste_girl.png',
                    height: 25,
                    width: 25),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: Text(
                  '${TranslateService.translate('anemiaCheckPage.underMessageOne')} $name'
                  ' ${TranslateService.translate('anemiaCheckPage.underMessageTwo')}',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        );
      } else {
        return Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                height: 150,
                width: 150,
                child: Image.asset(
                    gender == 1
                        ? '${GlobalVariables.logosCREDAddress}hfeliz_boy.png'
                        : '${GlobalVariables.logosCREDAddress}hfeliz_girl.png',
                    height: 25,
                    width: 25),
              ),
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: Text(
                  '${TranslateService.translate('anemiaCheckPage.goodMessage')} $name !',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        );
      }
    } else {
      if (resultado < lightAnemiaLimit) {
        return Container(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                height: 150,
                width: 150,
                child: Image.asset(
                    gender == 1
                        ? '${GlobalVariables.logosCREDAddress}htriste_boy.png'
                        : '${GlobalVariables.logosCREDAddress}htriste_girl.png',
                    height: 25,
                    width: 25),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: Text(
                  '${TranslateService.translate('anemiaCheckPage.underMessageOne')} $name'
                  ' ${TranslateService.translate('anemiaCheckPage.underMessageTwo')}',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        );
      } else {
        return Container(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                height: 150,
                width: 150,
                child: Image.asset(
                    gender == 1
                        ? '${GlobalVariables.logosCREDAddress}hfeliz_boy.png'
                        : '${GlobalVariables.logosCREDAddress}hfeliz_girl.png',
                    height: 25,
                    width: 25),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: Text(
                  '${TranslateService.translate('anemiaCheckPage.goodMessage')} $name !',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        );
      }
    }
  }

  // This method show all the record
  Widget showRecord() {
    if (showHistory) {
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
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
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
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  constraints: BoxConstraints.loose(
                                      const Size.fromWidth(20)),
                                  onPressed: () => showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      content: Container(
                                        child: Text(TranslateService.translate(
                                            'anemiaCheckPage.dialogBody')),
                                      ),
                                      actions: [
                                        ElevatedButton(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                        Color>(
                                                    AppColors.colorCREDBoy),
                                            foregroundColor:
                                                MaterialStateProperty.all<
                                                        Color>(
                                                    AppColors.font_primary),
                                          ),
                                          child: Text(
                                              TranslateService.translate(
                                                  'anemiaCheckPage.cancel')),
                                          onPressed: () =>
                                              Navigator.pop(context),
                                        ),
                                        ElevatedButton(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                        Color>(
                                                    AppColors.colorCREDBoy),
                                            foregroundColor:
                                                MaterialStateProperty.all<
                                                        Color>(
                                                    AppColors.font_primary),
                                          ),
                                          child: Text(
                                              TranslateService.translate(
                                                  'anemiaCheckPage.accept')),
                                          onPressed: () async {
                                            bool answer;
                                            answer = await deleteRegister(
                                                text['id'], text['idLocal']);

                                            if (answer == true) {
                                              final snackBar = SnackBar(
                                                content: Text(
                                                    TranslateService.translate(
                                                        'anemiaCheckPage.confirmDelete')),
                                              );
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(snackBar);
                                              Navigator.pop(context);
                                            } else {
                                              final snackBar = SnackBar(
                                                content: Text(
                                                    TranslateService.translate(
                                                        'anemiaCheckPage.errorDelete')),
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
                          Table(
                            defaultVerticalAlignment:
                                TableCellVerticalAlignment.middle,
                            children: [
                              TableRow(
                                children: [
                                  Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 15),
                                    child: Text(
                                      '${TranslateService.translate('anemiaCheckPage.date')}: ',
                                      textAlign: TextAlign.start,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 15),
                                    child: Text(
                                      text['date'],
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 16),
                                    ),
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 15),
                                    child: Text(
                                      '${TranslateService.translate('anemiaCheckPage.age')}: ',
                                      textAlign: TextAlign.start,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 15),
                                    child: Text(
                                      '${text['age']} ${TranslateService.translate('anemiaCheckPage.month')}',
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 16),
                                    ),
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 15),
                                    child: Text(
                                      '${TranslateService.translate('anemiaCheckPage.result')}: ',
                                      textAlign: TextAlign.start,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 15),
                                    child: Text(
                                      '${text['result']} g/Dl',
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 16),
                                    ),
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  Container(
                                    child: Text(
                                      '${TranslateService.translate('anemiaCheckPage.diagnosis')}: ',
                                      textAlign: TextAlign.start,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  obtenerDiagnostico(text['result'].toDouble()),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ));
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

// void dispose() {
//     TapGestureRecognizer.dispose();
//     super.dispose();
  // }

  actualizar() {
    setState(() {
      loadAnemiaCheck();
    });
  }

  @override
  initState() {
    super.initState();
    loadAnemiaCheck();
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
          ],
        ),
        backgroundColor: AppColors.colorCREDBoy,
        elevation: 0,
      ),
      body: SingleChildScrollView(
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
                          gender == 1
                              ? '${GlobalVariables.logosAddress}hemoglobina_logo_boy.png'
                              : '${GlobalVariables.logosAddress}hemoglobina_logo_girl.png',
                          height: 25,
                          width: 25),
                    ),
                    Flexible(
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                        child: Text(
                          TranslateService.translate('anemiaCheckPage.title'),
                          style: const TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.visible,
                        ),
                      ),
                    )
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
                                children: [
                                  // Exam date row
                                  TableRow(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.fromLTRB(
                                            0, 0, 0, 15),
                                        child: Text(
                                          '${TranslateService.translate('anemiaCheckPage.date')}: ',
                                          textAlign: TextAlign.start,
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.fromLTRB(
                                            0, 0, 0, 15),
                                        child: Text(
                                          data[0]['date'].toString(),
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 16),
                                        ),
                                      ),
                                    ],
                                  ),
                                  // Age row
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
                              Container(
                                child: Column(
                                  children: [
                                    Container(
                                      child: Text(
                                        TranslateService.translate(
                                            'anemiaCheckPage.result'),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                    ),
                                    createDiagnosticGauge(
                                        data[0]['result'].toDouble(), context),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        presentaGrafico(data[0]['result'].toDouble()),
                        Divider(
                            color: AppColors.colorCREDBoy,
                            thickness: 5,
                            height: 30),
                        Container(
                          margin: const EdgeInsets.fromLTRB(0, 20, 0, 15),
                          child: InkWell(
                            onTap: () {
                              if (showHistory) {
                                setState(() {
                                  showHistory = false;
                                });
                              } else {
                                setState(() {
                                  showHistory = true;
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
                                Icon(showHistory
                                    ? Icons.arrow_drop_up
                                    : Icons.arrow_drop_down)
                              ],
                            ),
                          ),
                        ),
                        showRecord(),
                        const SizedBox(
                          height: 50,
                        ),
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
                                  'anemiaCheckPage.empty'))),
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
                              // style: ElevatedButton.styleFrom(
                              //     backgroundColor: AppColors.colorAddButtons),
                              child: Text(
                                TranslateService.translate(
                                    'anemiaCheckPage.addCheck'),
                                style: const TextStyle(fontSize: 18),
                                softWrap: true,
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddAnemiaCheckPage(
                                          idKid: idKid, kidName: name)),
                                ).then((value) => actualizar());
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
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
                        builder: (context) =>
                            AddAnemiaCheckPage(idKid: idKid, kidName: name)),
                  ).then((value) => actualizar());
                },
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
