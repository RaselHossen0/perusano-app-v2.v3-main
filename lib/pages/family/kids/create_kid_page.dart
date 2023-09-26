import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:perusano/services/apis/cred/credRegisterCenter.dart';
import 'package:perusano/services/fileManagement/cred/weightHeightFM.dart';
import 'package:perusano/util/class/cred/weightHeight/weightHeightClass.dart';
import 'package:perusano/util/internVariables.dart';
import 'package:perusano/util/myColors.dart';
import 'package:intl/intl.dart';

import '../../../services/apis/cred/credService.dart';
import '../../../services/apis/family/familyRegisterCenter.dart';
import '../../../services/fileManagement/cred/allVaccinesFM.dart';
import '../../../services/fileManagement/family/kidFM.dart';
import '../../../services/fileManagement/cred/vaccineFM.dart';
import '../../../services/translateService.dart';
import '../../../util/class/cred/vaccines/doseClass.dart';
import '../../../util/class/family/kids/kidClass.dart';
import '../../../util/class/cred/vaccines/vaccineClass.dart';
import '../../../util/class/join/date_picker/date_picker.dart';
import '../../../util/class/join/date_picker/i18n/date_picker_i18n.dart';
import '../../../util/globalVariables.dart';

enum Generos { M, F }

class CreateKidPage extends StatefulWidget {
  int idFamily;

  CreateKidPage(this.idFamily);

  @override
  State<CreateKidPage> createState() => _CreateKidPage(idFamily);
}

class _CreateKidPage extends State<CreateKidPage> {
  int idFamily;

  final KidFM _kidStorage = KidFM();
  final VaccineFM _vaccineStorage = VaccineFM();

  final _formKeyName = GlobalKey<FormState>();
  final _formKeyApellidoPadre = GlobalKey<FormState>();
  final _formKeyApellidoMadre = GlobalKey<FormState>();
  final _formKeyPeso = GlobalKey<FormState>();
  final _formKeyAltura = GlobalKey<FormState>();
  final _formKeyAfiliado = GlobalKey<FormState>();

  double _weightSliderValue = 2;
  double _heightSliderValue = 40;

  _CreateKidPage(this.idFamily);

  final TextEditingController namesController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController motherLastNameController =
      TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController sizeController = TextEditingController();
  final TextEditingController affiliateCodeController = TextEditingController();
  bool isHealthPerson = false;
  late int healthCenter;
  String gender = 'M';

  final AllVaccinesFM _allVaccinesStorage = AllVaccinesFM();
  final WeightHeightFM _weightHeightStorage = WeightHeightFM();

  bool haveCheckedDate = false;
  bool showDateError = false;
  DateTime selectedDate = DateTime.now();
  late String formattedDate = DateFormat().add_yMMMd().format(selectedDate);
  late Map dataUser;

  // Shows the date selector
  Future<void> _selectDate(BuildContext context) async {
    var picked = await DatePicker.showSimpleDatePicker(
      context,
      initialDate: selectedDate,
      firstDate: DateTime(2017),
      lastDate: DateTime.now(),
      dateFormat: "dd-MMMM-yyyy",
      locale: GlobalVariables.language == 'ES'
          ? DateTimePickerLocale.es
          : DateTimePickerLocale.en_us,
      titleText: TranslateService.translate('createKidPage.dateTitle'),
      confirmText: TranslateService.translate('createKidPage.dateConfirm'),
      cancelText: TranslateService.translate('createKidPage.dateCancel'),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        formattedDate = DateFormat().add_yMMMd().format(selectedDate);
      });
    }
  }

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

  //This method add the register in local Storage and, if is connected to the network, add the register into network data base
  Future<bool> addKid() async {
    int generoEscogido = gender == 'M' ? 1 : 2;
    String urlPhoto = gender == 'M' ? 'bebe_logo.png' : 'nina.png';

    KidRegister registerKid = KidRegister(
        0,
        namesController.text,
        lastNameController.text,
        motherLastNameController.text,
        formattedDate,
        selectedDate.toString(),
        //double.parse(weightController.text),
        //double.parse(sizeController.text),
        generoEscogido,
        // affiliateCodeController.text,
        "",
        urlPhoto,
        idFamily,
        false,
        false);

    Map registerJson = registerKid.toJson();
    Map answer = await _kidStorage.writeRegister(registerJson);
    dataUser = registerJson;

    await creandoVaccines(answer['idLocal']);

    bool isConnected = await GlobalVariables.isConnected();

    if (isConnected) {
      Map globalAnswer = await FamilyRegisterCenter().addKid(
          namesController.text,
          lastNameController.text,
          motherLastNameController.text,
          selectedDate.toString(),
          double.parse(weightController.text),
          double.parse(sizeController.text),
          generoEscogido,
          affiliateCodeController.text,
          idFamily);
      if (globalAnswer.isNotEmpty) {
        await _kidStorage.updateIdRegister(
            dataUser['idLocal'], globalAnswer['id']);
        await actualizandoVaccines(globalAnswer['id'], dataUser['idLocal']);
      }

      //await _vaccineStorage
    }

    // int age = calcularEdad(selectedDate.toString());
    int age = 0;
    List diagnostic = await calcularDiagnostico(age);

    WeightHeightRegister registerWeightHeight = WeightHeightRegister(
        0,
        dataUser['idLocal'],
        0,
        double.parse(_weightSliderValue.toString()),
        double.parse(_heightSliderValue.toString()),
        formattedDate,
        selectedDate.toString(),
        age,
        diagnostic[0][0],
        diagnostic[0][1],
        diagnostic[1][0],
        diagnostic[1][1],
        false,
        false);

    Map weightHeightRegisterJson = registerWeightHeight.toJson();
    await _weightHeightStorage.writeRegister(weightHeightRegisterJson);
    Map localAnswer = weightHeightRegisterJson;

    if (isConnected) {
      Map globalAnswer = await CredRegisterCenter().addWeightHeight(
          InternVariables.kid['id'],
          _weightSliderValue,
          _heightSliderValue,
          selectedDate.toString(),
          diagnostic[0][0],
          diagnostic[0][1],
          diagnostic[1][0],
          diagnostic[1][1]);
      await _weightHeightStorage.updateIdRegister(
          0, localAnswer['idLocal'], globalAnswer['id']);
    }

    if (dataUser['idLocal'] >= 0) {
      return true;
    }
    return false;
  }

  // Create kids vaccines
  Future<void> creandoVaccines(int idLocalKid) async {
    String birthday = dataUser['dateRaw'];

    List allVaccines = await _allVaccinesStorage.readFile();

    for (var vaccine in allVaccines) {
      List doses = [];
      List timeDosis = vaccine['timeDosis'];
      int numDosis = 1;
      for (var monthDose in timeDosis) {
        String suggestDate = DateTime.parse(birthday)
            .add(Duration(days: monthDose * 30))
            .toString();
        DoseRegister dose = DoseRegister(
            0,
            numDosis,
            null,
            null,
            DateFormat('dd-MMM-yyyy').format(DateTime.parse(suggestDate)),
            suggestDate,
            monthDose,
            false);
        doses.add(dose.toJson());
        numDosis++;
      }
      VaccineRegister register = VaccineRegister(
          dataUser['id'], idLocalKid, vaccine['id'], vaccine['name'], doses);
      Map registerJson = register.toJson();
      await _vaccineStorage.writeRegister(registerJson);
    }
  }

  // Updates id from network database to local storage
  Future<void> actualizandoVaccines(int idKid, int idLocalKid) async {
    await _vaccineStorage.updateIdKidInVaccines(idLocalKid, idKid);
    //Obtiene el conjunto de vacunas del niño tanto del server como del localStorage
    List kidLocalVaccine = await _vaccineStorage.readFileById(idLocalKid);
    List answerVaccine = await CredService().getVaccinesByKidId(idKid);
    if (kidLocalVaccine.isNotEmpty && answerVaccine.isNotEmpty) {
      //Recorre ambos a la vez para ir añadiendo el IdGlobal a cada dosis
      for (var index = 0; index < kidLocalVaccine.length; index++) {
        List localVaccineDoses = kidLocalVaccine[index]['dosis'];
        List globalVaccineDoses = answerVaccine[index]['dosis'];

        for (var indexDose = 0;
            indexDose < localVaccineDoses.length;
            indexDose++) {
          await _vaccineStorage.updateIdDoseInVaccines(
              idKid,
              answerVaccine[index]['id'],
              localVaccineDoses[indexDose]['idLocal'],
              globalVaccineDoses[indexDose]['id']);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Text(
                TranslateService.translate('createKidPage.title'),
                style: const TextStyle(color: Colors.black),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {},
                color: Colors.black,
              )
            ],
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: Container(
          margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 0, 30, 10),
                  child: Row(
                    children: [
                      Text(
                        TranslateService.translate('createKidPage.gender'),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                Container(
                    padding: const EdgeInsets.fromLTRB(0, 10, 10, 0),
                    child: Row(
                      children: [
                        Expanded(
                          child: RadioListTile(
                            title: Image.asset(
                                '${GlobalVariables.publicAddress}bebe_logo.png'),
                            subtitle: Text(
                              TranslateService.translate(
                                'createKidPage.boy',
                              ),
                              textAlign: TextAlign.center,
                            ),
                            value: "M",
                            groupValue: gender,
                            onChanged: (value) {
                              setState(() {
                                gender = value.toString();
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: RadioListTile(
                            title: Image.asset(
                                '${GlobalVariables.publicAddress}nina.png'),
                            subtitle: Text(
                              TranslateService.translate('createKidPage.girl'),
                              textAlign: TextAlign.center,
                            ),
                            value: "F",
                            groupValue: gender,
                            onChanged: (value) {
                              setState(() {
                                gender = value.toString();
                              });
                            },
                          ),
                        ),
                      ],
                    )),
                Divider(color: AppColors.primary, thickness: 5, height: 30),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 0, 30, 10),
                  child: Form(
                    key: _formKeyName,
                    child: TextFormField(
                      validator: (value) {
                        if (value == '') {
                          return TranslateService.translate(
                              'addIronSupplement.validateText');
                        }
                      },
                      controller: namesController,
                      decoration: InputDecoration(
                        icon: const Icon(Icons.drive_file_rename_outline),
                        label: Text(
                            TranslateService.translate('createKidPage.names')),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 20, 30, 10),
                  child: Form(
                    key: _formKeyApellidoPadre,
                    child: TextFormField(
                      validator: (value) {
                        if (value == '') {
                          return TranslateService.translate(
                              'addIronSupplement.validateText');
                        }
                      },
                      controller: lastNameController,
                      decoration: InputDecoration(
                        icon: const Icon(Icons.drive_file_rename_outline),
                        label: Text(TranslateService.translate(
                            'createKidPage.last_name')),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 20, 30, 10),
                  child: Form(
                    key: _formKeyApellidoMadre,
                    child: TextFormField(
                      validator: (value) {
                        if (value == '') {
                          return TranslateService.translate(
                              'addIronSupplement.validateText');
                        }
                      },
                      controller: motherLastNameController,
                      decoration: InputDecoration(
                        icon: const Icon(Icons.drive_file_rename_outline),
                        label: Text(TranslateService.translate(
                            'createKidPage.mother_last_name')),
                      ),
                    ),
                  ),
                ),
                Divider(color: AppColors.primary, thickness: 5, height: 30),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 20, 30, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text(
                          TranslateService.translate('createKidPage.birthday'),
                          style: const TextStyle(fontSize: 15),
                        ),
                      ),
                      showDateError
                          ? Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.redAccent),
                                  borderRadius: BorderRadius.circular(20)),
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    haveCheckedDate = true;
                                  });
                                  _selectDate(context);
                                },
                                child: Text(formattedDate),
                              ),
                            )
                          : Container(
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    haveCheckedDate = true;
                                  });
                                  _selectDate(context);
                                },
                                child: Text(formattedDate),
                              ),
                            )
                    ],
                  ),
                ),
                Divider(color: AppColors.primary, thickness: 5, height: 30),
                Container(
                  child: Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    columnWidths: const {
                      0: FlexColumnWidth(1),
                      1: FlexColumnWidth(1),
                    },
                    children: [
                      TableRow(children: [
                        Text(
                            TranslateService.translate('createKidPage.weight')),
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
                      Form(
                        key: _formKeyPeso,
                        child: Slider(
                          value: _weightSliderValue,
                          min: 2,
                          max: 10,
                          divisions: 32,
                          onChanged: (double value) {
                            setState(() {
                              _weightSliderValue = value;
                            });
                          },
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [Text('2 kg'), Text('10 kg')],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: Table(
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      columnWidths: const {
                        0: FlexColumnWidth(1),
                        1: FlexColumnWidth(1),
                      },
                      children: [
                        TableRow(children: [
                          Text(
                              TranslateService.translate('createKidPage.size')),
                          Text('${_heightSliderValue.toStringAsFixed(2)} cm'),
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
                      Form(
                        key: _formKeyAltura,
                        child: Slider(
                          value: _heightSliderValue,
                          min: 40,
                          max: 75,
                          divisions: 70,
                          onChanged: (double value) {
                            setState(() {
                              _heightSliderValue = value;
                            });
                          },
                        ),
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
                Divider(color: AppColors.primary, thickness: 5, height: 30),
                // Container(
                //   padding: const EdgeInsets.fromLTRB(10, 20, 30, 10),
                //   child: Form(
                //     key: _formKeyAfiliado,
                //     child: TextFormField(
                //       validator: (value) {
                //         if (value == '') {
                //           return TranslateService.translate(
                //               'addIronSupplement.validateText');
                //         }
                //       },
                //       controller: affiliateCodeController,
                //       decoration: InputDecoration(
                //         icon: const Icon(Icons.numbers),
                //         label: Text(TranslateService.translate(
                //             'createKidPage.affiliate_code')),
                //       ),
                //     ),
                //   ),
                // ),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKeyName.currentState!.validate() &&
                          _formKeyApellidoPadre.currentState!.validate() &&
                          _formKeyApellidoMadre.currentState!.validate() &&
                          _formKeyPeso.currentState!.validate() &&
                          _formKeyAltura.currentState!.validate() &&
                          haveCheckedDate) {
                        setState(() {
                          showDateError = false;
                        });
                        // &&
                        // _formKeyAfiliado.currentState!.validate()) {
                        bool answer = await addKid();

                        if (answer == true) {
                          final snackBar = SnackBar(
                            content: Text(TranslateService.translate(
                                'createKidPage.confirmation_message')),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          Navigator.pop(context);
                        } else {
                          final snackBar = SnackBar(
                            content: Text(TranslateService.translate(
                                'createKidPage.denied_message')),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      }
                      if (haveCheckedDate) {
                        setState(() {
                          showDateError = false;
                        });
                      } else {
                        setState(() {
                          showDateError = true;
                        });
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(AppColors.primary),
                      foregroundColor: MaterialStateProperty.all<Color>(
                          AppColors.font_primary),
                    ),
                    child: Text(
                      TranslateService.translate('createKidPage.add_kid'),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
