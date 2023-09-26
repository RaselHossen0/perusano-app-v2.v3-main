import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:perusano/components/bottomNavigation.dart';
import 'package:perusano/pages/sharedExperiences/add_experience.dart';
import 'package:perusano/pages/sharedExperiences/inside_shared_experiences.dart';
import 'package:perusano/services/fileManagement/sharedExperiences/shared_experiences_FM.dart';
import 'package:perusano/util/globalVariables.dart';

import '../../services/translateService.dart';
import '../../util/myColors.dart';

class SharedExperiencesPage extends StatefulWidget {
  @override
  State<SharedExperiencesPage> createState() => _SharedExperiencesPage();
}

List tags = [
  {
    'label': 'sharedExperiences.shareExperienceTag',
    'colour': MaterialStateProperty.all<Color>(Colors.purple[100]!),
    'icon': const Icon(
      Icons.share,
      color: Colors.black,
    ),
    'action': 'shareExperience'
  },
  {
    'label': 'sharedExperiences.faqTag',
    'colour': MaterialStateProperty.all<Color>(Colors.blue[100]!),
    'icon': const Icon(
      Icons.question_mark,
      color: Colors.black,
    ),
    'action': 'faq'
  },
  // {
  //   'label': 'sharedExperiences.suggestionsTag',
  //   'colour': MaterialStateProperty.all<Color>(Colors.green[100]!),
  //   'icon': const Icon(
  //     Icons.hexagon_outlined,
  //     color: Colors.black,
  //   ),
  //   'action': 'suggestions'
  // },
  // {
  //   'label': 'sharedExperiences.consult',
  //   'colour': MaterialStateProperty.all<Color>(Colors.orange[100]!),
  //   'icon': Icon(Icons.chat),
  //   'action': 'consult'
  // }
];

class _SharedExperiencesPage extends State<SharedExperiencesPage> {
  final SharedExperiencesFM _experiencesStorage = SharedExperiencesFM();

  bool showFaq = false;
  bool showSuggestions = false;
  bool showShareExperience = true;
  bool showConsult = false;
  Map experiences = {};
  List dataObt = [];
  List data = [];
  bool cargado = false;

  handleExperienceButton(String action) {
    switch (action) {
      case 'faq':
        setState(() {
          showFaq = true;
          showSuggestions = false;
          showShareExperience = false;
          showConsult = false;
        });
        break;
      case 'suggestions':
        setState(() {
          showFaq = false;
          showSuggestions = true;
          showShareExperience = false;
          showConsult = false;
        });
        break;
      case 'shareExperience':
        setState(() {
          showFaq = false;
          showSuggestions = false;
          showShareExperience = true;
          showConsult = false;
        });
        break;
      case 'consult':
        setState(() {
          showFaq = false;
          showSuggestions = false;
          showShareExperience = false;
          showConsult = true;
        });
        break;
      default:
    }
  }

  displayFaq() {
    if (showFaq) {
      return Container(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(20),
              alignment: Alignment.centerLeft,
              child: Text(
                TranslateService.translate('sharedExperiences.faqSubHeader'),
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              child: ExpansionTile(
                title: Text(
                  TranslateService.translate('sharedExperiences.faqTitle1'),
                ),
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.all(10),
                    child: Text(
                      TranslateService.translate('sharedExperiences.faqText1'),
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  )
                ],
              ),
            ),
            // Container(
            //   child: ExpansionTile(
            //     title: Text(
            //       TranslateService.translate('sharedExperiences.faqTitle2'),
            //     ),
            //     children: [
            //       Container(
            //         margin: const EdgeInsets.all(10),
            //         alignment: Alignment.centerLeft,
            //         child: Text(
            //           TranslateService.translate('sharedExperiences.faqText2'),
            //         ),
            //       )
            //     ],
            //   ),
            // ),
          ],
        ),
      );
    }
    return Container();
  }

  displaySuggestions() {
    if (showSuggestions) {
      return Container(
        child: const Text('suggestions'),
      );
    }
    return Container();
  }

  displayShareExperience() {
    if (showShareExperience) {
      return Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                      child: Image.asset(
                        '${GlobalVariables.logosAddress}grupos_de_apoyo_logo.png',
                        height: 100,
                        width: 100,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Text(
                        TranslateService.translate('sharedExperiences.title'),
                        style: const TextStyle(fontSize: 20),
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.all(20),
                child: Column(
                  // itemCount: experiences.length,
                  // itemBuilder: (context, index) {
                  children: [
                    Container(child: Builder(builder: (context) {
                      if (data.isNotEmpty && cargado) {
                        return InkWell(
                          child: Column(
                            children: data.map((experience) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            InsideExperiencePage(
                                              idExperienceChosen:
                                                  experience['idLocal'],
                                            )),
                                  );
                                },
                                child: Container(
                                  decoration: const BoxDecoration(
                                    border: Border(
                                        bottom:
                                            BorderSide(color: Colors.black45)),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.all(20),
                                        child: Image.asset(
                                          '${GlobalVariables.logosAddress}grupos_de_apoyo_logo.png',
                                          height: 70,
                                          width: 70,
                                        ),
                                      ),
                                      Container(
                                        child: Column(
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.all(5),
                                              child: Text(
                                                DateFormat(
                                                        'd MMMM yyyy',
                                                        GlobalVariables.language
                                                            .toLowerCase())
                                                    .format(DateTime.parse(
                                                        experience[
                                                            'post_date'])),
                                                style: const TextStyle(
                                                    color: Colors.black54),
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.all(5),
                                              child: SizedBox(
                                                width: 200,
                                                child: Text(
                                                  experience['title'],
                                                  style: const TextStyle(
                                                      fontSize: 20,
                                                      overflow: TextOverflow
                                                          .ellipsis),
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.all(5),
                                              child: Text(
                                                experience['author_name'][0]
                                                        .toUpperCase() +
                                                    experience['author_name']
                                                        .substring(1),
                                                style: TextStyle(
                                                    color:
                                                        Colors.deepOrange[400]),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.fromLTRB(
                                            10, 0, 0, 0),
                                        child:
                                            const Icon(Icons.arrow_forward_ios),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        );
                      }
                      return Container();
                    })),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
    return Container();
  }

  displayConsult() {
    if (showConsult) {
      return Container(
        child: const Text('consult'),
      );
    }
    return Container();
  }

  loadExperiences() async {
    dataObt = await _experiencesStorage.readFile();

    String experiencesFile = await DefaultAssetBundle.of(context)
        .loadString('assets/documents/sharedExperiences.json');
    List jsonResult = jsonDecode(experiencesFile);

    bool contains = false;
    for (var experience in dataObt) {
      if (jsonResult.toString().contains(experience.toString())) {
        contains = true;
      }
    }
    if ((!contains) || dataObt.isEmpty) {
      registerDefaultExperience(jsonResult);
    }

    setState(() {
      data = dataObt;
    });

    cargado = true;
  }

  registerDefaultExperience(experiences) async {
    for (var experience in experiences) {
      await _experiencesStorage.writeRegister(experience);
    }
    loadExperiences();
  }

  FutureOr refresh(value) {
    setState(() {
      loadExperiences();
    });
  }

  @override
  void initState() {
    loadExperiences();
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
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: tags
                    .map(
                      (tag) => Container(
                        margin: const EdgeInsets.fromLTRB(5, 10, 5, 10),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            fixedSize: MaterialStateProperty.all<Size>(
                                const Size.fromHeight(70)),
                            backgroundColor: tag['colour'],
                          ),
                          onPressed: () {
                            handleExperienceButton(tag['action']);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              tag['icon'],
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                TranslateService.translate(tag['label']),
                                maxLines: 2,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            displayFaq(),
            displaySuggestions(),
            displayShareExperience(),
            displayConsult(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationPage(),
      floatingActionButton: showShareExperience
          ? Container(
              height: 50,
              width: GlobalVariables.language == 'ES' ? 180 : 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddExperiencePage()),
                  ).then(refresh);
                },
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(Icons.add_circle),
                    Text(
                      TranslateService.translate('sharedExperiences.addButton'),
                    ),
                  ],
                ),
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      // floatingActionButton:
      //     ElevatedButton(onPressed: () {}, child: Text('hello there')),
    );
  }
}
