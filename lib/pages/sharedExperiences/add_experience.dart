import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:perusano/services/fileManagement/sharedExperiences/shared_experiences_FM.dart';
import 'package:perusano/util/class/sharedExperiences/shared_experience_class.dart';
import 'package:perusano/util/internVariables.dart';
import 'package:perusano/util/myColors.dart';

import '../../services/translateService.dart';

class AddExperiencePage extends StatefulWidget {
  @override
  State<AddExperiencePage> createState() => _AddExperiencePage();
}

class _AddExperiencePage extends State<AddExperiencePage> {
  final SharedExperiencesFM _experienceStorage = SharedExperiencesFM();

  final _formKeySharedExperience = GlobalKey<FormState>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  Future<bool> addSharedExperience() async {
    try {
      SharedExperienceRegister registerExperience = SharedExperienceRegister(
          0,
          titleController.text,
          InternVariables.userName,
          InternVariables.idUser,
          contentController.text,
          DateTime.now().toString(), []);

      Map registerJson = registerExperience.toJson();
      Map answer = await _experienceStorage.writeRegister(registerJson);
    } catch (e) {
      log(e.toString());
      return false;
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          TranslateService.translate('sharedExperiences.title'),
        ),
        backgroundColor: AppColors.colorShareExpeirence,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKeySharedExperience,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: titleController,
                  validator: (value) {
                    if (value == '') {
                      return TranslateService.translate(
                          'addSharedExperience.validate');
                    }
                  },
                  decoration: InputDecoration(
                    label: Text(
                      TranslateService.translate(
                          'addSharedExperience.titleInput'),
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                child: TextFormField(
                  maxLines: 20,
                  minLines: 7,
                  controller: contentController,
                  validator: (value) {
                    if (value == '') {
                      return TranslateService.translate(
                          'addSharedExperience.validate');
                    }
                  },
                  decoration: InputDecoration(
                    label: Text(
                      TranslateService.translate(
                          'addSharedExperience.contentInput'),
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          AppColors.colorShareExpeirence)),
                  onPressed: () async {
                    bool answer = await addSharedExperience();
                    if (answer == true) {
                      final snackBar = SnackBar(
                        content: Text(TranslateService.translate(
                            'addSharedExperience.confirmation_message')),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      Navigator.pop(context);
                    } else {
                      final snackBar = SnackBar(
                        content: Text(TranslateService.translate(
                            'addSharedExperience.denied_message')),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  child: Text(TranslateService.translate(
                      'addSharedExperience.addButton')))
            ],
          ),
        ),
      ),
    );
  }
}
