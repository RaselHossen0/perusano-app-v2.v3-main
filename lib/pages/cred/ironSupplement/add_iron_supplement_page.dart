import 'package:flutter/material.dart';
import 'package:perusano/util/class/cred/ironSupplement/ironSupplementClass.dart';
import 'package:intl/intl.dart';
import 'package:perusano/util/class/join/date_picker/date_picker.dart';
import 'package:perusano/util/class/join/date_picker/i18n/date_picker_i18n.dart';

import '../../../services/apis/cred/credRegisterCenter.dart';
import '../../../services/fileManagement/cred/ironSupplementFM.dart';
import '../../../services/fileManagement/cred/selectable/ironSupplementNameFM.dart';
import '../../../services/fileManagement/recipes/selectable/unitFM.dart';
import '../../../services/translateService.dart';
import '../../../util/globalVariables.dart';
import '../../../util/internVariables.dart';
import '../../../util/myColors.dart';

class AddIronSupplementPage extends StatefulWidget {
  int idKid = 0;
  String kidName = '';

  AddIronSupplementPage({required this.idKid, required this.kidName});

  @override
  State<AddIronSupplementPage> createState() =>
      _AddIronSupplementPage(idKid: idKid, kidName: kidName);
}

class _AddIronSupplementPage extends State<AddIronSupplementPage> {
  int idKid = 0;
  String kidName = '';

  final IronSupplementFM _storage = IronSupplementFM();
  final IronSupplementNameFM _ironSupplementNamesStorage =
      IronSupplementNameFM();
  final UnitFM _unitStorage = UnitFM();

  _AddIronSupplementPage({required this.idKid, required this.kidName});

  final TextEditingController _cantidadController = TextEditingController();

  int _ironId = 1;
  String _ironType = 'addIronSupplement.sulfate';
  String _ironSupplementUnit = 'addIronSupplement.spoonfuls';
  int _ironSupplementUnitId = 1;

  final _formKey = GlobalKey<FormState>();

  DateTime _selectedDate = DateTime.now();
  late String _formattedDate = DateFormat().add_yMMMd().format(_selectedDate);

  // This method show the date selector
  Future<void> _selectDate(BuildContext context) async {
    var picked = await DatePicker.showSimpleDatePicker(
      context,
      initialDate: _selectedDate,
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
    //     initialDate: _selectedDate,
    //     firstDate: DateTime.parse(InternVariables.kid['birthday']),
    //     lastDate: DateTime(2101));
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _formattedDate = DateFormat().add_yMMMd().format(_selectedDate);
      });
    }
  }

  // This method add the register to local storage and, if exist a connection, into the network database
  Future<bool> addIronSupplement() async {
    Map localAnswer = {};
    Map globalAnswer = {};

    Map dosage = {
      'amount': int.parse(_cantidadController.text),
      'unit': _ironSupplementUnit,
      'unitId': _ironSupplementUnitId
    };

    IronSupplementRegister register = IronSupplementRegister(
        0,
        idKid,
        0,
        _ironType,
        _ironId,
        _ironType,
        dosage,
        _formattedDate,
        _selectedDate.toString(),
        false,
        false);
    Map registerJson = register.toJson();
    await _storage.writeRegister(registerJson);
    localAnswer = registerJson;

    bool isConnected = await GlobalVariables.isConnected();
    if (isConnected) {
      globalAnswer = await CredRegisterCenter().addIronSupplement(
        InternVariables.kid['id'],
        _ironId,
        int.parse(_cantidadController.text),
        _ironSupplementUnitId,
        _selectedDate.toString(),
      );
      await _storage.updateIdRegister(
          idKid, localAnswer['idLocal'], globalAnswer['id']);
    }
    if (localAnswer['id'] >= 0) {
      return true;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'CRED - $kidName',
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
                  TranslateService.translate('addIronSupplement.title'),
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 20, 30, 0),
                child: Column(
                  children: [
                    Text(
                      TranslateService.translate('addIronSupplement.type'),
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    ListTile(
                      title: Text(
                        TranslateService.translate('addIronSupplement.sulfate'),
                      ),
                      leading: Radio(
                          value: 'addIronSupplement.sulfate',
                          groupValue: _ironType,
                          onChanged: (value) {
                            setState(() {
                              _ironId = 1;
                              _ironType = value.toString();
                              _ironSupplementUnit =
                                  'addIronSupplement.spoonfuls';
                              _ironSupplementUnitId = 1;
                            });
                          }),
                    ),
                    ListTile(
                      title: Text(
                        TranslateService.translate(
                            'addIronSupplement.micronutrients'),
                      ),
                      leading: Radio(
                          value: 'addIronSupplement.micronutrients',
                          groupValue: _ironType,
                          onChanged: (value) {
                            setState(() {
                              _ironId = 2;
                              _ironType = value.toString();
                              _ironSupplementUnit = 'addIronSupplement.sips';
                              _ironSupplementUnitId = 2;
                            });
                          }),
                    ),
                    ListTile(
                      title: Text(
                        TranslateService.translate(
                            'addIronSupplement.sulfateDrops'),
                      ),
                      leading: Radio(
                          value: 'addIronSupplement.sulfateDrops',
                          groupValue: _ironType,
                          onChanged: (value) {
                            setState(() {
                              _ironId = 3;
                              _ironType = value.toString();
                              _ironSupplementUnit = 'addIronSupplement.drops';
                              _ironSupplementUnitId = 3;
                            });
                          }),
                    ),
                  ],
                ),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //     children: [
                //       Text(
                //         TranslateService.translate('addIronSupplement.name'),
                //         //textAlign: TextAlign.center,
                //         style: const TextStyle(
                //             fontSize: 20, fontWeight: FontWeight.bold),
                //       ),
                //       Container(
                //           // child: DropdownButton(
                //           //   items: _ironSupplements.map((text) {
                //           //     return DropdownMenuItem(
                //           //       value: {
                //           //         'id': text['id'],
                //           //         'value': text['label'],
                //           //         'type': text['type']['label']
                //           //       },
                //           //       child: Text(text['label']),
                //           //     );
                //           //   }).toList(),
                //           //   onChanged: (value) {
                //           //     setState(() {
                //           //       _ironEscogida = value!['value'];
                //           //       _idIron = value!['id'];
                //           //       _ironTypeEscogida = value!['type'];
                //           //       validateDropDownButton();
                //           //     });
                //           //   },
                //           //   hint: Text(_ironEscogida),
                //           // ),
                //           ),
                //     ],
                //   ),
              ),
              Divider(color: AppColors.colorCREDBoy, thickness: 5, height: 30),
              Container(
                child: Row(
                  children: [
                    /*Text(
                      '${TranslateService.translate('addIngredient.amount')}',
                      //textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),*/
                    Flexible(
                      child: Container(
                        width: 260,
                        padding: const EdgeInsets.fromLTRB(10, 0, 30, 0),
                        child: Form(
                          key: _formKey,
                          child: TextFormField(
                            validator: (value) {
                              if (value == '') {
                                return TranslateService.translate(
                                    'addIronSupplement.validateText');
                              }
                            },
                            controller: _cantidadController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              icon: const Icon(Icons.numbers),
                              label: Text(TranslateService.translate(
                                  'addIronSupplement.amount')),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(0, 30, 20, 0),
                      child:
                          Text(TranslateService.translate(_ironSupplementUnit)),
                    )
                  ],
                ),
              ),
              // Container(
              //   padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
              //   alignment: Alignment.center,
              //   child: Table(
              //     columnWidths: const {
              //       0: FlexColumnWidth(1),
              //       1: FlexColumnWidth(1),
              //     },
              //     children: [
              //       TableRow(children: [
              //         Container(
              //           margin: const EdgeInsets.fromLTRB(0, 12, 0, 0),
              //           child: Text(
              //             TranslateService.translate('addIronSupplement.unit'),
              //             //textAlign: TextAlign.center,
              //             style: const TextStyle(
              //                 fontSize: 20, fontWeight: FontWeight.bold),
              //           ),
              //         ),
              //         Container(
              //           child: DropdownButton(
              //             items: _unidades.map((text) {
              //               return DropdownMenuItem(
              //                 value: {'id': text['id'], 'value': text['value']},
              //                 child: Text(text['value']),
              //               );
              //             }).toList(),
              //             onChanged: (value) {
              //               setState(() {
              //                 _unidadEscogida = value!['value'];
              //                 _idUnidad = value!['id'];
              //                 validateDropDownButton();
              //               });
              //             },
              //             hint: Text(_unidadEscogida),
              //           ),
              //         ),
              //       ]),
              //       TableRow(children: [
              //         Container(
              //           margin: const EdgeInsets.all(0),
              //         ),
              //         _underLineUnit
              //       ])
              //     ],
              //   ),
              // ),
              Divider(color: AppColors.colorCREDBoy, thickness: 5, height: 30),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 20, 30, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      child: Text(
                        TranslateService.translate('addIronSupplement.date'),
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
                        child: Text(_formattedDate),
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
                    if (_formKey.currentState!.validate() &&
                        _ironId != 0 &&
                        _ironSupplementUnitId != 0) {
                      bool answer = await addIronSupplement();

                      if (answer == true) {
                        final snackBar = SnackBar(
                          content: Text(TranslateService.translate(
                              'addIronSupplement.confirm')),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        Navigator.pop(context);
                      } else {
                        final snackBar = SnackBar(
                          content: Text(TranslateService.translate(
                              'addIronSupplement.denied')),
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
                    TranslateService.translate('addIronSupplement.add'),
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
