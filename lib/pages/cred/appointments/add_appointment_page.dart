import 'package:flutter/material.dart';
import 'package:perusano/util/class/cred/appointments/appointmentClass.dart';
import 'package:intl/intl.dart';
import 'package:perusano/util/class/join/date_picker/date_picker.dart';
import 'package:perusano/util/class/join/date_picker/i18n/date_picker_i18n.dart';

import '../../../components/lateralMenu.dart';
import '../../../services/apis/cred/credRegisterCenter.dart';
import '../../../services/fileManagement/cred/appointmentFM.dart';
import '../../../services/translateService.dart';
import '../../../util/globalVariables.dart';
import '../../../util/internVariables.dart';
import '../../../util/myColors.dart';

class AddAppointmentPage extends StatefulWidget {
  int idKid = 0;
  String kidName = '';

  AddAppointmentPage({required this.idKid, required this.kidName});

  @override
  State<AddAppointmentPage> createState() =>
      _AddAppointmentPage(idKid: idKid, kidName: kidName);
}

class _AddAppointmentPage extends State<AddAppointmentPage> {
  int idKid = 0;
  String kidName = '';

  AppointmentFM storage = AppointmentFM();

  _AddAppointmentPage({required this.idKid, required this.kidName});

  final _formKey = GlobalKey<FormState>();

  TextEditingController descriptionController = new TextEditingController();

  DateTime selectedDate = DateTime.now();
  late String formattedDate = DateFormat().add_yMMMd().format(selectedDate);

  // This method show the date selector
  Future<void> _selectDate(BuildContext context) async {
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
    }
  }

  // This method add the register to local storage and, if exist a connection, into the network database
  Future<bool> addAppointment() async {
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
        descriptionController.text,
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
        descriptionController.text,
      );
      await storage.updateIdRegister(
          idKid, localAnswer['idLocal'], globalAnswer['id']);
    }

    if (localAnswer['id'] >= 0) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'CRED - ${kidName}',
              style: const TextStyle(color: Colors.black),
            ),
          ],
        ),
        backgroundColor: AppColors.colorCREDBoy,
        elevation: 0,
      ),
      endDrawer: LateralMenu(),
      body: Container(
        margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                child: Text(
                  TranslateService.translate('addAppointment.title'),
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                child: Row(
                  children: [
                    Flexible(
                      child: Container(
                          padding: const EdgeInsets.fromLTRB(10, 20, 30, 10),
                          child: Form(
                            key: _formKey,
                            child: TextFormField(
                              validator: (value) {
                                if (value == '') {
                                  return TranslateService.translate(
                                      'addAppointment.validateText');
                                }
                              },
                              controller: descriptionController,
                              maxLines: null,
                              decoration: InputDecoration(
                                icon: const Icon(Icons.description),
                                label: Text(TranslateService.translate(
                                    'addAppointment.description')),
                              ),
                            ),
                          )),
                    ),
                  ],
                ),
              ),
              Divider(color: AppColors.colorCREDBoy, thickness: 5, height: 30),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 20, 30, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      child: Text(
                        TranslateService.translate('addAppointment.date'),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    Container(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              AppColors.colorCREDBoy),
                          foregroundColor: MaterialStateProperty.all<Color>(
                              AppColors.font_primary),
                        ),
                        onPressed: () => _selectDate(context),
                        child: Text(formattedDate),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      bool answer = await addAppointment();

                      if (answer == true) {
                        final snackBar = SnackBar(
                          content: Text(TranslateService.translate(
                              'addAppointment.confirm')),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        Navigator.pop(context);
                      } else {
                        final snackBar = SnackBar(
                          content: Text(TranslateService.translate(
                              'addAppointment.denied')),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        AppColors.colorCREDBoy),
                    foregroundColor: MaterialStateProperty.all<Color>(
                        AppColors.font_primary),
                  ),
                  child: Text(
                    TranslateService.translate('addAppointment.add'),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
