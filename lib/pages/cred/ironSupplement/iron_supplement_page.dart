import 'package:flutter/material.dart';
import 'package:perusano/components/bottomNavigation.dart';

import '../../../services/apis/cred/credRegisterCenter.dart';
import '../../../services/fileManagement/cred/ironSupplementFM.dart';
import '../../../services/translateService.dart';
import '../../../util/globalVariables.dart';
import '../../../util/myColors.dart';
import 'add_iron_supplement_page.dart';

class IronSupplementPage extends StatefulWidget {
  int idKid;
  String name;
  IronSupplementPage({super.key, required this.idKid, required this.name});

  @override
  State<StatefulWidget> createState() =>
      _IronSupplementPage(idKid: idKid, name: name);
}

class _IronSupplementPage extends State<IronSupplementPage> {
  int idKid;
  String name;
  List data = [];
  List dataObt = [];

  final IronSupplementFM storage = IronSupplementFM();

  bool cargado = false;

  bool presentaHistorial = false;

  bool displayConfirmMessage = true;
  bool displayReminderMessage = false;
  bool displayCongratulationsMessage = false;

  _IronSupplementPage({required this.idKid, required this.name});

  // Loads all iron Supplement register from local storage
  loadIronSupplement() async {
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
        await CredRegisterCenter().deleteIronSupplement(idData);
        await storage.deleteRegister(idLocal);
      }
    }

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
                                          'ironSupplementPage.dialogBody')),
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
                                            'ironSupplementPage.cancel')),
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
                                            'ironSupplementPage.accept')),
                                        onPressed: () async {
                                          bool answer;
                                          answer = await deleteRegister(
                                              text['id'], text['idLocal']);

                                          if (answer == true) {
                                            final snackBar = SnackBar(
                                              content: Text(
                                                  TranslateService.translate(
                                                      'ironSupplementPage.confirmDelete')),
                                            );
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(snackBar);
                                            Navigator.pop(context);
                                          } else {
                                            final snackBar = SnackBar(
                                              content: Text(
                                                  TranslateService.translate(
                                                      'ironSupplementPage.errorDelete')),
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
                              margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                              height: 100,
                              width: 100,
                              child: Image.asset(
                                  '${GlobalVariables.logosAddress}suplemento_logo.png',
                                  height: 25,
                                  width: 25),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 2),
                                  child: Row(
                                    children: [
                                      Container(
                                        child: Text(
                                          '${text['dosage']['amount'].toString()} ',
                                          textAlign: TextAlign.start,
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ),
                                      Container(
                                        child: Text(
                                          '${TranslateService.translate(text['dosage']['unit']).toString()} por día',
                                          textAlign: TextAlign.start,
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 2),
                                  child: Text(
                                    TranslateService.translate(text['name'])
                                        .toString(),
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                ),
                                // Container(
                                //   margin: const EdgeInsets.fromLTRB(0, 0, 0, 2),
                                //   child: Text(
                                //     TranslateService.translate(text['type'])
                                //         .toString(),
                                //     textAlign: TextAlign.start,
                                //     style: const TextStyle(fontSize: 16),
                                //   ),
                                // ),
                                /*Container(
                                  child: Text('${text['dosage']['amount'].toString()} ${text['dosage']['unit'].toString()}',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(fontSize: 16, color: Colors.green),),
                                ),*/
                                Container(
                                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 2),
                                  child: Text(
                                    text['deliveryDate'].toString(),
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(fontSize: 16),
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

  Widget showReminder() {
    if (displayConfirmMessage) {
      return Container(
        padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: AppColors.colorCREDBoy,
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0.0, 3.0),
              blurRadius: 2,
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              TranslateService.translate(
                  'ironSupplementPage.supplementReminderTitle'),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      showCongratulationsMessage();
                      displayConfirmMessage = false;
                    });
                  },
                  child: Row(
                    children: [
                      Text(TranslateService.translate(
                          'ironSupplementPage.supplementReminderYes')),
                      const Icon(Icons.check),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      displayReminderMessage = true;
                    });
                  },
                  child: Row(
                    children: [
                      Text(TranslateService.translate(
                          'ironSupplementPage.supplementReminderNo')),
                      const Icon(Icons.close),
                    ],
                  ),
                ),
              ],
            ),
            showReminderMessage(),
          ],
        ),
      );
    }
    return Container();
  }

  Widget showReminderMessage() {
    if (displayReminderMessage) {
      return Container(
        margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Color.fromRGBO(255, 0, 0, 0.3),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.warning,
            ),
            Expanded(
              child: Text(
                '${TranslateService.translate('ironSupplementPage.motivationMessage1')} ${name[0].toUpperCase() + name.substring(1)} ${TranslateService.translate('ironSupplementPage.motivationMessage2')}',
              ),
            ),
          ],
        ),
      );
    }
    return Container();
  }

  // Widget showReminderOptions() {
  //   if (displayReminderMessage) {
  //     return Container(
  //       margin: const EdgeInsets.fromLTRB(50, 5, 50, 5),
  //       decoration: BoxDecoration(
  //         border: Border.all(),
  //         borderRadius: BorderRadius.circular(10),
  //         boxShadow: [
  //           BoxShadow(
  //             color: Colors.black.withOpacity(0.2),
  //           ),
  //         ],
  //       ),
  //       child: Column(
  //         children: [
  //           Text(
  //             TranslateService.translate('ironSupplementPage.reason'),
  //             style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
  //           ),
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //             children: [
  //               ElevatedButton(
  //                   onPressed: () {
  //                     supplementNotGiven('forgot');
  //                   },
  //                   child: Text(TranslateService.translate(
  //                       'ironSupplementPage.reasonForgot'))),
  //               ElevatedButton(
  //                   onPressed: () {
  //                     supplementNotGiven('supply');
  //                   },
  //                   child: Text(TranslateService.translate(
  //                       'ironSupplementPage.reasonNoSupply')))
  //             ],
  //           ),
  //           ElevatedButton(
  //               onPressed: () {
  //                 supplementNotGiven('other');
  //               },
  //               child: Text(TranslateService.translate(
  //                   'ironSupplementPage.reasonOther')))
  //         ],
  //       ),
  //     );
  //   }
  //   return Container();
  // }

  showCongratulationsMessage() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Container(
          padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
          child: Text(
              '¡Muy bien! 🥳 Continúa dando el suplemento de hierro a ${name[0].toUpperCase() + name.substring(1)} para que crezca sana y fuerte'),
        ),
      ),
    );
  }

  actualizar() {
    setState(() {
      loadIronSupplement();
    });
  }

  @override
  initState() {
    super.initState();
    loadIronSupplement();
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

      //endDrawer: LateralMenuCenter.fromInsideCRED(5, idKid, name),

      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Column(
            children: [
              Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 25),
                  child: FittedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                          height: 50,
                          width: 50,
                          child: Image.asset(
                              '${GlobalVariables.logosAddress}suplemento_logo.png',
                              height: 25,
                              width: 25),
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: Text(
                            TranslateService.translate(
                                'ironSupplementPage.title'),
                            style: const TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  )),
              Container(
                child: Builder(
                  builder: (context) {
                    if (data.isNotEmpty && cargado) {
                      return Container(
                        child: Column(
                          children: [
                            Container(
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
                              child: Column(
                                children: [
                                  Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                    child: Text(
                                      TranslateService.translate(
                                          data[0]['name']),
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.fromLTRB(
                                            0, 0, 10, 0),
                                        height: 150,
                                        width: 150,
                                        child: Image.asset(
                                            data[0]['dosage']['unit'] ==
                                                    'addIronSupplement.sulfate'
                                                ? '${GlobalVariables.logosCREDAddress}hierro-image.png'
                                                : data[0]['dosage']['unit'] ==
                                                        'addIronSupplement.micronutrients'
                                                    ? '${GlobalVariables.logosCREDAddress}zyro-image.png'
                                                    : '${GlobalVariables.logosCREDAddress}hierro-cucharadas.png',
                                            height: 25,
                                            width: 25),
                                      ),
                                      Column(
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.fromLTRB(
                                                0, 0, 0, 10),
                                            child: Text(
                                              TranslateService.translate(
                                                  'ironSupplementPage.dosage'),
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.fromLTRB(
                                                0, 0, 0, 10),
                                            child: Text(
                                              '${data[0]['dosage']['amount']} ${TranslateService.translate(data[0]['dosage']['unit'])}',
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.fromLTRB(
                                                0, 0, 0, 10),
                                            child: Text(
                                              TranslateService.translate(
                                                  'ironSupplementPage.frecuency'),
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.fromLTRB(0, 25, 0, 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                    child: Text(
                                      '${TranslateService.translate('ironSupplementPage.date')}: ',
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                    child: Text(
                                      '${data[0]['deliveryDate']}',
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
                            Divider(
                                color: AppColors.colorCREDBoy,
                                thickness: 5,
                                height: 30),
                            showReminder(),
                            const SizedBox(
                              height: 50,
                            )
                          ],
                        ),
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
                              child: Text(
                                TranslateService.translate(
                                    'anemiaCheckPage.empty'),
                              ),
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
                                      'ironSupplementPage.addPrescription'),
                                  style: const TextStyle(fontSize: 18),
                                  softWrap: true,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AddIronSupplementPage(
                                              idKid: idKid,
                                              kidName: name,
                                            )),
                                  ).then((value) => actualizar());
                                },
                              ),
                            )
                          ],
                        ),
                      );
                    }
                  },
                ),
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
                  TranslateService.translate(
                      'ironSupplementPage.addPrescription'),
                  style: const TextStyle(fontSize: 18),
                  softWrap: true,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddIronSupplementPage(
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
