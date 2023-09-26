import 'package:flutter/material.dart';
import 'package:perusano/util/class/family/familyMember/familyMemberClass.dart';
import 'package:perusano/util/myColors.dart';
import 'package:intl/intl.dart';

import '../../../services/apis/family/familyRegisterCenter.dart';
import '../../../services/fileManagement/family/familyMemberFM.dart';
import '../../../services/translateService.dart';
import '../../../util/globalVariables.dart';

enum Generos { M, F }

enum Respuesta { Y, N }

class AddFamilyMember extends StatefulWidget {
  int idFamily;

  AddFamilyMember(this.idFamily);

  @override
  State<AddFamilyMember> createState() => _AddFamilyMember(idFamily);
}

class _AddFamilyMember extends State<AddFamilyMember> {
  int idFamily;

  final FamilyMemberFM storage = FamilyMemberFM();

  final _formKey = GlobalKey<FormState>();
  /*final _formKeyApellidoPadre = GlobalKey<FormState>();
  final _formKeyApellidoMadre = GlobalKey<FormState>();
  final _formKeyPeso = GlobalKey<FormState>();
  final _formKeyAltura = GlobalKey<FormState>();
  final _formKeyAfiliado = GlobalKey<FormState>();*/

  _AddFamilyMember(this.idFamily);

  final TextEditingController namesController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController motherLastNameController =
      TextEditingController();
  final TextEditingController dniController = TextEditingController();
  final TextEditingController relationshipController = TextEditingController();
  bool isHealthPerson = false;
  late int healthCenter;
  String gender = 'F';
  String isCaregiver = 'Y';

  late Map dataUser;
  List relationships = [
    {
      'id': 0,
      'value': 'createFamilyMember.father',
      'gender': 'M',
    },
    {
      'id': 1,
      'value': 'createFamilyMember.mother',
      'gender': 'F',
    },
    {
      'id': 2,
      'value': 'createFamilyMember.grandmother',
      'gender': 'F',
    },
    {
      'id': 3,
      'value': 'createFamilyMember.grandfather',
      'gender': 'M',
    },
    {
      'id': 4,
      'value': 'createFamilyMember.aunt',
      'gender': 'F',
    },
    {
      'id': 5,
      'value': 'createFamilyMember.uncle',
      'gender': 'M',
    },
    {
      'id': 6,
      'value': 'createFamilyMember.other',
      'gender': 'M',
    },
  ];
  String selectedRelationship =
      TranslateService.translate('createFamilyMember.mother');
  int relationshipId = 1;
  bool showOtherRelationshipOption = false;

  otherRelationshipOption() {
    if (showOtherRelationshipOption) {
      return Container(
        child: TextFormField(
          validator: (value) {
            if (value == '') {
              return TranslateService.translate(
                  'createFamilyMember.validateText');
            }
          },
          controller: relationshipController,
          decoration: const InputDecoration(
            icon: Icon(Icons.perm_identity),
          ),
        ),
      );
    }
    return Container();
  }

  //This method add the register in local Storage and, if is connected to the network, add the register into network data base
  Future<bool> addFamilyMember() async {
    Map localAnswer = {};
    Map globalAnswer = {};
    String urlPhoto;
    switch (relationshipId) {
      case 0:
        // father
        urlPhoto = 'padre_logo.png';
        break;
      case 1:
        // mother
        urlPhoto = 'madre_logo.png';
        break;
      case 2:
        // grandma
        urlPhoto = 'abuela_logo.png';
        break;
      case 3:
        // grandpa
        urlPhoto = 'abuelo_logo.png';
        break;
      case 4:
        // aunt
        urlPhoto = 'madre_logo.png';
        break;
      case 5:
        // uncle
        urlPhoto = 'padre_logo.png';
        break;
      default:
        // other
        urlPhoto = gender == 'M' ? 'padre_logo.png' : 'madre_logo.png';
        selectedRelationship = relationshipController.text;
    }
    bool isCaregiverEscogido = isCaregiver == 'Y' ? true : false;

    FamilyMemberRegister register = FamilyMemberRegister(
        0,
        dniController.text,
        namesController.text,
        lastNameController.text,
        motherLastNameController.text,
        selectedRelationship,
        '',
        '',
        '',
        '',
        isCaregiverEscogido,
        urlPhoto,
        idFamily,
        false,
        false);

    Map registerJson = register.toJson();

    localAnswer = await storage.writeRegister(registerJson);

    bool isConnected = await GlobalVariables.isConnected();

    if (isConnected) {
      globalAnswer = await FamilyRegisterCenter().addFamilyMember(
          dniController.text,
          namesController.text,
          lastNameController.text,
          motherLastNameController.text,
          selectedRelationship,
          '',
          '',
          '',
          '',
          isCaregiverEscogido,
          urlPhoto,
          idFamily);
      await storage.updateIdRegister(
          localAnswer['idLocal'], globalAnswer['id']);
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
          title: Text(
            TranslateService.translate('createFamilyMember.title'),
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.black),
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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                          child: TextFormField(
                            validator: (value) {
                              if (value == '') {
                                return TranslateService.translate(
                                    'createFamilyMember.validateText');
                              }
                            },
                            controller: namesController,
                            decoration: InputDecoration(
                              icon: const Icon(Icons.drive_file_rename_outline),
                              label: Text(TranslateService.translate(
                                  'createFamilyMember.names')),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                          child: TextFormField(
                            validator: (value) {
                              if (value == '') {
                                return TranslateService.translate(
                                    'createFamilyMember.validateText');
                              }
                            },
                            controller: lastNameController,
                            decoration: InputDecoration(
                              icon: const Icon(Icons.drive_file_rename_outline),
                              label: Text(TranslateService.translate(
                                  'createFamilyMember.last_name')),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                          child: TextFormField(
                            validator: (value) {
                              if (value == '') {
                                return TranslateService.translate(
                                    'createFamilyMember.validateText');
                              }
                            },
                            controller: motherLastNameController,
                            decoration: InputDecoration(
                              icon: const Icon(Icons.drive_file_rename_outline),
                              label: Text(TranslateService.translate(
                                  'createFamilyMember.mother_last_name')),
                            ),
                          ),
                        ),
                        // Container(
                        //   margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                        //   child: TextFormField(
                        //     validator: (value) {
                        //       if (value == '') {
                        //         return TranslateService.translate(
                        //             'createFamilyMember.validateText');
                        //       }
                        //     },
                        //     controller: dniController,
                        //     decoration: InputDecoration(
                        //       icon: Icon(Icons.perm_identity),
                        //       label: Text(TranslateService.translate(
                        //           'createFamilyMember.dni')),
                        //     ),
                        //   ),
                        // ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Text(TranslateService.translate(
                                    'createFamilyMember.relationship')),
                              ),
                              FittedBox(
                                fit: BoxFit.fitWidth,
                                child: DropdownButton(
                                  items: relationships.map((text) {
                                    return DropdownMenuItem(
                                      value: {
                                        'id': text['id'],
                                        'value': text['value'],
                                        'gender': text['gender']
                                      },
                                      child: Text(TranslateService.translate(
                                          text['value'])),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedRelationship =
                                          TranslateService.translate(
                                              value!['value']);
                                      relationshipId = value['id'];
                                      gender = value['gender'];
                                      if (relationshipId == 6) {
                                        showOtherRelationshipOption = true;
                                      } else {
                                        showOtherRelationshipOption = false;
                                      }
                                    });
                                  },
                                  hint: Text(
                                    selectedRelationship,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        otherRelationshipOption(),
                      ],
                    ),
                  ),
                ),
                Divider(color: AppColors.primary, thickness: 5, height: 30),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 20, 30, 10),
                  child: Row(
                    children: [
                      Container(
                        child: Text(
                          TranslateService.translate(
                              'createFamilyMember.gender'),
                          style: const TextStyle(fontSize: 16),
                        ),
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
                                '${GlobalVariables.publicAddress}padre_logo.png'),
                            subtitle: Text(TranslateService.translate(
                                'createFamilyMember.male')),
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
                                '${GlobalVariables.publicAddress}madre_logo.png'),
                            subtitle: Text(TranslateService.translate(
                                'createFamilyMember.female')),
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
                  padding: const EdgeInsets.fromLTRB(10, 20, 30, 10),
                  child: Row(
                    children: [
                      Container(
                        child: Text(
                          TranslateService.translate(
                              'createFamilyMember.isCaregiver'),
                          style: const TextStyle(fontSize: 16),
                        ),
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
                            title: Text(TranslateService.translate(
                                'createFamilyMember.yes')),
                            value: "Y",
                            groupValue: isCaregiver,
                            onChanged: (value) {
                              setState(() {
                                isCaregiver = value.toString();
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: RadioListTile(
                            title: Text(TranslateService.translate(
                                'createFamilyMember.no')),
                            value: "N",
                            groupValue: isCaregiver,
                            onChanged: (value) {
                              setState(() {
                                isCaregiver = value.toString();
                              });
                            },
                          ),
                        ),
                      ],
                    )),
                Divider(color: AppColors.primary, thickness: 5, height: 30),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        bool answer = await addFamilyMember();

                        if (answer == true) {
                          final snackBar = SnackBar(
                            content: Text(TranslateService.translate(
                                'createFamilyMember.confirmationMessage')),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          Navigator.pop(context);
                        } else {
                          final snackBar = SnackBar(
                            content: Text(TranslateService.translate(
                                'createFamilyMember.deniedMessage')),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(AppColors.primary),
                      foregroundColor: MaterialStateProperty.all<Color>(
                          AppColors.font_primary),
                    ),
                    child: Text(
                      TranslateService.translate(
                          'createFamilyMember.addFamilyMember'),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
