/*
* This class is not used but it could be useful to health center view
* */

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:perusano/components/bottomNavigation.dart';
import 'package:perusano/util/globalVariables.dart';

import '../../components/lateralMenu.dart';
import '../../services/apis/cred/credRegisterCenter.dart';
import '../../services/apis/cred/credService.dart';
import '../../services/translateService.dart';
import '../../util/myColors.dart';

class AddVaccinePage extends StatefulWidget {
  int idKid = 0;
  String kidName = '';

  AddVaccinePage({required this.idKid, required this.kidName});

  @override
  State<AddVaccinePage> createState() =>
      _AddVaccinePage(idKid: idKid, kidName: kidName);
}

class _AddVaccinePage extends State<AddVaccinePage> {
  int idKid = 0;
  String kidName = '';
  _AddVaccinePage({required this.idKid, required this.kidName});

  List vaccines = [];
  String vacunaEscogida = TranslateService.translate('addVaccine.choose');
  int idVacuna = 0;
  List vacunasActuales = [];
  int totalDosis = 0;
  int numberNextDose = 0;

  DateTime selectedDate = DateTime.now();
  late String formattedDate = TranslateService.translate('createKidPage.date');

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        locale: Locale(
            GlobalVariables.language.toLowerCase(), GlobalVariables.language),
        initialDate: selectedDate,
        firstDate: DateTime(1920, 1),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        formattedDate = DateFormat().add_yMMMd().format(selectedDate);
      });
    }
  }

  loadVaccines() async {
    List dataObt;
    dataObt = await CredService().getAllVaccines();
    setState(() {
      vaccines = dataObt;
    });
  }

  loadKidVaccines() async {
    List dataObt;
    dataObt = await CredService().getVaccinesByKidId(idKid);
    setState(() {
      vacunasActuales = dataObt;
    });
  }

  Widget presentaWidget() {
    if (idVacuna <= 0) {
      return Container(
        padding: EdgeInsets.all(50),
        child: Text('Escoja una vacuna'),
      );
    }

    for (var value in vacunasActuales) {
      if (value['id'] == idVacuna) {
        if (value['dosis'].length >= totalDosis) {
          numberNextDose = 0;
          return Container(
            padding: EdgeInsets.all(50),
            child: Text('No se pueden programar mas dosis de esta vacuna'),
          );
        }
        numberNextDose = value['dosis'].length + 1;
        return Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Text(
                TranslateService.translate('addVaccine.add_dose'),
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10, 10, 30, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    child: Text(
                      TranslateService.translate('addVaccine.next_dose'),
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                          color: AppColors.colorCREDBoy,
                          shape: BoxShape.circle),
                      child: Center(
                        child: Text(
                          '$numberNextDose',
                          style: TextStyle(),
                        ),
                      )),
                ],
              ),
            ),
            Container(
                padding: EdgeInsets.fromLTRB(10, 0, 30, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      child: Text(
                        TranslateService.translate('addVaccine.date_suggested'),
                        style: TextStyle(fontSize: 16),
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
                )),
          ],
        );
      }
    }
    numberNextDose = 1;
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
          child: Text(
            TranslateService.translate('addVaccine.add_dose'),
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(10, 10, 30, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                child: Text(
                  TranslateService.translate('addVaccine.next_dose'),
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                      color: AppColors.primary, shape: BoxShape.circle),
                  child: Center(
                    child: Text(
                      '$numberNextDose',
                      style: TextStyle(),
                    ),
                  )),
            ],
          ),
        ),
        Container(
            padding: EdgeInsets.fromLTRB(10, 0, 30, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  child: Text(
                    TranslateService.translate('addVaccine.date_suggested'),
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Container(
                  child: ElevatedButton(
                    onPressed: () => _selectDate(context),
                    child: Text(formattedDate),
                  ),
                )
              ],
            )),
      ],
    );
  }

  Future<bool> addDose() async {
    Map answer = {};
    answer = await CredRegisterCenter().addVaccineDose(
        idKid, selectedDate.toString(), numberNextDose, idVacuna);
    if (answer['id'] > 0) {
      return true;
    }
    return false;
  }

  formateandoFecha(String date) {
    List dates = date.split(' ');
    return dates[0];
  }

  @override
  void initState() {
    super.initState();
    loadVaccines();
    loadKidVaccines();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'CRED - ${kidName}',
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
        backgroundColor: AppColors.colorCREDBoy,
        elevation: 0,
      ),
      endDrawer: LateralMenu(),
      body: Container(
        margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                child: Text(
                  TranslateService.translate('addVaccine.title'),
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10, 20, 30, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Container(
                        //color: Colors.red,
                        //padding: EdgeInsets.fromLTRB(10, 20, 30, 10),
                        child: Text(
                          TranslateService.translate('addVaccine.name'),
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Container(
                        //color: Colors.blue,
                        child: DropdownButton(
                          items: vaccines.map((text) {
                            return DropdownMenuItem(
                              value: {
                                'id': text['id'],
                                'name': text['name'],
                                'totalDosis': text['totalDosis']
                              },
                              child: Flexible(
                                fit: FlexFit.tight,
                                child: Text(
                                  text['name'],
                                  overflow: TextOverflow.visible,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              vacunaEscogida = value!['name'];
                              idVacuna = value!['id'];
                              totalDosis = value!['totalDosis'];
                            });
                          },
                          hint: Text(vacunaEscogida),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Divider(color: AppColors.colorCREDBoy, thickness: 5, height: 30),
              Container(
                child: presentaWidget(),
              ),
              Divider(color: AppColors.colorCREDBoy, thickness: 5, height: 30),
              Container(
                margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () async {
                    bool answer = await addDose();

                    if (answer == true) {
                      Navigator.pop(context);
                    } else {
                      final snackBar = SnackBar(
                        content: Text(TranslateService.translate(
                            'createKidPage.denied_message')),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  child: Text(
                    TranslateService.translate('addVaccine.add'),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        AppColors.colorCREDBoy),
                    foregroundColor: MaterialStateProperty.all<Color>(
                        AppColors.font_primary),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationPage(),
    );
  }
}
