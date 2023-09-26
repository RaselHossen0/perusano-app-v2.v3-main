/*
* This class is not used but it could be useful to health center view
* */

import 'package:flutter/material.dart';
import 'package:perusano/util/globalVariables.dart';

import '../../components/lateralMenuCenter.dart';
import '../../services/apis/family/familyService.dart';
import '../../services/translateService.dart';
import '../../util/internVariables.dart';
import '../../util/myColors.dart';
import '../family/kids/chooseKidPage.dart';

class ChooseFamilyCenterPage extends StatefulWidget {
  @override
  State<ChooseFamilyCenterPage> createState() => _ChooseFamilyCenterPage();
}

class _ChooseFamilyCenterPage extends State<ChooseFamilyCenterPage> {
  List data = [];
  List dataObt = [];

  loadFamilies() async {
    dataObt = await FamilyService.getFamilies();
    setState(() {
      data = dataObt;
    });
  }

  @override
  initState() {
    super.initState();
    loadFamilies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text(
              'CRED',
              style: TextStyle(color: Colors.black),
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
      endDrawer: LateralMenuCenter(),
      body: SingleChildScrollView(
          child: Container(
        margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Text(
                TranslateService.translate('chooseFamilyCenterPage.title'),
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              child: Builder(
                builder: (context) {
                  if (data.isNotEmpty) {
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
                              InternVariables.family['id'] = text['id'];
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChooseKidPage(
                                          idFamily: text['id'],
                                        )),
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
                                            text['user']['user'].toString(),
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
                                                  text['health_center']['name']
                                                      .toString(),
                                                  style: const TextStyle(
                                                      color: Colors.black),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ))
                              ],
                            ),
                          ));
                    }).toList());
                  } else {
                    return Container(
                      child: const Center(child: CircularProgressIndicator()),
                      margin: const EdgeInsets.all(20),
                    );
                  }
                },
              ),
            )
          ],
        ),
      )),
    );
  }
}
