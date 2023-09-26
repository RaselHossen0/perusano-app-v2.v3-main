import 'package:flutter/material.dart';
import 'package:perusano/services/apis/cred/credService.dart';
import 'package:perusano/services/synchronization/download.dart';
import 'package:perusano/util/internVariables.dart';

import '../../../components/lateralMenu.dart';

import '../../../services/fileManagement/family/familyMemberFM.dart';
import '../../../services/synchronization/upload.dart';
import '../../../services/translateService.dart';
import '../../../util/globalVariables.dart';
import '../../../util/myColors.dart';
import 'addFamilyMember.dart';
import '../../home_page.dart';

class ChooseFamilyMemberPage extends StatefulWidget {
  int idFamily;

  ChooseFamilyMemberPage({required this.idFamily});

  @override
  State<ChooseFamilyMemberPage> createState() =>
      _ChooseFamilyMemberPage(idFamily: idFamily);
}

class _ChooseFamilyMemberPage extends State<ChooseFamilyMemberPage> {
  int idFamily;
  final FamilyMemberFM storage = FamilyMemberFM();

  bool cargado = false;

  _ChooseFamilyMemberPage({required this.idFamily});

  List data = [];
  List dataObt = [];

  // Checks network connection and execute synchronization
  updateData() async {
    bool answer = await GlobalVariables.isConnected();

    try {
      await CredService().getIronSupplementTypes();
      if (answer) {
        await UploadService().uploadData();
        await DownloadService().downloadSelectable();
      }
    } catch (e) {}
  }

  // Loads the data from local storage
  loadFamilyMembers() async {
    await updateData();

    dataObt = await storage.readFile();

    setState(() {
      data = dataObt;
    });

    setState(() {
      cargado = true;
    });
  }

  actualizar() {
    setState(() {
      loadFamilyMembers();
    });
  }

  @override
  initState() {
    super.initState();
    loadFamilyMembers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              TranslateService.translate('chooseFamilyMember.title'),
              style: const TextStyle(color: Colors.black),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      endDrawer: LateralMenu(),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: Text(
                  TranslateService.translate('chooseFamilyMember.header'),
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                child: Builder(
                  // future: data as Future<List>,
                  builder: (context) {
                    if (data.isNotEmpty && cargado) {
                      return Column(
                          children: data.map((text) {
                        return Container(
                            padding: const EdgeInsets.fromLTRB(20, 10, 30, 0),
                            child: OutlinedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          AppColors.primary)),
                              onPressed: () {
                                InternVariables.userName = text['name'];
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomePage()),
                                );
                              },
                              child: Row(
                                children: [
                                  Flexible(
                                    flex: 1,
                                    child: FittedBox(
                                      fit: BoxFit.contain,
                                      child: Image.asset(
                                        '${GlobalVariables.publicAddress}${text['url_photo']}',
                                        width: 150,
                                        height: 150,
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 2,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      15, 5, 0, 5),
                                              child: Text(
                                                text['name'][0].toUpperCase() +
                                                    text['name'].substring(1),
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 20),
                                              ),
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      10, 5, 0, 0),
                                              child: Text(
                                                '(${text['relationship']})',
                                                style: TextStyle(
                                                    color: Colors.grey[200]),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          margin: const EdgeInsets.fromLTRB(
                                              0, 20, 0, 0),
                                          padding: EdgeInsets.all(7),
                                          child: text['is_caregiver']
                                              ? Text(
                                                  TranslateService.translate(
                                                      'chooseFamilyMember.primary'),
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 15),
                                                  textAlign: TextAlign.right,
                                                )
                                              : Text(
                                                  TranslateService.translate(
                                                      'chooseFamilyMember.notPrimary'),
                                                  style: const TextStyle(
                                                      color: Colors.white70,
                                                      fontSize: 15),
                                                  textAlign: TextAlign.right,
                                                ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ));
                      }).toList());
                    } else if (!cargado) {
                      return Container(
                        margin: const EdgeInsets.all(20),
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    } else {
                      return Container(
                        margin: const EdgeInsets.all(20),
                        child: Center(
                          child: Container(
                            child: Column(
                              children: [
                                Text(TranslateService.translate(
                                    'chooseFamilyMember.empty')),
                                Text(TranslateService.translate(
                                    'chooseFamilyMember.message')),
                                Container(
                                  width: 215,
                                  margin:
                                      const EdgeInsets.fromLTRB(25, 5, 25, 0),
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              AppColors.colorAddButtons),
                                      foregroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.white),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            TranslateService.translate(
                                                'chooseFamilyMember.register_button'),
                                            style:
                                                const TextStyle(fontSize: 18),
                                          ),
                                        ),
                                        const Spacer(),
                                        const Icon(Icons.person_add)
                                      ],
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AddFamilyMember(idFamily)),
                                      ).then((value) => actualizar());
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: data.isNotEmpty
          ? Container(
              width: 215,
              margin: const EdgeInsets.fromLTRB(25, 5, 25, 0),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      AppColors.colorAddButtons),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      TranslateService.translate(
                          'chooseFamilyMember.register_button'),
                      style: const TextStyle(fontSize: 18),
                    ),
                    const Spacer(),
                    const Icon(Icons.person_add)
                  ],
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddFamilyMember(idFamily)),
                  ).then((value) => actualizar());
                },
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
