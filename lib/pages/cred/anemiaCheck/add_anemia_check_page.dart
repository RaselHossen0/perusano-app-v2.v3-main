import 'package:flutter/material.dart';
import 'package:perusano/util/class/cred/anemiaCheck/anemiaCheckClass.dart';
import 'package:perusano/util/class/join/date_picker/date_picker.dart';
import 'package:perusano/util/class/join/date_picker/i18n/date_picker_i18n.dart';
import 'package:perusano/util/globalVariables.dart';
import 'package:intl/intl.dart';

import '../../../services/apis/cred/credRegisterCenter.dart';
import '../../../services/fileManagement/cred/anemiaCheckFM.dart';
import '../../../services/translateService.dart';
import '../../../util/internVariables.dart';
import '../../../util/myColors.dart';

class AddAnemiaCheckPage extends StatefulWidget {
  int idKid;
  String kidName;

  AddAnemiaCheckPage({required this.idKid, required this.kidName});

  @override
  State<AddAnemiaCheckPage> createState() =>
      _AddAnemiaCheckPage(idKid: idKid, kidName: kidName);
}

class _AddAnemiaCheckPage extends State<AddAnemiaCheckPage> {
  int idKid;
  String kidName;
  final AnemiaCheckFM storage = AnemiaCheckFM();

  final _formKey = GlobalKey<FormState>();

  _AddAnemiaCheckPage({required this.idKid, required this.kidName});

  TextEditingController resultController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  late String formattedDate = DateFormat().add_yMMMd().format(selectedDate);

  //This method show the date selector
  Future<void> _selectDate(BuildContext context) async {
    var picked = await DatePicker.showSimpleDatePicker(
      context,
      initialDate: selectedDate,
      firstDate: DateTime.parse(InternVariables.kid['birthday']),
      lastDate: DateTime.now(),
      dateFormat: "dd-MMMM-yyyy",
      locale: GlobalVariables.language == 'ES'
          ? DateTimePickerLocale.es
          : DateTimePickerLocale.en_us,
      titleText: TranslateService.translate('addAnemiaCheck.datePickerTitle'),
      confirmText: TranslateService.translate('addAnemiaCheck.accept'),
      cancelText: TranslateService.translate('addAnemiaCheck.cancel'),
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
    //     helpText: TranslateService.translate('addAnemiaCheck.datePickerTitle'),
    //     confirmText: TranslateService.translate('addAnemiaCheck.accept'),
    //     cancelText: TranslateService.translate('addAnemiaCheck.cancel'),
    //     context: context,
    //     initialDate: selectedDate,
    //     firstDate: DateTime.parse(InternVariables.kid['birthday']),
    //     lastDate: DateTime(2101),
    //     locale: Locale(
    //         GlobalVariables.language.toLowerCase(), GlobalVariables.language));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        formattedDate = DateFormat().add_yMMMd().format(selectedDate);
      });
    }
  }

  //This method calculates the age of the kid
  calcularEdad(String date) {
    DateTime nacimiento = DateTime.parse(InternVariables.kid['birthday']);
    DateTime fechaRegistro = DateTime.parse(date);

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
    return edadMeses;
  }

  //This method add the register in local Storage and, if is connected to the network, add the register into network data base
  Future<bool> addAnemiaCheck() async {
    Map localAnswer = {};
    Map globalAnswer = {};

    int edad = calcularEdad(selectedDate.toString());

    AnemiaCheckRegister register = AnemiaCheckRegister(
        0,
        idKid,
        0,
        double.parse(resultController.text),
        formattedDate,
        selectedDate.toString(),
        edad,
        false,
        false);
    /*Map temp = {
      "id": idKid,
      "result": double.parse(resultController.text),
      "date": formattedDate,
      "age": 100
    };*/
    Map registerJson = register.toJson();

    await storage.writeRegister(registerJson);
    localAnswer = registerJson;
    //answer = temp;
    bool isConnected = await GlobalVariables.isConnected();

    if (isConnected) {
      globalAnswer = await CredRegisterCenter().addAnemiaCheck(
        InternVariables.kid['id'],
        double.parse(resultController.text),
        selectedDate.toString(),
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

      //endDrawer: LateralMenu(),

      body: Container(
        margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                child: Text(
                  TranslateService.translate('addAnemiaCheck.title'),
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
                                    'addAnemiaCheck.validateText');
                              }
                            },
                            controller: resultController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              icon: const Icon(Icons.medical_information),
                              label: Text(TranslateService.translate(
                                  'addAnemiaCheck.result')),
                            ),
                          ),
                        ),
                      ),
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
                        TranslateService.translate('addAnemiaCheck.date'),
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
                      // Si el formulario es válido, queremos mostrar un Snackbar

                      bool answer = await addAnemiaCheck();

                      if (answer == true) {
                        final snackBar = SnackBar(
                          content: Text(TranslateService.translate(
                              'addAnemiaCheck.confirm')),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        Navigator.pop(context);
                      } else {
                        final snackBar = SnackBar(
                          content: Text(TranslateService.translate(
                              'addAnemiaCheck.denied')),
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
                    TranslateService.translate('addAnemiaCheck.add'),
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
