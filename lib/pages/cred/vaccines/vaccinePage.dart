import 'package:flutter/material.dart';
import 'package:perusano/components/bottomNavigation.dart';
import 'package:perusano/services/fileManagement/cred/allVaccinesFM.dart';
import '../../../services/apis/cred/credRegisterCenter.dart';
import '../../../services/fileManagement/cred/vaccineFM.dart';
import '../../../services/translateService.dart';
import '../../../util/globalVariables.dart';
import '../../../util/internVariables.dart';
import '../../../util/myColors.dart';

class VaccinePage extends StatefulWidget {
  int idKid;
  String name;
  VaccinePage({super.key, required this.idKid, required this.name});

  @override
  State<StatefulWidget> createState() => _VaccinePage(idKid: idKid, name: name);
}

class _VaccinePage extends State<VaccinePage> {
  int idKid;
  String name;
  List data = [];
  List dataObt = [];
  List dataVaccinesObt = [];
  List allVaccines = [];

  final VaccineFM storage = VaccineFM();
  final AllVaccinesFM vaccineDataStorage = AllVaccinesFM();

  bool hayCaducadas = false;
  bool hayPendientes = false;
  List vacunasPendientesTotales = [];
  String siguienteVacuna = '';

  List showRecibidas = [];

  DateTime selectedDate = DateTime.now();

  _VaccinePage({required this.idKid, required this.name});

  // Loads all vaccine register from local storage
  loadVaccines() async {
    //bool isConnected = await GlobalVariables.isConnected();

    await loadAllVaccines();

    dataObt = await storage.readFile();
    List dataFiltrada = [];
    for (var value in dataObt) {
      if (value['idKid'] == idKid) {
        dataFiltrada.add(value);
      }
    }

    setState(() {
      data = dataFiltrada;
    });
    for (var x = 0; x < 3; x++) {
      showRecibidas.add(false);
    }

    await veririficarfechas();
  }

  // Loads vaccines extra data
  loadAllVaccines() async {
    dataVaccinesObt = await vaccineDataStorage.readFile();

    setState(() {
      allVaccines = dataVaccinesObt;
      for (var x = 0; x < allVaccines.length; x++) {
        showRecibidas.add(false);
      }
    });
  }

  // Get the description of the vaccine
  String obtenerDescripcionVacuna(int id) {
    for (var value in allVaccines) {
      if (value['id'] == id) {
        return value['description'];
      }
    }
    return 'No se pudo encontrar la descripción';
  }

  // Shows the date selector
  Future<bool> _selectDate(
      BuildContext context, int idDose, int idVaccine, int idLocal) async {
    final DateTime? picked = await showDatePicker(
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: AppColors.colorCREDBoy, // header background color
                onPrimary: Colors.black, // header text color
                onSurface: Colors.black, // body text color
              ),
              textButtonTheme: TextButtonThemeData(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(AppColors.colorCREDBoy),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(AppColors.font_primary),
                ),
              ),
              textTheme: const TextTheme(
                labelSmall:
                    TextStyle(fontSize: 16, overflow: TextOverflow.visible),
              ),
            ),
            child: child!,
          );
        },
        helpText: TranslateService.translate('vaccinePage.datePickerTitle'),
        confirmText: TranslateService.translate('vaccinePage.accept'),
        cancelText: TranslateService.translate('vaccinePage.cancel'),
        context: context,
        locale: Locale(
            GlobalVariables.language.toLowerCase(), GlobalVariables.language),
        initialDate: selectedDate,
        firstDate: DateTime.parse(InternVariables.kid['birthday']),
        lastDate: DateTime(2101));
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
      return asignarFecha(
          idDose, selectedDate.toString(), 1, idVaccine, idLocal);
    }
    return false;
  }

  // Change the vaccine state to applied with the date
  Future<bool> asignarFecha(
      int idDose, String date, int state, int idVaccine, int idLocal) async {
    Map answerOnline = {};
    Map answerOffline = {};
    bool isConnected = await GlobalVariables.isConnected();

    answerOffline =
        await storage.updateVaccineState(idKid, idVaccine, idLocal, date);

    Map temp = await storage.changeWasChangedToTrue(answerOffline['idLocal']);

    if (isConnected) {
      try {
        answerOnline =
            await CredRegisterCenter().updateVaccinedDose(idDose, date, state);

        await storage.changeWasChangedToFalse(answerOffline['idLocal']);
      } catch (e) {}
    }

    if ((answerOffline['idLocal'] != null && answerOffline['idLocal'] >= 0)) {
      return true;
    }
    return false;
  }

  // Change the vaccine state to not applied also deleting the applied date
  Future<bool> eliminarFecha(
      int idDose, int state, int idVaccine, int idLocal) async {
    Map answerOnline = {};
    Map answerOffline = {};
    bool isConnected = await GlobalVariables.isConnected();

    answerOffline =
        await storage.reverseVaccineState(idKid, idVaccine, idLocal);

    Map temp = await storage.changeWasChangedToTrue(answerOffline['idLocal']);

    if (isConnected) {
      try {
        answerOnline = await CredRegisterCenter()
            .deleteVaccinedAppliedDateDose(idDose, state);

        await storage.changeWasChangedToFalse(answerOffline['idLocal']);
      } catch (e) {}
    }

    if ((answerOffline['idLocal'] != null && answerOffline['idLocal'] >= 0)) {
      return true;
    }
    return false;
  }

  // Calculates nearest and expired vaccines
  veririficarfechas() async {
    setState(() {
      hayCaducadas = false;
    });
    for (var value in data) {
      List doses = value['dosis'];
      for (var value in doses) {
        if (value['applied_date'].toString() == 'null') {
          int comparation = DateTime.now()
              .compareTo(DateTime.parse(value['suggest_date'].toString()));
          if (comparation <= 0) {
            vacunasPendientesTotales.add(value);
          } else {
            setState(() {
              hayCaducadas = true;
            });
          }
        }
      }
    }

    if (vacunasPendientesTotales.length > 0) {
      String minimo = vacunasPendientesTotales[0]['suggest_date'];
      siguienteVacuna = vacunasPendientesTotales[0]['suggest_date_format'];
      for (var value in vacunasPendientesTotales) {
        if (DateTime.parse(value['suggest_date'].toString())
                .compareTo(DateTime.parse(minimo)) <
            0) {
          siguienteVacuna = value['suggest_date_format'];
          minimo = value['suggest_date'];
        }
      }
      //vacunasPendientesTotales.sort((a,b) => a.compareTo(b));

      setState(() {
        hayPendientes = true;
      });
    } else {
      setState(() {
        hayPendientes = false;
      });
    }
  }

  // Shows a widget about nearest vaccine
  Widget mostrarCercano() {
    if (hayPendientes) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Color.fromRGBO(255, 255, 0, 0.2),
        ),
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 5, 0),
              child: const Icon(Icons.info),
            ),
            Expanded(
              child: Text(
                '${TranslateService.translate('vaccinePage.waning1')} '
                '$name '
                '${TranslateService.translate('vaccinePage.waning2')} '
                '${siguienteVacuna}',
                style: const TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  // Show a widget about expired vaccines
  Widget mostrarCaducados() {
    if (hayCaducadas) {
      return Container(
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
                '$name ${TranslateService.translate('vaccinePage.danger')}',
                style: const TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  actualizar() {
    setState(() {
      loadVaccines();
    });
  }

  @override
  initState() {
    super.initState();
    loadVaccines();
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
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                actualizar();
              },
              color: Colors.black,
            )
          ],
        ),
        backgroundColor: AppColors.colorCREDBoy,
        elevation: 0,
      ),

      //endDrawer: LateralMenuCenter.fromInsideCRED(2, idKid, name),

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
                        '${GlobalVariables.logosAddress}vacuna_logo.png',
                        height: 25,
                        width: 25),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: Text(
                      TranslateService.translate('vaccinePage.title'),
                      style: const TextStyle(
                          fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      color: AppColors.colorCREDBoy,
                    ),
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: Text(
                      '${TranslateService.translate('vaccinePage.initialMsg1')} '
                      '$name '
                      '${TranslateService.translate('vaccinePage.initialMsg2')}',
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                    height: 200,
                    width: 200,
                    child: Image.asset(
                        '${GlobalVariables.logosCREDAddress}hbebe_vacunas.png',
                        height: 25,
                        width: 25),
                  ),
                ],
              ),
            ),
            mostrarCercano(),
            mostrarCaducados(),
            Container(
              child: Builder(
                builder: (context) {
                  if (data.isNotEmpty) {
                    return Container(
                      child: Column(
                          children: data.map((text) {
                        List doses = text['dosis'];
                        List recibidas = [];
                        List pendientes = [];
                        List caducadas = [];

                        for (var value in doses) {
                          if (value['applied_date'].toString() != 'null') {
                            recibidas.add(value);
                          } else {
                            int comparation = DateTime.now().compareTo(
                                DateTime.parse(
                                    value['suggest_date'].toString()));
                            if (comparation <= 0) {
                              pendientes.add(value);
                              vacunasPendientesTotales.add(value);
                            } else {
                              caducadas.add(value);
                            }
                          }
                        }

                        return Container(
                          margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                            color: AppColors.colorCREDBoy,
                            boxShadow: [
                              new BoxShadow(
                                color: Colors.grey,
                                offset: new Offset(0.0, 3.0),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(20),
                                                    topRight:
                                                        Radius.circular(20)),
                                            color: Colors.yellow,
                                            boxShadow: [
                                              new BoxShadow(
                                                color: Colors.grey,
                                                offset: new Offset(0.0, 1.0),
                                                blurRadius: 1,
                                              ),
                                            ],
                                          ),
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 20, horizontal: 10),
                                            alignment: Alignment.center,
                                            child: Text(
                                              text['name'],
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 24),
                                            ),
                                          )),
                                      onTap: () async {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              String descripcion =
                                                  obtenerDescripcionVacuna(
                                                      text['id']);

                                              return AlertDialog(
                                                title: /*Expanded(
                                                            child: Container(
                                                              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                                              decoration: BoxDecoration(
                                                                color: Colors.yellow,
                                                              ),
                                                              child: Text('${text['name']}'),
                                                            ),
                                                          ),*/
                                                    Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .fromLTRB(
                                                                20, 10, 20, 10),
                                                        decoration:
                                                            const BoxDecoration(
                                                          color: Colors.yellow,
                                                        ),
                                                        child: Text(
                                                          text['name'],
                                                          textAlign:
                                                              TextAlign.center,
                                                        )),
                                                content: /*Expanded(
                                                            child: Text(
                                                              '${descripcion}',
                                                              style: TextStyle(fontSize: 16,),
                                                              textAlign: TextAlign.center,
                                                            ),

                                                          )*/
                                                    Container(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          20, 10, 20, 10),
                                                  decoration:
                                                      const BoxDecoration(),
                                                  child: Text(
                                                    descripcion,
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    child: Text(TranslateService
                                                        .translate(
                                                            'vaccinePage.return')),
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                  ),
                                                ],
                                              );
                                            });
                                      },
                                    ),
                                  )
                                ],
                              ),
                              Container(
                                  //color: Colors.red,
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                  child: Column(
                                    children: [
                                      (caducadas.isNotEmpty)
                                          ? Container(
                                              child: Column(
                                                children: [
                                                  Text(
                                                      TranslateService.translate(
                                                          'vaccinePage.late'),
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16)),
                                                  Column(
                                                    children:
                                                        caducadas.map((text2) {
                                                      return Container(
                                                        child: Table(
                                                          defaultVerticalAlignment:
                                                              TableCellVerticalAlignment
                                                                  .middle,
                                                          //border: TableBorder.all(),
                                                          columnWidths: {
                                                            0: const FlexColumnWidth(
                                                                3),
                                                            1: const FlexColumnWidth(
                                                                3),
                                                            2: const FlexColumnWidth(
                                                                1),
                                                            3: const FlexColumnWidth(
                                                                1),
                                                          },
                                                          children: [
                                                            TableRow(children: [
                                                              Container(
                                                                margin:
                                                                    const EdgeInsets
                                                                        .fromLTRB(
                                                                        0,
                                                                        0,
                                                                        0,
                                                                        15),
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Column(
                                                                  children: [
                                                                    Text(
                                                                      '${TranslateService.translate('vaccinePage.dose_number')} ${text2['dosis_number'].toString()}',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              20),
                                                                    ),
                                                                    Text(
                                                                      '(${text2['month'].toString()} ${TranslateService.translate('vaccinePage.month')})',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              14),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                              Container(
                                                                margin:
                                                                    const EdgeInsets
                                                                        .fromLTRB(
                                                                        0,
                                                                        0,
                                                                        0,
                                                                        15),
                                                                padding:
                                                                    const EdgeInsets
                                                                        .fromLTRB(
                                                                        2,
                                                                        0,
                                                                        2,
                                                                        4),
                                                                child: (text2['applied_date']
                                                                            .toString() !=
                                                                        'null')
                                                                    ? Text(
                                                                        /*'${TranslateService.translate('vaccinePage.applied_date')}'*/ text2['applied_date']
                                                                            .toString(),
                                                                        textAlign:
                                                                            TextAlign
                                                                                .start,
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                16))
                                                                    : Text(
                                                                        /*'${TranslateService.translate('vaccinePage.suggest_date')}'*/ text2['suggest_date_format']
                                                                            .toString(),
                                                                        textAlign:
                                                                            TextAlign.start,
                                                                        style: const TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                            fontSize: 16),
                                                                      ),

                                                                /*Row(
                                                                children: [
                                                                  Text('${TranslateService.translate('vaccinePage.suggest_date')} ${text2['suggest_date'].toString()}', textAlign: TextAlign.start, style: TextStyle(color: Colors.red, fontSize: 16),),
                                                                  /*IconButton(
                                                                      onPressed: () => _selectDate(context),
                                                                      icon: Icon(Icons.calendar_month)
                                                                  )*/
                                                                ],
                                                              )*/
                                                              ),
                                                              Container(
                                                                  margin:
                                                                      const EdgeInsets.fromLTRB(
                                                                          0,
                                                                          0,
                                                                          0,
                                                                          15),
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .fromLTRB(
                                                                          2,
                                                                          0,
                                                                          2,
                                                                          4),
                                                                  child: (text2['applied_date']
                                                                              .toString() !=
                                                                          'null')
                                                                      ? Container()
                                                                      : IconButton(
                                                                          onPressed:
                                                                              () async {
                                                                            bool answer = await _selectDate(
                                                                                context,
                                                                                text2['id'],
                                                                                text['id'],
                                                                                text2['idLocal']);

                                                                            if (answer ==
                                                                                true) {
                                                                              final snackBar = SnackBar(
                                                                                content: Text(TranslateService.translate('vaccinePage.vaccineApplied')),
                                                                              );
                                                                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                                              //Navigator.pop(context);
                                                                              actualizar();
                                                                            } else {
                                                                              final snackBar = SnackBar(
                                                                                content: Text(TranslateService.translate('vaccinePage.vaccineNotApplied')),
                                                                              );
                                                                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                                            }
                                                                          },
                                                                          icon:
                                                                              const Icon(Icons.calendar_month))),
                                                              Container(
                                                                margin:
                                                                    const EdgeInsets
                                                                        .fromLTRB(
                                                                        0,
                                                                        0,
                                                                        0,
                                                                        15),
                                                                padding:
                                                                    const EdgeInsets
                                                                        .fromLTRB(
                                                                        2,
                                                                        0,
                                                                        2,
                                                                        4),
                                                                child: const Icon(
                                                                    Icons
                                                                        .warning,
                                                                    color: Colors
                                                                        .red),
                                                              )
                                                            ])
                                                          ],
                                                        ),
                                                      );
                                                    }).toList(),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : Container(),
                                    ],
                                  )),
                              Container(
                                  //color: Colors.green,
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                  child: Column(
                                    children: [
                                      (pendientes.isNotEmpty)
                                          ? Container(
                                              child: Column(
                                                children: [
                                                  Text(
                                                      TranslateService.translate(
                                                          'vaccinePage.next'),
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16)),
                                                  Column(
                                                    children:
                                                        pendientes.map((text2) {
                                                      return Container(
                                                        child: Table(
                                                          defaultVerticalAlignment:
                                                              TableCellVerticalAlignment
                                                                  .middle,
                                                          //border: TableBorder.all(),
                                                          columnWidths: {
                                                            0: const FlexColumnWidth(
                                                                3),
                                                            1: const FlexColumnWidth(
                                                                3),
                                                            2: const FlexColumnWidth(
                                                                1),
                                                          },
                                                          children: [
                                                            TableRow(children: [
                                                              Container(
                                                                margin:
                                                                    const EdgeInsets
                                                                        .fromLTRB(
                                                                        0,
                                                                        0,
                                                                        0,
                                                                        15),
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Column(
                                                                  children: [
                                                                    Text(
                                                                      '${TranslateService.translate('vaccinePage.dose_number')} ${text2['dosis_number'].toString()}',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              20),
                                                                    ),
                                                                    Text(
                                                                      '(${text2['month'].toString()} ${TranslateService.translate('vaccinePage.month')})',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              14),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Container(
                                                                margin:
                                                                    const EdgeInsets
                                                                        .fromLTRB(
                                                                        0,
                                                                        0,
                                                                        0,
                                                                        15),
                                                                padding:
                                                                    const EdgeInsets
                                                                        .fromLTRB(
                                                                        2,
                                                                        0,
                                                                        2,
                                                                        4),
                                                                child: (text2['applied_date']
                                                                            .toString() !=
                                                                        'null')
                                                                    ? Text(
                                                                        /*'${TranslateService.translate('vaccinePage.applied_date')}'*/ text2['applied_date']
                                                                            .toString(),
                                                                        textAlign:
                                                                            TextAlign
                                                                                .start,
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                16))
                                                                    : Text(
                                                                        /*'${TranslateService.translate('vaccinePage.suggest_date')}'*/ text2['suggest_date_format']
                                                                            .toString(),
                                                                        textAlign:
                                                                            TextAlign.start,
                                                                        style: const TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                            fontSize: 16),
                                                                      ),

                                                                /*Row(
                                                                children: [
                                                                  Text('${TranslateService.translate('vaccinePage.suggest_date')} ${text2['suggest_date'].toString()}', textAlign: TextAlign.start, style: TextStyle(color: Colors.red, fontSize: 16),),
                                                                  /*IconButton(
                                                                      onPressed: () => _selectDate(context),
                                                                      icon: Icon(Icons.calendar_month)
                                                                  )*/
                                                                ],
                                                              )*/
                                                              ),
                                                              Container(
                                                                  margin:
                                                                      const EdgeInsets.fromLTRB(
                                                                          0,
                                                                          0,
                                                                          0,
                                                                          15),
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .fromLTRB(
                                                                          2,
                                                                          0,
                                                                          2,
                                                                          4),
                                                                  child: (text2['applied_date']
                                                                              .toString() !=
                                                                          'null')
                                                                      ? Container()
                                                                      : IconButton(
                                                                          onPressed:
                                                                              () async {
                                                                            bool answer = await _selectDate(
                                                                                context,
                                                                                text2['id'],
                                                                                text['id'],
                                                                                text2['idLocal']);

                                                                            if (answer ==
                                                                                true) {
                                                                              final snackBar = SnackBar(
                                                                                content: Text(TranslateService.translate('vaccinePage.vaccineApplied')),
                                                                              );
                                                                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                                              //Navigator.pop(context);
                                                                              actualizar();
                                                                            } else {
                                                                              final snackBar = SnackBar(
                                                                                content: Text(TranslateService.translate('vaccinePage.vaccineNotApplied')),
                                                                              );
                                                                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                                            }
                                                                          },
                                                                          icon:
                                                                              const Icon(Icons.calendar_month))),
                                                            ])
                                                          ],
                                                        ),
                                                      );
                                                    }).toList(),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : Container(),
                                    ],
                                  )),
                              Builder(builder: (context) {
                                if (recibidas.isNotEmpty &&
                                    showRecibidas.isNotEmpty) {
                                  return Container(
                                    //color: Colors.blue,
                                    padding: const EdgeInsets.fromLTRB(
                                        10, 0, 10, 10),
                                    child: Column(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            if (showRecibidas[text['id'] - 1]) {
                                              setState(() {
                                                showRecibidas[text['id'] - 1] =
                                                    false;
                                              });
                                            } else {
                                              setState(() {
                                                showRecibidas[text['id'] - 1] =
                                                    true;
                                              });
                                            }
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.fromLTRB(
                                                0, 0, 0, 10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                    TranslateService.translate(
                                                        'vaccinePage.receive'),
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16)),
                                                Icon(showRecibidas[
                                                        text['id'] - 1]
                                                    ? Icons.arrow_drop_up
                                                    : Icons.arrow_drop_down)
                                              ],
                                            ),
                                          ),
                                        ),
                                        Column(
                                          children: recibidas.map((text2) {
                                            if (showRecibidas[text['id'] - 1] !=
                                                false) {
                                              return Container(
                                                child: Table(
                                                  defaultVerticalAlignment:
                                                      TableCellVerticalAlignment
                                                          .middle,
                                                  //border: TableBorder.all(),
                                                  columnWidths: {
                                                    0: const FlexColumnWidth(3),
                                                    1: const FlexColumnWidth(3),
                                                    2: const FlexColumnWidth(1),
                                                    3: const FlexColumnWidth(1),
                                                  },
                                                  children: [
                                                    TableRow(children: [
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .fromLTRB(
                                                            0, 0, 0, 15),
                                                        alignment:
                                                            Alignment.center,
                                                        child: Column(
                                                          children: [
                                                            Text(
                                                              '${TranslateService.translate('vaccinePage.dose_number')} ${text2['dosis_number'].toString()}',
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          20),
                                                            ),
                                                            Text(
                                                              '(${text2['month'].toString()} ${TranslateService.translate('vaccinePage.month')})',
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          14),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .fromLTRB(
                                                            0, 0, 0, 15),
                                                        padding:
                                                            const EdgeInsets
                                                                .fromLTRB(
                                                                2, 0, 2, 0),
                                                        child: (text2['applied_date']
                                                                    .toString() !=
                                                                'null')
                                                            ? Text(
                                                                /*'${TranslateService.translate('vaccinePage.applied_date')}'*/ text2[
                                                                        'applied_date']
                                                                    .toString(),
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            16))
                                                            : Text(
                                                                /*'${TranslateService.translate('vaccinePage.suggest_date')}'*/ text2[
                                                                        'suggest_date_format']
                                                                    .toString(),
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        16),
                                                              ),

                                                        /*Row(
                                                                children: [
                                                                  Text('${TranslateService.translate('vaccinePage.suggest_date')} ${text2['suggest_date'].toString()}', textAlign: TextAlign.start, style: TextStyle(color: Colors.red, fontSize: 16),),
                                                                  /*IconButton(
                                                                      onPressed: () => _selectDate(context),
                                                                      icon: Icon(Icons.calendar_month)
                                                                  )*/
                                                                ],
                                                              )*/
                                                      ),
                                                      Container(
                                                          margin:
                                                              const EdgeInsets.fromLTRB(
                                                                  0, 0, 0, 15),
                                                          padding:
                                                              const EdgeInsets
                                                                  .fromLTRB(
                                                                  2, 0, 2, 4),
                                                          child: const Icon(
                                                            Icons
                                                                .check_circle_rounded,
                                                            color: Colors
                                                                .greenAccent,
                                                          )),
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .fromLTRB(
                                                            0, 0, 0, 15),
                                                        padding:
                                                            const EdgeInsets
                                                                .fromLTRB(
                                                                2, 0, 2, 4),
                                                        //alignment: Alignment.topRight,
                                                        //color: Colors.redAccent,
                                                        //height: 1,
                                                        child: IconButton(
                                                          padding:
                                                              const EdgeInsets
                                                                  .fromLTRB(
                                                                  0, 0, 0, 0),
                                                          //constraints: BoxConstraints.loose(Size.fromWidth(20)),
                                                          onPressed: () =>
                                                              showDialog(
                                                            context: context,
                                                            builder:
                                                                (context) =>
                                                                    AlertDialog(
                                                              content:
                                                                  Container(
                                                                child: Text(
                                                                    TranslateService
                                                                        .translate(
                                                                            'vaccinePage.dialogBody')),
                                                              ),
                                                              actions: [
                                                                ElevatedButton(
                                                                  style:
                                                                      ButtonStyle(
                                                                    backgroundColor: MaterialStateProperty.all<
                                                                            Color>(
                                                                        AppColors
                                                                            .colorCREDBoy),
                                                                    foregroundColor: MaterialStateProperty.all<
                                                                            Color>(
                                                                        AppColors
                                                                            .font_primary),
                                                                  ),
                                                                  child: Text(TranslateService
                                                                      .translate(
                                                                          'vaccinePage.cancel')),
                                                                  onPressed: () =>
                                                                      Navigator.pop(
                                                                          context),
                                                                ),
                                                                ElevatedButton(
                                                                  style:
                                                                      ButtonStyle(
                                                                    backgroundColor: MaterialStateProperty.all<
                                                                            Color>(
                                                                        AppColors
                                                                            .colorCREDBoy),
                                                                    foregroundColor: MaterialStateProperty.all<
                                                                            Color>(
                                                                        AppColors
                                                                            .font_primary),
                                                                  ),
                                                                  child: Text(TranslateService
                                                                      .translate(
                                                                          'vaccinePage.accept')),
                                                                  onPressed:
                                                                      () async {
                                                                    bool answer = await eliminarFecha(
                                                                        text2[
                                                                            'id'],
                                                                        2,
                                                                        text[
                                                                            'id'],
                                                                        text2[
                                                                            'idLocal']);

                                                                    if (answer ==
                                                                        true) {
                                                                      final snackBar =
                                                                          SnackBar(
                                                                        content:
                                                                            Text(TranslateService.translate('vaccinePage.confirmChangeState')),
                                                                      );
                                                                      ScaffoldMessenger.of(
                                                                              context)
                                                                          .showSnackBar(
                                                                              snackBar);
                                                                      Navigator.pop(
                                                                          context);
                                                                      actualizar();
                                                                    } else {
                                                                      final snackBar =
                                                                          SnackBar(
                                                                        content:
                                                                            Text(TranslateService.translate('vaccinePage.errorChangeState')),
                                                                      );
                                                                      ScaffoldMessenger.of(
                                                                              context)
                                                                          .showSnackBar(
                                                                              snackBar);
                                                                    }
                                                                  },
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          icon: const Icon(
                                                              Icons.undo),
                                                        ),
                                                      ),
                                                    ])
                                                  ],
                                                ),
                                              );
                                            } else {
                                              return Container();
                                            }
                                          }).toList(),
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  return Container();
                                }
                              })
                            ],
                          ),
                        );
                      }).toList()),
                    );
                  } else {
                    return Container(
                      child: const Center(child: CircularProgressIndicator()),
                      margin: const EdgeInsets.all(20),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      )),
      bottomNavigationBar: BottomNavigationPage(),
    );
  }
}
