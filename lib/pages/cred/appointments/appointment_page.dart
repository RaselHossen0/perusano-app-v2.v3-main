import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:perusano/components/bottomNavigation.dart';
import 'package:perusano/util/class/cred/appointments/appointmentClass.dart';
import 'package:perusano/util/class/join/date_picker/date_picker.dart';
import 'package:perusano/util/class/join/date_picker/i18n/date_picker_i18n.dart';

import '../../../services/apis/cred/credRegisterCenter.dart';
import '../../../services/fileManagement/cred/appointmentFM.dart';
import '../../../services/translateService.dart';
import '../../../util/globalVariables.dart';
import '../../../util/internVariables.dart';
import '../../../util/myColors.dart';
import 'add_appointment_page.dart';

class AppointmentPage extends StatefulWidget {
  int idKid;
  String name;
  AppointmentPage({super.key, required this.idKid, required this.name});

  @override
  State<StatefulWidget> createState() =>
      _AppointmentPage(idKid: idKid, name: name);
}

class _AppointmentPage extends State<AppointmentPage> {
  int idKid;
  String name;
  List pendientes = [];
  List completadas = [];
  List dataObt = [];
  List data = [];

  bool cargadoPendientes = false;
  bool cargadoCompletas = false;

  bool statusChanged = false;

  DateTime selectedDate = DateTime.now();
  late String formattedDate = DateFormat().add_yMMMd().format(selectedDate);

  bool displayRescheduleOptions = false;
  bool displayCongratulationsMessage = false;

  AppointmentFM storage = AppointmentFM();

  _AppointmentPage({required this.idKid, required this.name});

  // Loads all appointments register from local storage
  loadAppointment() async {
    List dataFiltradaPendiente = [];
    List dataFiltradaCompletada = [];
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
        var adate = DateTime.parse(a['date']); //before -> var adate = a.expiry
        var bdate = DateTime.parse(b['date']); //before -> var bdate = b.expiry
        return bdate.compareTo(
            adate); //to get the order other way just switch `adate & bdate`
      });
      dataObt = data;
    });

    for (var value in dataObt) {
      if (value['state_id'] == 2) {
        dataFiltradaPendiente.add(value);
      } else if (value['state_id'] == 1) {
        dataFiltradaCompletada.add(value);
      }
    }
    setState(() {
      pendientes = dataFiltradaPendiente;
      completadas = dataFiltradaCompletada;
      displayRescheduleOptions = false;
    });
    cargadoPendientes = true;
    cargadoCompletas = true;
  }

  // Change the attendanceDate to a selected date
  Future<bool> asignarFecha(int idData, int idLocal, String appliedDate,
      String attendanceDate) async {
    Map answer = {};
    await storage.updateAppointmentState(idLocal, attendanceDate);
    answer = await storage.changeWasChangedToTrue(idLocal);
    if (idData != 0) {
      bool isConnected = await GlobalVariables.isConnected();
      if (isConnected) {
        await CredRegisterCenter()
            .updateAppointmentState(idData, appliedDate, attendanceDate);
        await storage.changeWasChangedToFalse(idLocal);
      }
    }
    if (answer['id'] >= 0) {
      return true;
    }
    return false;
  }

  // Delete the attendanceDate from local storage and, if exist a connection, from the network database
  Future<bool> eliminarFecha(
      int idData, int idLocal, String appliedDate) async {
    Map answer = {};
    await storage.reverseAppointmentState(idLocal);
    answer = await storage.changeWasChangedToTrue(idLocal);
    if (idData != 0) {
      bool isConnected = await GlobalVariables.isConnected();
      if (isConnected) {
        await CredRegisterCenter()
            .deleteAppointmentDateApplied(idData, appliedDate);
        await storage.changeWasChangedToFalse(idLocal);
      }
    }
    if (answer['id'] >= 0) {
      return true;
    }
    return false;
  }

// This method add the register to local storage and, if exist a connection, into the network database
  Future<bool> addAppointment(var reminder) async {
    Map localAnswer = {};
    Map globalAnswer = {};

    AppointmentRegister register = AppointmentRegister(
        0,
        idKid,
        0,
        formattedDate,
        selectedDate.toString(),
        null,
        null,
        reminder['description'],
        'Pendiente',
        2,
        false,
        false);
    Map registerJson = register.toJson();
    await storage.writeRegister(registerJson);
    localAnswer = registerJson;

    bool isConnected = await GlobalVariables.isConnected();
    if (isConnected) {
      globalAnswer = await CredRegisterCenter().addAppointment(
        InternVariables.kid['id'],
        selectedDate.toString(),
        reminder['description'],
      );
      await storage.updateIdRegister(
          idKid, localAnswer['idLocal'], globalAnswer['id']);
    }

    if (localAnswer['id'] >= 0) {
      return true;
    }
    return false;
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
        await CredRegisterCenter().deleteAppointment(answer['id']);
        await storage.deleteRegister(idLocal);
      }
    }
    if (answer['id'] >= 0) {
      return true;
    }
    return false;
  }

  // Shows the date selector for completing an appointment
  Future<bool> _selectCompleteDate(
      BuildContext context, int idData, int idLocal, String appliedDate) async {
    var picked = await DatePicker.showSimpleDatePicker(
      context,
      initialDate: selectedDate,
      firstDate: DateTime.parse(InternVariables.kid['birthday']),
      lastDate: DateTime(2101),
      dateFormat: "dd-MMMM-yyyy",
      locale: GlobalVariables.language == 'ES'
          ? DateTimePickerLocale.es
          : DateTimePickerLocale.en_us,
      titleText: TranslateService.translate('addAppointment.datePickerTitle'),
      confirmText: TranslateService.translate('addAppointment.accept'),
      cancelText: TranslateService.translate('addAppointment.cancel'),
    );

    // final DateTime? picked = await showDatePicker(
    //     builder: (context, child) {
    //       return Theme(
    //         data: Theme.of(context).copyWith(
    //           colorScheme: ColorScheme.light(
    //             primary: AppColors.colorCREDBoy, // header background color
    //             onPrimary: Colors.black, // header text color
    //             onSurface: Colors.black, // body text color
    //           ),
    //           textButtonTheme: TextButtonThemeData(
    //             style: ButtonStyle(
    //               backgroundColor:
    //                   MaterialStateProperty.all<Color>(AppColors.colorCREDBoy),
    //               foregroundColor:
    //                   MaterialStateProperty.all<Color>(AppColors.font_primary),
    //             ),
    //           ),
    //           textTheme: const TextTheme(
    //             labelSmall:
    //                 TextStyle(fontSize: 16, overflow: TextOverflow.visible),
    //           ),
    //         ),
    //         child: child!,
    //       );
    //     },
    //     helpText: TranslateService.translate('addAppointment.datePickerTitle'),
    //     confirmText: TranslateService.translate('addAppointment.accept'),
    //     cancelText: TranslateService.translate('addAppointment.cancel'),
    //     context: context,
    //     locale: Locale(
    //         GlobalVariables.language.toLowerCase(), GlobalVariables.language),
    //     initialDate: selectedDate,
    //     firstDate: DateTime.parse(InternVariables.kid['birthday']),
    //     lastDate: DateTime(2101));
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
      return asignarFecha(
          idData, idLocal, appliedDate, selectedDate.toString());
    }
    return false;
  }

// Shows the date selector for rescheduling an appointment
  Future<bool> _selectRescheduleDate(BuildContext context) async {
    var picked = await DatePicker.showSimpleDatePicker(
      context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      dateFormat: "dd-MMMM-yyyy",
      locale: GlobalVariables.language == 'ES'
          ? DateTimePickerLocale.es
          : DateTimePickerLocale.en_us,
      titleText: TranslateService.translate('addAppointment.datePickerTitle'),
      confirmText: TranslateService.translate('addAppointment.accept'),
      cancelText: TranslateService.translate('addAppointment.cancel'),
    );

    // final DateTime? picked = await showDatePicker(
    //     builder: (context, child) {
    //       return Theme(
    //         data: Theme.of(context).copyWith(
    //           colorScheme: ColorScheme.light(
    //             primary: AppColors.colorCREDBoy, // header background color
    //             onPrimary: Colors.black, // header text color
    //             onSurface: Colors.black, // body text color
    //           ),
    //           textButtonTheme: TextButtonThemeData(
    //             style: ButtonStyle(
    //               backgroundColor:
    //                   MaterialStateProperty.all<Color>(AppColors.colorCREDBoy),
    //               foregroundColor:
    //                   MaterialStateProperty.all<Color>(AppColors.font_primary),
    //             ),
    //           ),
    //           textTheme: const TextTheme(
    //             labelSmall:
    //                 TextStyle(fontSize: 16, overflow: TextOverflow.visible),
    //           ),
    //         ),
    //         child: child!,
    //       );
    //     },
    //     helpText: TranslateService.translate('addAppointment.datePickerTitle'),
    //     confirmText: TranslateService.translate('addAppointment.accept'),
    //     cancelText: TranslateService.translate('addAppointment.cancel'),
    //     context: context,
    //     initialDate: selectedDate,
    //     firstDate: DateTime.parse(InternVariables.kid['birthday']),
    //     lastDate: DateTime(2101),
    //     locale: Locale(
    //         GlobalVariables.language.toLowerCase(), GlobalVariables.language));
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        formattedDate = DateFormat().add_yMMMd().format(selectedDate);
      });
      return true;
    }
    return false;
  }

  // Shows the completed appointments
  Widget showCompletes() {
    return Container(
      child: Builder(
        builder: (context) {
          if (completadas.isNotEmpty && cargadoCompletas) {
            return Container(
              child: Column(
                  children: completadas.map((text) {
                return Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                  /*decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Colors.white,
                          boxShadow: [
                            new BoxShadow(
                              color: Colors.black,
                              offset: new Offset(0.0, 2.0),
                              blurRadius: 3,
                            ),
                          ],),*/
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                            'appointmentPage.dialogBody2')),
                                      ),
                                      actions: [
                                        ElevatedButton(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Colors.transparent),
                                            shadowColor: MaterialStateProperty
                                                .all<Color>(Colors.transparent),
                                            foregroundColor:
                                                MaterialStateProperty.all<
                                                        Color>(
                                                    AppColors.font_primary),
                                          ),
                                          child: Text(
                                              TranslateService.translate(
                                                  'appointmentPage.cancel')),
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
                                                  'appointmentPage.accept')),
                                          onPressed: () async {
                                            bool answer;
                                            answer = await eliminarFecha(
                                                text['id'],
                                                text['idLocal'],
                                                text['date']);
                                            if (answer == true) {
                                              final snackBar = SnackBar(
                                                content: Text(
                                                    TranslateService.translate(
                                                        'appointmentPage.confirmChangeState')),
                                              );
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(snackBar);
                                              Navigator.pop(context);
                                            } else {
                                              final snackBar = SnackBar(
                                                content: Text(
                                                    TranslateService.translate(
                                                        'appointmentPage.errorChangeState')),
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
                                  icon: const Icon(Icons.mode),
                                ),
                              )),
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
                                          'appointmentPage.dialogBody')),
                                    ),
                                    actions: [
                                      ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.transparent),
                                          shadowColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.transparent),
                                          foregroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  AppColors.font_primary),
                                        ),
                                        child: Text(TranslateService.translate(
                                            'appointmentPage.cancel')),
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
                                            'appointmentPage.accept')),
                                        onPressed: () async {
                                          bool answer;
                                          answer = await deleteRegister(
                                              text['id'], text['idLocal']);
                                          if (answer == true) {
                                            final snackBar = SnackBar(
                                              content: Text(
                                                  TranslateService.translate(
                                                      'appointmentPage.confirmDelete')),
                                            );
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(snackBar);
                                            Navigator.pop(context);
                                          } else {
                                            final snackBar = SnackBar(
                                              content: Text(
                                                  TranslateService.translate(
                                                      'appointmentPage.errorDelete')),
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
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            child: Text(
                              text['attendanceDate_format'],
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 16),
                            ),
                          ),
                          Container(
                            child: Text(
                              '${text['state_value']}',
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.green),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${TranslateService.translate('appointmentPage.reason')}: ',
                              style: const TextStyle(fontSize: 16),
                            ),
                            Text(
                              text['description'],
                              textAlign: TextAlign.start,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList()),
            );
          } else if (!cargadoCompletas) {
            return Container(
              margin: const EdgeInsets.all(20),
              child: const Center(child: CircularProgressIndicator()),
            );
          } else {
            return Container(
              margin: const EdgeInsets.all(20),
              child: Center(
                  child: Text(
                      TranslateService.translate('appointmentPage.empty2'))),
            );
          }
        },
      ),
    );
  }

  Widget showCompleteOption(var reminder) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blueGrey),
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
            TranslateService.translate('appointmentPage.completeOptionTitle'),
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
                onPressed: () async {
                  bool answer = await _selectCompleteDate(context,
                      reminder['id'], reminder['idLocal'], reminder['date']);

                  if (answer == true) {
                    showCongratulationsMessage();
                    final snackBar = SnackBar(
                      content: Text(TranslateService.translate(
                          'appointmentPage.confirmCompleted')),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    //Navigator.pop(context);
                    actualizar();
                  } else {
                    final snackBar = SnackBar(
                      content: Text(TranslateService.translate(
                          'appointmentPage.deniedCompleted')),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
                child: Row(
                  children: [
                    Text(TranslateService.translate(
                        'appointmentPage.completeOptionYes')),
                    const Icon(Icons.check),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    displayRescheduleOptions = true;
                  });
                },
                child: Row(
                  children: [
                    Text(TranslateService.translate(
                        'appointmentPage.completeOptionNo')),
                    const Icon(Icons.close),
                  ],
                ),
              ),
            ],
          ),
          showRescheduleOptions(reminder),
        ],
      ),
    );
  }

  Widget showRescheduleOptions(var reminder) {
    if (displayRescheduleOptions) {
      return Container(
        margin: const EdgeInsets.fromLTRB(50, 5, 50, 5),
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              TranslateService.translate('appointmentPage.reschedule'),
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () async {
                      bool answer = await _selectRescheduleDate(context);
                      if (answer == true) {
                        await deleteRegister(
                            reminder['id'], reminder['idLocal']);
                        await addAppointment(reminder);
                        actualizar();
                      } else {
                        final snackBar = SnackBar(
                          content: Text(TranslateService.translate(
                              'appointmentPage.deniedUpdate')),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                    child: Text(TranslateService.translate(
                        'appointmentPage.completeOptionYes'))),
                ElevatedButton(
                    onPressed: () {},
                    child: Text(TranslateService.translate(
                        'appointmentPage.completeOptionNo')))
              ],
            ),
          ],
        ),
      );
    }
    return Container();
  }

  showCongratulationsMessage() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Container(
          padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
          child: const Text('¡Muy bien! 🥳 '),
        ),
      ),
    );
  }

  actualizar() {
    setState(() {
      loadAppointment();
    });
  }

  @override
  initState() {
    super.initState();
    loadAppointment();
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

      //endDrawer: LateralMenuCenter.fromInsideCRED(3, idKid, name),

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
                        '${GlobalVariables.logosAddress}calendario_cred_logo.png',
                        height: 25,
                        width: 25),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: Text(
                      TranslateService.translate('appointmentPage.title'),
                      style: const TextStyle(
                          fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Container(
                padding: const EdgeInsets.fromLTRB(15, 0, 0, 20),
                alignment: Alignment.centerLeft,
                child: Text(
                  TranslateService.translate('appointmentPage.pending'),
                  style: const TextStyle(color: Colors.orange, fontSize: 22),
                ),
              ),
            ),
            Container(
              child: Builder(
                builder: (context) {
                  if (pendientes.isNotEmpty && cargadoPendientes) {
                    return Container(
                      child: Column(
                          children: pendientes.map((text) {
                        return Container(
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
                              // delete planned
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
                                              'appointmentPage.dialogBody')),
                                        ),
                                        actions: [
                                          ElevatedButton(
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                          Color>(
                                                      Colors.transparent),
                                              shadowColor: MaterialStateProperty
                                                  .all<Color>(
                                                      Colors.transparent),
                                              foregroundColor:
                                                  MaterialStateProperty.all<
                                                          Color>(
                                                      AppColors.font_primary),
                                            ),
                                            child: Text(
                                                TranslateService.translate(
                                                    'appointmentPage.cancel')),
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
                                                    'appointmentPage.accept')),
                                            onPressed: () async {
                                              bool answer;
                                              answer = await deleteRegister(
                                                  text['id'], text['idLocal']);

                                              if (answer == true) {
                                                final snackBar = SnackBar(
                                                  content: Text(TranslateService
                                                      .translate(
                                                          'appointmentPage.confirmDelete')),
                                                );
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(snackBar);
                                                Navigator.pop(context);
                                              } else {
                                                final snackBar = SnackBar(
                                                  content: Text(TranslateService
                                                      .translate(
                                                          'appointmentPage.errorDelete')),
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
                                ),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: Text(
                                      text['date_format'],
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 20),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                margin: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${TranslateService.translate('appointmentPage.reason')}: ',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      text['description'],
                                      textAlign: TextAlign.start,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                              showCompleteOption(text),
                            ],
                          ),
                        );
                      }).toList()),
                    );
                  } else if (!cargadoPendientes) {
                    return Container(
                      margin: const EdgeInsets.all(20),
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  } else {
                    return Container(
                      margin: const EdgeInsets.all(20),
                      child: Center(
                          child: Text(TranslateService.translate(
                              'appointmentPage.empty'))),
                    );
                  }
                },
              ),
            ),
            Divider(color: AppColors.colorCREDBoy, thickness: 5, height: 30),
            Container(
              padding: const EdgeInsets.fromLTRB(15, 0, 0, 20),
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Text(
                    TranslateService.translate('appointmentPage.completed'),
                    style: const TextStyle(color: Colors.green, fontSize: 22),
                  ),
                ],
              ),
            ),
            showCompletes()
          ],
        ),
      )),
      bottomNavigationBar: BottomNavigationPage(),
      floatingActionButton: Container(
        margin: const EdgeInsets.fromLTRB(25, 5, 25, 0),
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
          child: Text(
            TranslateService.translate('appointmentPage.addAppointment'),
            style: const TextStyle(fontSize: 18),
            softWrap: true,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddAppointmentPage(
                        idKid: idKid,
                        kidName: name,
                      )),
            ).then((value) => actualizar());
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
