import 'package:flutter/material.dart';

import '../../../services/fileManagement/family/kidFM.dart';
import '../../../services/translateService.dart';
import '../../../util/globalVariables.dart';
import '../../../util/internVariables.dart';
import '../../../util/myColors.dart';
import '../../cred/cred_principal_page.dart';
import 'create_kid_page.dart';

class ChooseKidPage extends StatefulWidget {
  int idFamily;

  ChooseKidPage({required this.idFamily});

  @override
  State<ChooseKidPage> createState() => _ChooseKidPage(idFamily: idFamily);
}

class _ChooseKidPage extends State<ChooseKidPage> {
  int idFamily;

  final KidFM storage = KidFM();

  _ChooseKidPage({required this.idFamily});

  List data = [];
  List dataObt = [];

  bool cargado = false;

  // Loads the data from local storage
  loadKids() async {
    dataObt = await storage.readFile();

    setState(() {
      data = dataObt;
    });

    cargado = true;
  }

  actualizar() {
    setState(() {
      loadKids();
    });
  }

  @override
  initState() {
    super.initState();
    loadKids();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              TranslateService.translate('homePage.cred'),
              style: const TextStyle(color: Colors.black),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CreateKidPage(idFamily)),
                ).then((value) => actualizar());
              },
              color: Colors.black,
            )
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
          child: Container(
        margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Text(
                TranslateService.translate('chooseKidPage.title'),
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Container(child: Builder(
              builder: (context) {
                if (data.isNotEmpty && cargado) {
                  return Column(
                      children: data.map((text) {
                    return Container(
                        padding: const EdgeInsets.fromLTRB(20, 10, 30, 0),
                        child: OutlinedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  AppColors.primary)),
                          onPressed: () async {
                            //bool isConnected = await GlobalVariables.isConnected();

                            InternVariables.kid['id'] = text['id'];
                            InternVariables.kid['idLocal'] = text['idLocal'];
                            InternVariables.kid['names'] = text['names'];
                            InternVariables.kid['birthday'] = text['dateRaw'];
                            InternVariables.kid['gender'] = text['gender'];
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CredPrincipalPage(
                                      idKid: text['idLocal'])),
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
                                  ),
                                ),
                              ),
                              Flexible(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            15, 0, 0, 0),
                                        child: Text(
                                          text['names'],
                                          style: const TextStyle(
                                              color: Colors.black),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            15, 0, 0, 0),
                                        child: Row(
                                          children: [
                                            Container(
                                              child: Text(
                                                '${text['lastname']} ',
                                                style: const TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                            Container(
                                              child: Text(
                                                text['mother_lastname'],
                                                style: const TextStyle(
                                                    color: Colors.black),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ))
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
                                'chooseKidPage.empty')),
                            Text(TranslateService.translate(
                                'chooseKidPage.message'))
                          ],
                        ),
                      ),
                    ),
                  );
                }
              },
            ))
          ],
        ),
      )),
    );
  }
}
