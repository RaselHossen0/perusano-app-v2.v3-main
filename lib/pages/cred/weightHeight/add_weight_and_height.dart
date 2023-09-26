import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:csv/csv.dart';
import 'package:perusano/util/class/join/date_picker/date_picker.dart';
import 'package:perusano/util/class/join/date_picker/i18n/date_picker_i18n.dart';
import '../../../services/apis/cred/credRegisterCenter.dart';
import '../../../services/fileManagement/cred/weightHeightFM.dart';
import '../../../services/translateService.dart';
import '../../../util/class/cred/weightHeight/weightHeightClass.dart';
import '../../../util/globalVariables.dart';
import '../../../util/internVariables.dart';
import '../../../util/myColors.dart';

class AddWeightAndHeightPage extends StatefulWidget {
  int idKid = 0;
  String kidName = '';

  AddWeightAndHeightPage({required this.idKid, required this.kidName});

  @override
  State<AddWeightAndHeightPage> createState() =>
      _AddWeightAndHeightPage(idKid: idKid, kidName: kidName);
}

class _AddWeightAndHeightPage extends State<AddWeightAndHeightPage> {
  int idKid = 0;
  String kidName = '';
  final WeightHeightFM storage = WeightHeightFM();

  _AddWeightAndHeightPage({required this.idKid, required this.kidName});

  double _weightSliderValue = 2;
  double _heightSliderValue = 45;

  final _formKey = GlobalKey<FormState>();

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
      titleText: TranslateService.translate('addWeightHeight.datePickerTitle'),
      confirmText: TranslateService.translate('addWeightHeight.accept'),
      cancelText: TranslateService.translate('addWeightHeight.cancel'),
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
    //     helpText: TranslateService.translate('addWeightHeight.datePickerTitle'),
    //     confirmText: TranslateService.translate('addWeightHeight.accept'),
    //     cancelText: TranslateService.translate('addWeightHeight.cancel'),
    //     context: context,
    //     locale: Locale(
    //         GlobalVariables.language.toLowerCase(), GlobalVariables.language),
    //     initialDate: selectedDate,
    //     firstDate: DateTime.parse(InternVariables.kid['birthday']),
    //     lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        formattedDate = DateFormat().add_yMMMd().format(selectedDate);
      });
    }
  }

  // Returns the age of the kid
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

  // Returns the diagnostic of the kid
  Future<List> calcularDiagnostico(int age) async {
    final String lengthData;
    final String weightForLengthData;
    final String rawData;
    if (InternVariables.kid['gender'] == 1) {
      lengthData =
          await rootBundle.loadString("assets/documents/boyLength.csv");

      weightForLengthData = await rootBundle
          .loadString("assets/documents/boyWeightForLength.csv");

      if (age < 24) {
        rawData = await rootBundle.loadString("assets/documents/boyWL.csv");
      } else {
        rawData = await rootBundle.loadString("assets/documents/boyWH.csv");
      }
    } else {
      lengthData =
          await rootBundle.loadString("assets/documents/girlLength.csv");

      weightForLengthData = await rootBundle
          .loadString("assets/documents/girlWeightForLength.csv");

      if (age < 24) {
        rawData = await rootBundle.loadString("assets/documents/girlWL.csv");
      } else {
        rawData = await rootBundle.loadString("assets/documents/girlWH.csv");
      }
    }

    List<List<dynamic>> lengthCSVData =
        const CsvToListConverter().convert(lengthData);

    List<List<dynamic>> weightForLengthCSVData =
        const CsvToListConverter().convert(weightForLengthData);

    // height and length are interchangable
    double weight = double.parse(_weightSliderValue.toStringAsFixed(3));
    double height = double.parse(_heightSliderValue.toStringAsFixed(1));

    // weight = double.parse(weight.toStringAsFixed(3));
    // height = double.parse(height.toStringAsFixed(1));

    List diagnostics = [
      [TranslateService.translate('addWeightHeight.noApplied'), 0],
      [TranslateService.translate('addWeightHeight.noApplied'), 0]
    ];

    for (var row in lengthCSVData) {
      if (age == row[0]) {
        if (height < row[6]) {
          diagnostics[0] = ['addWeightHeight.slowGrowth', 1];
        } else if (height < row[7]) {
          diagnostics[0] = ['addWeightHeight.riskSlowGrowth', 2];
        } else {
          diagnostics[0] = ['addWeightHeight.normal', 3];
        }
      }
    }

    for (var row in weightForLengthCSVData) {
      if (row[0] == height) {
        if (weight < row[5]) {
          diagnostics[1] = ['addWeightHeight.seriousMalnutrition', 1];
        } else if (weight < row[6]) {
          diagnostics[1] = ['addWeightHeight.mildMalnutrition', 2];
        } else if (weight < row[7]) {
          diagnostics[1] = ['addWeightHeight.normal', 3];
        } else if (weight < row[8]) {
          diagnostics[1] = ['addWeightHeight.overWeight', 4];
        } else {
          diagnostics[1] = ['addWeightHeight.obesity', 5];
        }
      }
    }
    return diagnostics;
  }

  // This method add the register to local storage and, if exist a connection, into the network database
  Future<bool> addWeightHeight() async {
    Map localAnswer = {};
    Map globalAnswer = {};

    int edad = calcularEdad(selectedDate.toString());
    List diagnostico = await calcularDiagnostico(edad);

    WeightHeightRegister register = WeightHeightRegister(
        0,
        idKid,
        0,
        _weightSliderValue,
        _heightSliderValue,
        formattedDate,
        selectedDate.toString(),
        edad,
        diagnostico[0][0],
        diagnostico[0][1],
        diagnostico[1][0],
        diagnostico[1][1],
        false,
        false);

    Map registerJson = register.toJson();
    await storage.writeRegister(registerJson);
    localAnswer = registerJson;

    bool isConnected = await GlobalVariables.isConnected();
    if (isConnected) {
      globalAnswer = await CredRegisterCenter().addWeightHeight(
          InternVariables.kid['id'],
          _weightSliderValue,
          _heightSliderValue,
          selectedDate.toString(),
          diagnostico[0][0],
          diagnostico[0][1],
          diagnostico[1][0],
          diagnostico[1][1]);
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
                  TranslateService.translate('addWeightHeight.title'),
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                child: Form(
                  key: _formKey,
                  child: Column(children: [
                    Container(
                      child: Table(
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        columnWidths: const {
                          0: FlexColumnWidth(1),
                          1: FlexColumnWidth(1),
                        },
                        children: [
                          TableRow(children: [
                            Text(TranslateService.translate(
                                'addWeightHeight.weight')),
                            Text('${_weightSliderValue.toStringAsFixed(2)} Kg'),
                          ]),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Column(
                        children: [
                          Slider(
                            value: _weightSliderValue,
                            min: 2,
                            max: 15,
                            divisions: 52,
                            onChanged: (double value) {
                              setState(() {
                                _weightSliderValue = value;
                              });
                            },
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [Text('2 kg'), Text('15 kg')],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Table(
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
                          columnWidths: const {
                            0: FlexColumnWidth(1),
                            1: FlexColumnWidth(1),
                          },
                          children: [
                            TableRow(children: [
                              Text(TranslateService.translate(
                                  'addWeightHeight.height')),
                              Text(
                                  '${_heightSliderValue.toStringAsFixed(2)} cm'),
                            ]),
                          ]),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Column(
                        children: [
                          Slider(
                            value: _heightSliderValue,
                            min: 45,
                            max: 100,
                            divisions: 110,
                            onChanged: (double value) {
                              setState(() {
                                _heightSliderValue = value;
                              });
                            },
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [Text('40 cm'), Text('75 cm')],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]),
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
                        TranslateService.translate('addWeightHeight.date'),
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
                      bool answer = await addWeightHeight();

                      if (answer == true) {
                        final snackBar = SnackBar(
                          content: Text(TranslateService.translate(
                              'addWeightHeight.confirm')),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        Navigator.pop(context);
                      } else {
                        final snackBar = SnackBar(
                          content: Text(TranslateService.translate(
                              'addWeightHeight.denied')),
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
                    TranslateService.translate('addWeightHeight.add'),
                  ),
                ),
              )
            ],
          ),
        ),
      ),

      /*floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            await calcularDiagnostico(2);
          },
          label: Text('Prueba')),*/
    );
  }
}
