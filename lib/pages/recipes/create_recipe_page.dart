import 'dart:io';

import 'package:perusano/components/lateralMenu.dart';

import 'package:flutter/material.dart';
import 'package:perusano/services/apis/recipe/recipesService.dart';
import 'package:perusano/services/fileManagement/recipes/selectable/recipeCategoryFM.dart';
import 'package:perusano/util/internVariables.dart';
import 'package:image_picker/image_picker.dart';

import '../../services/fileManagement/recipes/recipeFM.dart';
import '../../services/translateService.dart';
import '../../util/class/recipes/recipeClass.dart';
import '../../util/globalVariables.dart';
import '../../util/myColors.dart';
import 'adding_ingredients_page.dart';

class CreateRecipesPage extends StatefulWidget {
  @override
  State<CreateRecipesPage> createState() => _CreateRecipesPage();
}

class _CreateRecipesPage extends State<CreateRecipesPage> {
  List ingredientesDevueltos = [];
  List pasos = [];
  int order = 1;
  TextEditingController nombreReceta = TextEditingController();
  TextEditingController pasoActual = TextEditingController();
  List tagEdades = [];
  int idTag = 0;
  String tagEscogida =
      TranslateService.translate('createRecipePage.choose_tag');

  final _formKeyName = GlobalKey<FormState>();

  Widget underLineIngredientes = Container();
  Widget underLinePasos = Container();
  Widget underLineTag = Container();
  Widget underLineImage = Container();
  Widget underLineVideo = Container();

  RecipeCategoryFM _recipeCategoryStorage = RecipeCategoryFM();

  late Map dataUser;

  File? _image;
  bool existeImage = false;
  File? _video;
  bool existeVideo = false;

  final isConnected = GlobalVariables.isConnected();
  final RecipeFM _recipeStorage = RecipeFM();

  // Allows use the camera to take a picture
  Future getImageCamera() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image == null) return;

    final imageTemporary = File(image.path);

    setState(() {
      _image = imageTemporary;
      existeImage = true;
    });
  }

  // Allows use the gallery to obtain a camera
  Future getImageGalery() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;

    final imageTemporary = File(image.path);

    setState(() {
      _image = imageTemporary;
      existeImage = true;
    });
  }

  // Allows use the camera to record a video
  Future getVideoCamera() async {
    final video = await ImagePicker().pickVideo(source: ImageSource.camera);
    if (video == null) return;

    final videoTemporary = File(video.path);

    setState(() {
      _video = videoTemporary;
      existeVideo = true;
    });
  }

  // Allows use the gallery to obtain a video
  Future getVideoGalery() async {
    final video = await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (video == null) return;

    final videoTemporary = File(video.path);

    setState(() {
      _video = videoTemporary;
      existeVideo = true;
    });
  }

  // Get Age Tag from local storage
  Future getTagEdades() async {
    List dataObt;
    dataObt = await _recipeCategoryStorage.readFile();
    setState(() {
      tagEdades = [
        {'value': '6-8', 'id': 1},
        {'value': '9-11', 'id': 2},
        {'value': '12-23', 'id': 3}
      ];
    });
  }

  // Avoid empty information
  validateDropDownButton() {
    if (ingredientesDevueltos.isEmpty) {
      setState(() {
        underLineIngredientes = Container(
          child: Text(
            TranslateService.translate('createRecipePage.validatorIngredient'),
            style: const TextStyle(color: Colors.red),
          ),
        );
      });
    } else {
      setState(() {
        underLineIngredientes = Container();
      });
    }
    if (pasos.isEmpty) {
      setState(() {
        underLinePasos = Container(
          child: Text(
            TranslateService.translate('createRecipePage.validatorStep'),
            style: const TextStyle(color: Colors.red),
          ),
        );
      });
    } else {
      setState(() {
        underLinePasos = Container();
      });
    }
    if (idTag == 0) {
      setState(() {
        underLineTag = Container(
          child: Text(
            TranslateService.translate('createRecipePage.validator'),
            style: const TextStyle(color: Colors.red),
          ),
        );
      });
    } else {
      setState(() {
        underLineTag = Container();
      });
    }
    if (!existeImage) {
      setState(() {
        underLineImage = Container(
          child: Text(
            TranslateService.translate('createRecipePage.validator'),
            style: const TextStyle(color: Colors.red),
          ),
        );
      });
    } else {
      setState(() {
        underLineImage = Container();
      });
    }
    if (!existeVideo) {
      setState(() {
        underLineVideo = Container(
          child: Text(
            TranslateService.translate('createRecipePage.validator'),
            style: const TextStyle(color: Colors.red),
          ),
        );
      });
    } else {
      setState(() {
        underLineVideo = Container();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getTagEdades();
  }

  Future<void> obtainIngredient(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddingIngredientsPage()),
    );

    // When a BuildContext is used from a StatefulWidget, the mounted property
    // must be checked after an asynchronous gap.
    if (!mounted) return;

    // After the Selection Screen returns a result, hide any previous snackbars
    // and show the new result.
    setState(() {
      if (result != null) {
        ingredientesDevueltos.add(result);
      }
    });
  }

  subirReceta() async {
    if (await isConnected) {
      Map recetaFinal = formarMap();
      dataUser = await RecipesService().addRecipe(recetaFinal);
      if (dataUser['id'] > 0) {
        bool img;
        bool vid;
        /*if (_image == null){
        _image = File.fromUri(Uri.parse(GlobalVariables.endpoint + '/static/recipes/recipeDefault.png'));
      }*/
        img = await RecipesService().addImage(_image!, dataUser['id']);
        vid = await RecipesService().addVideo(_video!, dataUser['id']);
        if (img == true && vid == true) {
          return true;
        }

        return true;
      }
      return false;
    } else {
      Map recipe = getRecipeDataOffline();
      String imagePath = await RecipesService().storeLocalImage(_image!);
      String videoPath = await RecipesService().storeLocalVideo(_video!);

      RecipeRegister register = RecipeRegister(
          0,
          recipe["title"],
          recipe["total_likes"],
          recipe['author_name'],
          InternVariables.idUser,
          recipe["preparation"],
          [],
          recipe["ingredients"],
          "aprobado",
          1,
          {"id": idTag, "value": tagEscogida},
          false,
          imagePath,
          videoPath);
      Map registerJson = register.toJson();
      await _recipeStorage.writeRegister(registerJson);

      return true;
    }
  }

  Map formarMap() {
    List ingredientesFinales = [];

    for (var i = 0; i < ingredientesDevueltos.length; i++) {
      List alternosFinales = [];
      for (var i2 = 0; i2 < ingredientesDevueltos[i]['alternos'].length; i2++) {
        Map altern = {
          "id": ingredientesDevueltos[i]['alternos'][i2]['idIngrediente'],
          "amount_id": ingredientesDevueltos[i]['alternos'][i2]['idCantidad'],
          "unit_id": ingredientesDevueltos[i]['alternos'][i2]['idUnidad'],
        };
        alternosFinales.add(altern);
      }
      Map ingr = {
        "id": ingredientesDevueltos[i]['idIngrediente'],
        "amount_id": ingredientesDevueltos[i]['idCantidad'],
        "unit_id": ingredientesDevueltos[i]['idUnidad'],
        "alternatives": alternosFinales,
      };
      ingredientesFinales.add(ingr);
    }

    Map recetaASubir = {
      "title": nombreReceta.text,
      "total_likes": 0,
      "author_id": InternVariables.idUser,
      "age_tag_id": idTag,
      "preparation": pasos,
      "ingredients": ingredientesFinales
    };
    return recetaASubir;
  }

  Map getRecipeDataOffline() {
    List ingredientsFinal = [];
    for (var i = 0; i < ingredientesDevueltos.length; i++) {
      List alternativeFinal = [];
      for (var i2 = 0; i2 < ingredientesDevueltos[i]['alternos'].length; i2++) {
        Map alt = {
          "id": ingredientesDevueltos[i]['alternos'][i2]['idIngrediente'],
          "amount_id": ingredientesDevueltos[i]['alternos'][i2]['idCantidad'],
          "unit_id": ingredientesDevueltos[i]['alternos'][i2]['idUnidad'],
          "unit": ingredientesDevueltos[i]['alternos'][i2]['unidad'],
          "amount": ingredientesDevueltos[i]['alternos'][i2]['cantidad'],
          "name": ingredientesDevueltos[i]['alternos'][i2]['ingrediente'],
        };
        alternativeFinal.add(alt);
      }
      Map ingr = {
        "id": ingredientesDevueltos[i]['idIngrediente'],
        "amount_id": ingredientesDevueltos[i]['idCantidad'],
        "amount": ingredientesDevueltos[i]['cantidad'],
        "unit": ingredientesDevueltos[i]['unidad'],
        "unit_id": ingredientesDevueltos[i]['idUnidad'],
        "name": ingredientesDevueltos[i]['ingrediente'],
        "alternatives": alternativeFinal,
      };
      ingredientsFinal.add(ingr);
    }

    Map recipe = {
      "title": nombreReceta.text,
      "total_likes": 0,
      "author_name": InternVariables.userName,
      "age_tag_id": idTag,
      "preparation": pasos,
      "ingredients": ingredientsFinal
    };
    return recipe;
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
      endDrawer: LateralMenu(),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Text(
                  TranslateService.translate('createRecipePage.title'),
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Divider(color: AppColors.colorRecipes, thickness: 5, height: 30),
              Container(
                child: Column(
                  children: [
                    Container(
                        padding: const EdgeInsets.fromLTRB(10, 20, 30, 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                              child: Text(
                                TranslateService.translate(
                                    'createRecipePage.name'),
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              height: 35,
                              child: Form(
                                key: _formKeyName,
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == '') {
                                      return TranslateService.translate(
                                          'createRecipePage.validator');
                                    }
                                  },
                                  style: const TextStyle(fontSize: 16),
                                  controller: nombreReceta,
                                  //maxLines: null,
                                  decoration: const InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8))),
                                  ),
                                ),
                              ),
                            )
                          ],
                        )),
                    Divider(
                        color: AppColors.colorRecipes,
                        thickness: 5,
                        height: 30),
                    Container(
                        padding: const EdgeInsets.fromLTRB(10, 0, 30, 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                              child: Text(
                                TranslateService.translate(
                                    'createRecipePage.upload_photo'),
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Table(
                              children: [
                                TableRow(children: [
                                  Container(
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                AppColors.colorButtonRecipes),
                                        foregroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.white),
                                      ),
                                      child: Text(
                                        TranslateService.translate(
                                            'createRecipePage.choose_file'),
                                      ),
                                      onPressed: () {
                                        showModalBottomSheet(
                                            context: context,
                                            builder: (BuildContext bc) {
                                              return SafeArea(
                                                child: Container(
                                                  child: Wrap(
                                                    children: <Widget>[
                                                      ListTile(
                                                          leading: const Icon(
                                                              Icons
                                                                  .photo_library),
                                                          title: const Text(
                                                              'Photo Library'),
                                                          onTap: () {
                                                            getImageGalery();
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          }),
                                                      ListTile(
                                                        leading: const Icon(
                                                            Icons.photo_camera),
                                                        title: const Text(
                                                            'Camera'),
                                                        onTap: () {
                                                          getImageCamera();
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            });
                                      },
                                    ),
                                  ),
                                  Container(
                                      child: _image != null
                                          ? Image.file(_image!,
                                              width: 50, height: 50)
                                          : Container())
                                ])
                              ],
                            ),
                            Container(
                              //padding: EdgeInsets.fromLTRB(0, 20, 30, 0),
                              alignment: Alignment.center,
                              child: underLineImage,
                            ),
                          ],
                        )),
                  ],
                ),
              ),
              Divider(color: AppColors.colorRecipes, thickness: 5, height: 30),
              Container(
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: Text(
                        TranslateService.translate(
                            'createRecipePage.ingredients'),
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    /*Container(
                child: Expanded(
                  child: Container(),
              ),
              ),*/
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: Column(
                          children: ingredientesDevueltos.map((text) {
                        return Container(
                            padding: const EdgeInsets.fromLTRB(20, 10, 30, 3),
                            child: Column(
                              children: [
                                Table(
                                  //border: TableBorder.all(),
                                  columnWidths: const {
                                    0: FlexColumnWidth(1),
                                    1: FlexColumnWidth(1),
                                  },
                                  children: [
                                    TableRow(children: [
                                      Container(
                                        child: Text(
                                          '${text['cantidad']} ${text['unidad']}',
                                          textAlign: TextAlign.start,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Container(
                                        child: Text(
                                          text['ingrediente'],
                                          textAlign: TextAlign.start,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ])
                                  ],
                                ),
                              ],
                            ));
                      }).toList()),
                    ),
                    Container(
                      child: ElevatedButton(
                        onPressed: () {
                          obtainIngredient(context);
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              AppColors.colorButtonRecipes),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                        ),
                        child: Text(
                          TranslateService.translate(
                              'createRecipePage.addIngredient'),
                        ),
                      ),
                    ),
                    underLineIngredientes,
                  ],
                ),
              ),
              Divider(color: AppColors.colorRecipes, thickness: 5, height: 30),
              Container(
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: Text(
                        TranslateService.translate('createRecipePage.steps'),
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: Column(
                          children: pasos.map((text) {
                        return Container(
                            padding: const EdgeInsets.fromLTRB(20, 10, 30, 3),
                            child: Column(
                              children: [
                                Table(
                                  //border: TableBorder.all(),
                                  columnWidths: const {
                                    0: FlexColumnWidth(1),
                                    1: FlexColumnWidth(5),
                                  },
                                  children: [
                                    TableRow(children: [
                                      Container(
                                        child: Text(
                                          text['order'].toString(),
                                          textAlign: TextAlign.start,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Container(
                                        child: Text(
                                          text['description'],
                                          textAlign: TextAlign.start,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ])
                                  ],
                                ),
                              ],
                            ));
                      }).toList()),
                    ),
                    Container(
                        padding: const EdgeInsets.fromLTRB(10, 0, 30, 10),
                        child: Table(
                          columnWidths: const {
                            0: FlexColumnWidth(1),
                            1: FlexColumnWidth(5),
                          },
                          children: [
                            TableRow(children: [
                              Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                      color: AppColors.colorRecipes,
                                      shape: BoxShape.circle),
                                  child: Center(
                                    child: Text(
                                      order.toString(),
                                      style: const TextStyle(),
                                    ),
                                  )),
                              TextFormField(
                                controller: pasoActual,
                                autocorrect: true,
                                maxLines: null,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ])
                          ],
                        )),
                    Container(
                      child: ElevatedButton(
                        onPressed: () {
                          Map stepAdd = {
                            "order": order,
                            "description": pasoActual.text
                          };
                          setState(() {
                            pasos.add(stepAdd);
                            order++;
                            pasoActual.clear();
                          });
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              AppColors.colorButtonRecipes),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                        ),
                        child: Text(
                          TranslateService.translate(
                              'createRecipePage.addStep'),
                        ),
                      ),
                    ),
                    underLinePasos,
                  ],
                ),
              ),
              Divider(color: AppColors.colorRecipes, thickness: 5, height: 30),
              Container(
                  padding: const EdgeInsets.fromLTRB(10, 0, 30, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                        child: Text(
                          TranslateService.translate(
                              'createRecipePage.upload_video'),
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Table(
                        children: [
                          TableRow(children: [
                            Container(
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          AppColors.colorButtonRecipes),
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                ),
                                child: Text(
                                  TranslateService.translate(
                                      'createRecipePage.choose_file'),
                                ),
                                onPressed: () {
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext bc) {
                                        return SafeArea(
                                          child: Container(
                                            child: Wrap(
                                              children: <Widget>[
                                                ListTile(
                                                    leading: const Icon(
                                                        Icons.photo_library),
                                                    title: const Text(
                                                        'Photo Library'),
                                                    onTap: () {
                                                      getVideoGalery();
                                                      Navigator.of(context)
                                                          .pop();
                                                    }),
                                                ListTile(
                                                  leading: const Icon(
                                                      Icons.photo_camera),
                                                  title: const Text('Camera'),
                                                  onTap: () {
                                                    getVideoCamera();
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      });
                                },
                              ),
                            ),
                            Container(
                                child: _video != null
                                    ? Image.asset(
                                        '${GlobalVariables.logosAddress}previaVideo.png',
                                        width: 50,
                                        height: 50)
                                    : Container()),
                          ])
                        ],
                      ),
                      Container(
                        //padding: EdgeInsets.fromLTRB(0, 20, 30, 0),
                        alignment: Alignment.center,
                        child: underLineVideo,
                      ),
                    ],
                  )),
              Divider(color: AppColors.colorRecipes, thickness: 5, height: 30),

              /*Container(
                padding: EdgeInsets.fromLTRB(10, 20, 30, 10),
                child: Table(
                  columnWidths: {
                    0: FlexColumnWidth(1),
                    1: FlexColumnWidth(1),
                  },
                  children: [
                    TableRow(
                      children: [
                        Container(
                          //color: Colors.red,
                          //padding: EdgeInsets.fromLTRB(10, 20, 30, 10),
                          child: Text(TranslateService.translate('createRecipePage.add_tag'), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                        ),
                        Container(
                          //color: Colors.blue,
                          child: DropdownButton(
                            items: tagEdades.map((text){
                              return DropdownMenuItem(
                                value: {'id' : text['id'], 'value' : text['value']},
                                child: Flexible(
                                  fit: FlexFit.tight,
                                  child: Text(text['value'], overflow: TextOverflow.visible,),
                                ),
                              );
                            }).toList(),
                            onChanged: (value){
                              setState(() {
                                idTag = value!['id'];
                                tagEscogida = value!['value'];
                              });
                            },
                            hint: Text(tagEscogida),
                          ),
                        ),
                      ]
                    ),
                    TableRow(
                      children: [
                        Container(),
                        underLineTag,
                      ]
                    )
                  ],
                )
              ),*/

              Container(
                padding: const EdgeInsets.fromLTRB(10, 20, 30, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      TranslateService.translate('createRecipePage.add_tag'),
                      //textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      child: DropdownButton(
                        items: tagEdades.map((text) {
                          return DropdownMenuItem(
                            // value: 1,
                            // child: Text("sendhelppls"),
                            value: {'id': text['id'], 'value': text['value']},
                            child: Text(text['value']),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            idTag = value!['id'];
                            tagEscogida = value['value'].toString();
                          });
                        },
                        hint: Text(tagEscogida),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                //padding: EdgeInsets.fromLTRB(0, 20, 30, 0),
                alignment: Alignment.center,
                child: underLineTag,
              ),
              Divider(color: AppColors.colorRecipes, thickness: 5, height: 30),
              Container(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKeyName.currentState!.validate() &&
                        ingredientesDevueltos.isNotEmpty &&
                        pasos.isNotEmpty &&
                        idTag != 0 &&
                        existeImage &&
                        existeVideo) {
                      bool answer = await subirReceta();
                      if (answer == true) {
                        final snackBar = SnackBar(
                          content: Text(TranslateService.translate(
                              'createRecipePage.added')),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        Navigator.pop(context);
                      } else {
                        final snackBar = SnackBar(
                          content: Text(TranslateService.translate(
                              'createRecipePage.denied')),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    }
                    validateDropDownButton();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        AppColors.colorButtonRecipes),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  child: Text(
                    TranslateService.translate(
                        'createRecipePage.upload_recipe'),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
