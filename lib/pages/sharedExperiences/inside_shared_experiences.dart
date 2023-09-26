import 'package:flutter/material.dart';
import 'package:perusano/services/apis/sharedExperiences/shared_experiences_service.dart';
import 'package:perusano/services/fileManagement/sharedExperiences/shared_experiences_FM.dart';

import '../../services/translateService.dart';
import '../../util/globalVariables.dart';
import '../../util/myColors.dart';

class InsideExperiencePage extends StatefulWidget {
  int idExperienceChosen;
  InsideExperiencePage({required this.idExperienceChosen});
  @override
  State<InsideExperiencePage> createState() =>
      _InsideExperiencePage(idExperienceChosen: idExperienceChosen);
}

class _InsideExperiencePage extends State<InsideExperiencePage> {
  final SharedExperiencesFM _experienceStorage = SharedExperiencesFM();
  int idExperienceChosen;
  Map dataObt = {};
  Map data = {};

  List comments = [];

  final isConnected = GlobalVariables.isConnected();

  _InsideExperiencePage({required this.idExperienceChosen});

  loadExperience(int id) async {
    // Get total information of the recipe from local storage or, if exist a connection, from network database.
    if (await isConnected) {
      dataObt = await SharedExperiencesService()
          .getSharedExperienceById(id.toString());
    } else {
      dataObt = await _experienceStorage.findSharedExperienceById(id);
    }

    setState(() {
      data = dataObt;
      comments = data['comments'];
    });
  }

  @override
  void initState() {
    loadExperience(idExperienceChosen);
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
      body: Container(
        //color: Colors.red,
        padding: const EdgeInsets.all(20),
        child: Builder(
          builder: (context) {
            if (data.isNotEmpty) {
              return ListView(
                shrinkWrap: true,
                children: [
                  Container(
                    child: Text(
                      data['title'].toString(),
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Divider(
                      color: AppColors.colorShareExpeirence,
                      thickness: 5,
                      height: 30),
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(20)),
                    child: Text(data['post_content']),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                    child: Text(
                      '${TranslateService.translate('insideSharedExperience.experienceBy')}: ${data['author_name'][0].toUpperCase() + data['author_name'].substring(1)}',
                      // style: TextStyle(color: Colors.deepOrange[400]),
                    ),
                  ),
                  Container(
                    child: Column(children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(10, 20, 0, 10),
                        child: Text(
                          TranslateService.translate(
                              'insideRecipePage.comments'),
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Column(
                          children: comments.map((text) {
                        return Container(
                          padding: const EdgeInsets.fromLTRB(20, 10, 30, 0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    child: const Icon(Icons.person),
                                  ),
                                  Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                    child: Text(
                                        '${text['author']['name']} ${text['author']['lastname']}'),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      child: Container(
                                    margin: const EdgeInsets.fromLTRB(
                                        30, 10, 0, 10),
                                    child: Text(text['comment']),
                                  ))
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(text['total_likes'].toString()),
                                  const Icon(Icons.favorite_outline)
                                ],
                              ),
                              const Divider(),
                            ],
                          ),
                        );
                      }).toList()),
                    ]),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 10, 30, 0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              child: const Icon(Icons.person),
                            ),
                            Container(
                              margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child: const Text('user propio'),
                            )
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(30, 10, 0, 10),
                          child: Column(
                            children: [
                              TextFormField(
                                controller: null,
                                autocorrect: true,
                                maxLines: null,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              ElevatedButton(
                                  onPressed: null,
                                  child: Text(TranslateService.translate(
                                      'insideRecipePage.add_comment')))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else {
              return Container(
                margin: const EdgeInsets.all(20),
                child: const Center(child: CircularProgressIndicator()),
              );
            }
          },
        ),
      ),
      // body: SingleChildScrollView(),
    );
  }
}
