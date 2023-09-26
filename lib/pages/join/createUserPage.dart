import 'package:flutter/material.dart';
import 'package:perusano/util/myColors.dart';

import '../../services/apis/family/familyRegisterCenter.dart';
import '../../services/translateService.dart';

class CreateUserPage extends StatefulWidget {
  @override
  State<CreateUserPage> createState() => _CreateUserPage();
}

class _CreateUserPage extends State<CreateUserPage> {
  final TextEditingController userController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  //final TextEditingController repeatPassController = TextEditingController();
  bool isHealthPerson = false;
  late int healthCenter;
  late String urlPhoto;
  final _formKey = GlobalKey<FormState>();

  List centros = [];
  String centroEscogido =
      TranslateService.translate('createUserPage.choose_center');
  int idCentro = 0;
  late Map dataUser;

  // Add the user to the network database
  Future<bool> addUser() async {
    dataUser = await FamilyRegisterCenter().addUser(userController.text,
        passController.text, isHealthPerson, 1, 'urlPhoto');
    print(dataUser);
    if (dataUser['id'] > 0) {
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
                TranslateService.translate('createUserPage.title'),
                style: TextStyle(color: Colors.black),
              ),
              /*Spacer(),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {},
              color: Colors.black,
            )*/
            ],
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: Container(
          margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  child: Text(
                    TranslateService.translate('createUserPage.title'),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Container(
                            padding: EdgeInsets.fromLTRB(10, 20, 30, 10),
                            child: TextFormField(
                              validator: (value) {
                                print(value);
                                if (value == '') {
                                  return TranslateService.translate(
                                      'addAnemiaCheck.validateText');
                                }
                              },
                              controller: userController,
                              decoration: InputDecoration(
                                icon: Icon(Icons.person),
                                label: Text(TranslateService.translate(
                                    'createUserPage.username')),
                              ),
                            )),
                        Container(
                            padding: EdgeInsets.fromLTRB(10, 20, 30, 10),
                            child: TextFormField(
                              validator: (value) {
                                if (value == '') {
                                  return TranslateService.translate(
                                      'addAnemiaCheck.validateText');
                                }
                              },
                              controller: passController,
                              decoration: InputDecoration(
                                icon: Icon(Icons.lock),
                                label: Text(TranslateService.translate(
                                    'createUserPage.password')),
                              ),
                            )),
                        /*Container(
                          padding: EdgeInsets.fromLTRB(10, 20, 30, 10),
                          child: TextFormField(
                            validator: (value) {
                              if (value == '') {
                                return TranslateService.translate('addAnemiaCheck.validateText');
                              }
                            },
                            controller: repeatPassController,
                            decoration: InputDecoration(
                              icon: Icon(Icons.lock),
                              label: Text(TranslateService.translate('createUserPage.repeat_password')),
                            ),
                          )

                      ),*/
                      ],
                    )),
                /*Container(
                child: Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  columnWidths: {
                    0: FlexColumnWidth(1),
                    1: FlexColumnWidth(1),
                  },
                  children: [
                    TableRow(
                        children: [
                          Text(
                            '${TranslateService.translate('createUserPage.healt_center')}',
                            style: TextStyle(fontSize: 18),
                          ),
                          FittedBox(
                            fit: BoxFit.fitWidth,
                            child:  DropdownButton(
                              items: centros.map((text){
                                return DropdownMenuItem(
                                  value: {'id' : text['id'], 'value' : text['value']},
                                  child: Text(text['value']),
                                );
                              }).toList(),
                              onChanged: (value){
                                setState(() {
                                  centroEscogido = value!['value'];
                                  idCentro = value!['id'];
                                });
                              },
                              hint: Text(centroEscogido, style: TextStyle(fontSize: 16),),
                            ),
                          )
                        ]
                    ),
                  ],
                ),
              ),*/
                Container(
                  margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        bool answer = await addUser();

                        if (answer == true) {
                          final snackBar = SnackBar(
                            content: Text(TranslateService.translate(
                                'createUserPage.confirmation_message')),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          Navigator.pop(context);
                        } else {
                          final snackBar = SnackBar(
                            content: Text(TranslateService.translate(
                                'createUserPage.denied_message')),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      }
                    },
                    child: Text(
                      TranslateService.translate('createUserPage.add_user'),
                    ),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(AppColors.primary),
                      foregroundColor: MaterialStateProperty.all<Color>(
                          AppColors.font_primary),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
