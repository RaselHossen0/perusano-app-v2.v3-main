import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:perusano/util/class/recipes/recipeClass.dart';
import 'package:video_player/video_player.dart';

import '../../services/apis/recipe/recipesService.dart';
import '../../services/fileManagement/recipes/recipeFM.dart';
import '../../services/translateService.dart';
import '../../util/globalVariables.dart';
import '../../util/internVariables.dart';
import '../../util/myColors.dart';

class InsideRecipesPage extends StatefulWidget {
  int idRecipeChoosen;
  InsideRecipesPage({super.key, required this.idRecipeChoosen});

  @override
  State<InsideRecipesPage> createState() =>
      _InsideRecipesPage(idRecipeChoosen: idRecipeChoosen);
}

class _InsideRecipesPage extends State<InsideRecipesPage>
    with TickerProviderStateMixin {
  late TabController recipeTabController = TabController(
    initialIndex: 0,
    length: 3,
    vsync: this,
  );

  int idRecipeChoosen;
  Map dataObt = {};
  Map data = {};

  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  bool hasVideo = false;

  List ingredientes = [];
  List preparacion = [];
  List comentarios = [];
  bool showalternos = false;
  List ingredientesModificado = [];
  List showListaShowAlternos = [];
  List preparacionModificado = [];

  _InsideRecipesPage({required this.idRecipeChoosen});

  final isConnected = GlobalVariables.isConnected();
  final RecipeFM _recipeStorage = RecipeFM();
  bool canDownload = false;
  bool isDownloading = false;
  bool isDownloaded = false;

  bool favourite = false;

  // Get total information of the recipe from local storage or, if exist a connection, from network database.
  loadRecipe(int id) async {
    if (await isConnected) {
      dataObt = await RecipesService().getRecipeById(id.toString());
    } else {
      dataObt = await _recipeStorage.findRecipeById(id);
    }
    bool _canDownload = await canDownloadF(dataObt['id']);

    setState(() {
      data = dataObt;
      ingredientes = data['ingredients'];
      preparacion = data['preparation'];
      comentarios = data['comments'];
      canDownload = _canDownload;
      favourite = data['is_liked_by_me'];
    });
    for (var i = 0; i < ingredientes.length; i++) {
      Map answer = {
        "id": ingredientes[i]['id'],
        "subId": i,
        "name": ingredientes[i]['name'],
        "amount": ingredientes[i]['amount'],
        "unit": ingredientes[i]['unit'],
        "alternatives": ingredientes[i]['alternatives'],
      };
      setState(() {
        ingredientesModificado.add(answer);
      });
      showListaShowAlternos.add(false);
    }
    for (var i = 0; i < preparacion.length; i++) {
      Map answer = {
        "id": preparacion[i]['id'],
        "subId": i + 1,
        "description": preparacion[i]['description'],
      };
      setState(() {
        preparacionModificado.add(answer);
      });
    }
    existVideo(idRecipeChoosen);
  }

  // Allows download the recipe if exist a connection
  Future<bool> canDownloadF(int id) async {
    if (await isConnected) {
      Map recipe = await _recipeStorage.findRecipeByRealId(id);
      return recipe.isEmpty && id != 0;
    } else {
      return false;
    }
  }

  // Get the recipe video from local storage or, if exist a connection, from network database.
  Future<bool> obtenerVideo(int id) async {
    try {
      if (await isConnected) {
        Map dataTemp = await RecipesService().getRecipeVideoById(id);
        _controller = VideoPlayerController.network(
            '${GlobalVariables.endpoint}/' + dataTemp['path']);
      } else {
        _controller = VideoPlayerController.asset(data['url_video']);
      }
      _initializeVideoPlayerFuture = _controller.initialize();
      return true;
    } catch (e) {
      _controller = Null as VideoPlayerController;
      return false;
    }
    //return Image.network(GlobalVariables.endpoint +'/'+ dataTemp['path'], height: 200, width: 300,);
  }

  // Set a flag which indicate if the recipe has video
  Future<void> existVideo(int id) async {
    bool result = await obtenerVideo(id);
    setState(() {
      hasVideo = result;
    });
  }

  Widget displayVideo() {
    if (_controller.dataSource.contains('videoreceta.mp4')) {
      return Image.asset(data['url_photo']);
    }
    if (hasVideo) {
      return SizedBox(
        //color: Colors.red,
        height: 250,
        child: Column(
          children: [
            Flexible(
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                // Usa el Widget VideoPlayer para mostrar el vídeo
                child: VideoPlayer(_controller),
              ),
            ),
            Container(
                child: VideoProgressIndicator(_controller,
                    allowScrubbing: true,
                    colors: const VideoProgressColors(
                      backgroundColor: Colors.redAccent,
                      playedColor: Colors.green,
                      bufferedColor: Colors.purple,
                    ))),
            Container(
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        if (_controller.value.isPlaying) {
                          _controller.pause();
                        } else {
                          _controller.play();
                        }
                        setState(() {});
                      },
                      icon: Icon(_controller.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow)),
                  IconButton(
                      onPressed: () {
                        _controller.seekTo(const Duration(seconds: 0));
                        _controller.pause();
                        setState(() {});
                      },
                      icon: const Icon(Icons.stop))
                ],
              ),
            ),
          ],
        ),
      );
    }
    return Container();
  }

  @override
  initState() {
    loadRecipe(idRecipeChoosen);

    //_controller = VideoPlayerController.asset('assets/images/public/videoreceta.mp4');
    //_initializeVideoPlayerFuture = _controller.initialize();

    super.initState();
  }

  @override
  void dispose() {
    // Asegúrate de hacer dispose del VideoPlayerController para liberar los recursos
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              TranslateService.translate('homePage.recipes'),
              style: const TextStyle(color: Colors.black),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {},
              color: Colors.black,
            )
          ],
        ),
        backgroundColor: AppColors.colorRecipes,
        elevation: 0,
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
                    Visibility(
                      visible: canDownload,
                      child: ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            isDownloading = true;
                          });
                          final imagePath =
                              'assets/images/public/recetas_logo.png';
                          // await RecipesService()
                          // .downloadRecipeImage(idRecipeChoosen);
                          final videoPath = await RecipesService()
                              .downloadRecipeVideo(idRecipeChoosen);
                          RecipeRegister register = RecipeRegister(
                              data["id"],
                              data["title"],
                              data["total_likes"],
                              data["author_name"],
                              InternVariables.idUser,
                              data["preparation"],
                              data["comments"],
                              data["ingredients"],
                              data["status"],
                              data["statusId"],
                              data["age_tag"],
                              false,
                              imagePath,
                              videoPath);
                          Map registerJson = register.toJson();
                          await _recipeStorage.writeRegister(registerJson);
                          setState(() {
                            isDownloading = false;
                            canDownload = false;
                          });
                          final snackBar = SnackBar(
                            content: Text(TranslateService.translate(
                                'recipePage.downloaded')),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              AppColors.colorButtonRecipes),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                        ),
                        child: isDownloading
                            ? const SizedBox(
                                height: 20.0,
                                width: 20.0,
                                child: CircularProgressIndicator(),
                              )
                            : Text(
                                TranslateService.translate(
                                    'recipePage.download'),
                              ),
                      ),
                    ),
                    displayVideo(),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    data['title'].toString(),
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                favourite = !favourite;
                              });
                            },
                            icon: favourite
                                ? const Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                  )
                                : const Icon(
                                    Icons.favorite,
                                  ),
                          )
                        ],
                      ),
                    ),
                    Divider(
                        color: AppColors.colorRecipes,
                        thickness: 5,
                        height: 30),
                    SizedBox(
                      width: 400,
                      child: TabBar(
                        // dividerColor: Colors.black,
                        indicatorColor: AppColors.colorRecipes,
                        indicator: BoxDecoration(
                          color: AppColors.colorRecipes,
                          // border: Border.all(color: Colors.black)
                        ),
                        labelPadding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                        tabs: [
                          Container(
                            child: Text(
                              TranslateService.translate(
                                  'insideRecipePage.ingredients'),
                            ),
                          ),
                          Container(
                            child: Text(TranslateService.translate(
                                'insideRecipePage.preparation')),
                          ),
                          Container(
                            child: Text(TranslateService.translate(
                                'insideRecipePage.information')),
                          ),
                        ],
                        controller: recipeTabController,
                      ),
                    ),
                    SizedBox(
                      height: 550,
                      child: TabBarView(
                        controller: recipeTabController,
                        children: [
                          // Ingredients Tab
                          Container(
                            height: 400,
                            child: Column(
                              children: [
                                Container(),
                                Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(10, 10, 0, 10),
                                  child: Text(
                                    TranslateService.translate(
                                        'insideRecipePage.ingredients'),
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Column(
                                    children:
                                        ingredientesModificado.map((text) {
                                  List ingredientesAlternos =
                                      text['alternatives'];

                                  Widget obtenerFlecha() {
                                    if (ingredientesAlternos.isNotEmpty) {
                                      if (showListaShowAlternos[
                                          text['subId']]) {
                                        return const Icon(Icons.arrow_drop_up);
                                      } else {
                                        return const Icon(
                                            Icons.arrow_drop_down);
                                      }
                                    } else {
                                      return Container();
                                    }
                                  }

                                  Widget obtenalgo(int id) {
                                    if (showListaShowAlternos[id]) {
                                      return Column(
                                        children:
                                            ingredientesAlternos.map((text2) {
                                          return Container(
                                            alignment: Alignment.centerLeft,
                                            margin: const EdgeInsets.fromLTRB(
                                                0, 0, 0, 5),
                                            child: Text(text2['amount'] +
                                                ' ' +
                                                text2['unit'] +
                                                ' ' +
                                                text2['name']),
                                            // child: Table(
                                            //   children: [
                                            //     TableRow(
                                            //       children: [
                                            //         Text(text2['amount']),
                                            //         Text(text2['unit']),
                                            //         Text(text2['name']),
                                            //       ],
                                            //     ),
                                            //   ],
                                            // ),
                                          );
                                        }).toList(),
                                      );
                                    } else {
                                      return Container();
                                    }
                                  }

                                  return Container(
                                    margin: const EdgeInsets.fromLTRB(
                                        10, 10, 30, 0),
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 5, 15, 5),
                                    alignment: Alignment.centerLeft,
                                    child: Column(
                                      children: [
                                        Text(
                                            '• ${text['amount']} ${text['unit']} ${TranslateService.translate('insideRecipePage.of')} ${text['name']}'),
                                        // Table(
                                        //   defaultVerticalAlignment:
                                        //       TableCellVerticalAlignment
                                        //           .middle,
                                        //   children: [
                                        //     TableRow(
                                        //       children: [
                                        //         Text(text['amount']),
                                        //         Text(text['unit']),
                                        //         Text(text['name']),
                                        //         IconButton(
                                        //           onPressed: () {
                                        //             if (showListaShowAlternos[
                                        //                 text['subId']]) {
                                        //               setState(() {
                                        //                 showListaShowAlternos[
                                        //                         text[
                                        //                             'subId']] =
                                        //                     false;
                                        //               });
                                        //             } else {
                                        //               setState(() {
                                        //                 showListaShowAlternos[
                                        //                         text[
                                        //                             'subId']] =
                                        //                     true;
                                        //               });
                                        //             }
                                        //           },
                                        //           icon: obtenerFlecha(),
                                        //         ),
                                        //       ],
                                        //     ),
                                        //   ],
                                        // ),
                                        // obtenalgo(text['subId']),
                                      ],
                                    ),
                                  );
                                }).toList()),
                              ],
                            ),
                          ),
                          // Preparation Tab
                          Container(
                            height: 400,
                            child: Column(
                              children: [
                                Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(10, 20, 0, 10),
                                  child: Text(
                                    TranslateService.translate(
                                        'insideRecipePage.preparation'),
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Column(
                                    children: preparacionModificado.map((text) {
                                  return Container(
                                    padding: const EdgeInsets.fromLTRB(
                                        30, 20, 30, 0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                            margin: const EdgeInsets.fromLTRB(
                                                0, 0, 10, 0),
                                            width: 20,
                                            height: 20,
                                            decoration: BoxDecoration(
                                                color: AppColors.colorRecipes,
                                                shape: BoxShape.circle),
                                            child: Center(
                                              child: Text(
                                                text['subId'].toString(),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            )),
                                        Flexible(
                                          child: Text(text['description']),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList()),
                              ],
                            ),
                          ),
                          // Information Tab
                          Container(
                            height: 500,
                            margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: Container(
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(20),
                                    decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      color: Color.fromRGBO(255, 140, 0, 0.3),
                                    ),
                                    margin:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              TranslateService.translate(
                                                  'insideRecipePage.warningMessageTitle'),
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black54,
                                              ),
                                              textAlign: TextAlign.left,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.fromLTRB(
                                                  0, 0, 10, 0),
                                              child: const Icon(
                                                Icons.info_outline,
                                                color: Colors.black,
                                                size: 50,
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                TranslateService.translate(
                                                    'insideRecipePage.warningMessage1'),
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                ),
                                                textAlign: TextAlign.left,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(20),
                                    decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      color: Color.fromRGBO(255, 140, 0, 0.3),
                                    ),
                                    margin:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              TranslateService.translate(
                                                  'insideRecipePage.warningMessageTitle'),
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black54,
                                              ),
                                              textAlign: TextAlign.left,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.fromLTRB(
                                                  0, 0, 10, 0),
                                              child: const Icon(
                                                Icons.info_outline,
                                                color: Colors.black,
                                                size: 50,
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                TranslateService.translate(
                                                    'insideRecipePage.warningMessage2'),
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  // color: Colors.white,
                                                ),
                                                textAlign: TextAlign.left,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    child: Table(
                                        border: TableBorder.all(
                                            color: Colors.black),
                                        children: [
                                          TableRow(children: [
                                            Container(
                                                padding:
                                                    const EdgeInsets.all(5),
                                                child: const Text(
                                                    'Edad de la niña (niño)')),
                                            Container(
                                              padding: const EdgeInsets.all(5),
                                              child: const Text(
                                                  'Cantidad de carne, pollo, pescado, hígado, huevo, molleja'),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.all(5),
                                              child: const Text(
                                                  'Cantidad de comida (aprox)'),
                                            ),
                                          ]),
                                          TableRow(children: [
                                            Container(
                                              padding: const EdgeInsets.all(5),
                                              child: const Text('6 - 8 meses'),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.all(5),
                                              child: const Text(
                                                  'Hasta una cucharada'),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.all(5),
                                              child: const Text(
                                                  'De dos cucharadas a media taza chica'),
                                            ),
                                          ]),
                                          TableRow(children: [
                                            Container(
                                              padding: const EdgeInsets.all(5),
                                              child: const Text('9 - 11 meses'),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.all(5),
                                              child:
                                                  const Text('2 cucharadas '),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.all(5),
                                              child: const Text(
                                                  'Un poco más de media taza chica '),
                                            ),
                                          ]),
                                          TableRow(children: [
                                            Container(
                                              padding: const EdgeInsets.all(5),
                                              child:
                                                  const Text('12 - 23 meses'),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.all(5),
                                              child:
                                                  const Text('3 cucharadas '),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.all(5),
                                              child: const Text(
                                                  '1 taza o tazón  chico'),
                                            ),
                                          ])
                                        ]),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
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
                            children: comentarios.map((text) {
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
                                      margin: const EdgeInsets.fromLTRB(
                                          10, 0, 0, 0),
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
          )),
      /*
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Envuelve la reproducción o pausa en una llamada a `setState`. Esto asegura
          // que se muestra el icono correcto
          setState(() {
            // Si el vídeo se está reproduciendo, pausalo.
            if (_controller.value.isPlaying) {
              _controller.pause();
            } else {
              // Si el vídeo está pausado, reprodúcelo
              _controller.play();
            }
          });
        },
        // Muestra el icono correcto dependiendo del estado del vídeo.
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),*/
    );
  }
}
