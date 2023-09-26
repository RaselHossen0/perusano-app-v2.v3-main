import 'package:flutter/material.dart';
import 'package:perusano/services/fileManagement/recipes/selectable/amountFM.dart';
import 'package:perusano/services/fileManagement/recipes/selectable/ingredientFM.dart';
import 'package:perusano/services/fileManagement/recipes/selectable/unitFM.dart';

import '../../components/lateralMenu.dart';
import '../../services/translateService.dart';
import '../../util/myColors.dart';

class AddingIngredientsPage extends StatefulWidget {
  @override
  State<AddingIngredientsPage> createState() => _AddingIngredientsPage();
}

class _AddingIngredientsPage extends State<AddingIngredientsPage> {
  TextEditingController ingredientController = TextEditingController();
  String filtrado = '';

  String ingredienteEscogido = '';
  int idIngrediente = 0;
  String cantidadEscogida =
      TranslateService.translate('addIngredient.choose_amount');
  int idCantidad = 0;
  String unidadEscogida =
      TranslateService.translate('addIngredient.choose_unit');
  int idUnidad = 0;

  TextEditingController ingredientAlternativoController =
      TextEditingController();
  List ingredientesAlternos = [];
  bool extra = false;
  String ingredienteAlternativoEscogido = '';
  int idIngredienteAlternativo = 0;
  String cantidadAlternativoEscogida =
      TranslateService.translate('addIngredient.choose_amount');
  int idCantidadAlternativo = 0;
  String unidadAlternativoEscogida =
      TranslateService.translate('addIngredient.choose_unit');
  int idUnidadAlternativo = 0;

  List ingredientes = [];
  List ingredientesFiltrada = [];
  List cantidades = [];
  List unidades = [];

  final IngredientFM _ingredientStorage = IngredientFM();
  final AmountFM _amountStorage = AmountFM();
  final UnitFM _unitStorage = UnitFM();

  Widget underLineAmount = Container();
  Widget underLineUnit = Container();

  Widget underLineAmountAlternative = Container();
  Widget underLineUnitAltertnative = Container();

  final _formKey = GlobalKey<FormState>();
  final _formKeyalternative = GlobalKey<FormState>();

  // Gets ingredients from local storage
  loadIngredients() async {
    List dataObt;
    dataObt = await _ingredientStorage.readFile();
    setState(() {
      ingredientes = [
        {'value': 'ing1', 'id': 1},
        {'value': 'ing2', 'id': 2},
        {'value': 'ing3', 'id': 3},
        {'value': 'ing4', 'id': 4}
      ];
      ingredientesFiltrada = ingredientes;
    });
  }

  // Gets amounts from local storage
  loadAmounts() async {
    List dataObt;
    dataObt = await _amountStorage.readFile();
    setState(() {
      cantidades = [
        {'value': '1', 'id': 1},
        {'value': '2', 'id': 2},
        {'value': '3', 'id': 3}
      ];
    });
  }

  // Gets units from local storage
  loadUnits() async {
    List dataObt;
    dataObt = await _unitStorage.readFile();
    setState(() {
      unidades = [
        {'value': 'spoons', 'id': 1},
        {'value': 'cups', 'id': 2},
        {'value': 'grams', 'id': 3}
      ];
    });
  }

  // Update the filter ingredients list
  filtrando(String text) {
    setState(() {
      ingredientesFiltrada = ingredientes;
      actualizandoFiltrado(text);
    });
  }

  // Filter the ingredients list searching coincidences with the text received
  actualizandoFiltrado(String text) {
    if (text == '') {
      ingredientesFiltrada.clear();
    } else {
      for (var i = 0; i < ingredientes.length; i++) {
        // print(text);
        if (ingredientes[i]["value"]
            .toString()
            .toLowerCase()
            .contains(text.toLowerCase())) {
          ingredientesFiltrada.add(ingredientes[i]);
        }
      }
    }
  }

  // Avoid empty information in ingredients
  validateDropDownButton() {
    if (idUnidad == 0) {
      setState(() {
        underLineUnit = Container(
          child: Text(
            TranslateService.translate('addAppointment.validateText'),
            style: const TextStyle(color: Colors.red),
          ),
        );
      });
    } else {
      setState(() {
        underLineUnit = Container();
      });
    }
    if (idCantidad == 0) {
      setState(() {
        underLineAmount = Container(
          child: Text(
            TranslateService.translate('addAppointment.validateText'),
            style: const TextStyle(color: Colors.red),
          ),
        );
      });
    } else {
      setState(() {
        underLineAmount = Container();
      });
    }
  }

  // Avoid empty information in altern ingredients
  validateDropDownButtonAlternatives() {
    if (idUnidadAlternativo == 0) {
      setState(() {
        underLineUnitAltertnative = Container(
          child: Text(
            TranslateService.translate('addAppointment.validateText'),
            style: const TextStyle(color: Colors.red),
          ),
        );
      });
    } else {
      setState(() {
        underLineUnitAltertnative = Container();
      });
    }
    if (idCantidadAlternativo == 0) {
      setState(() {
        underLineAmountAlternative = Container(
          child: Text(
            TranslateService.translate('addAppointment.validateText'),
            style: const TextStyle(color: Colors.red),
          ),
        );
      });
    } else {
      setState(() {
        underLineAmountAlternative = Container();
      });
    }
  }

  // Shows alternatives ingredients have been chosen
  Widget presentaIngredientesAlternos() {
    if (extra) {
      return Column(
        children: [
          const Divider(
              color: Color.fromRGBO(193, 197, 234, 100),
              thickness: 5,
              height: 30),
          Divider(color: AppColors.colorRecipes, thickness: 5, height: 30),
          Container(
            child: Form(
              key: _formKeyalternative,
              child: TextFormField(
                validator: (value) {
                  if (idIngredienteAlternativo == 0) {
                    return TranslateService.translate(
                        'addIngredient.validateText');
                  }
                },
                decoration: InputDecoration(
                    suffixIcon: const Icon(Icons.search),
                    label: Text(
                      TranslateService.translate(
                          'addIngredient.find_ingredient'),
                    )),
                controller: ingredientAlternativoController,
                onChanged: (text) {
                  filtrando(text);
                },
              ),
            ),
          ),
          Container(
            constraints: const BoxConstraints(
              minHeight: 100.0,
              maxHeight: 100.0,
            ),
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
            child: ListView(
              children: [
                Column(
                    children: ingredientesFiltrada.map((text) {
                  return Container(
                      width: 200,
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            ingredienteAlternativoEscogido = text['value'];
                            idIngredienteAlternativo = text['id'];
                            ingredientAlternativoController.clear();
                            ingredientesFiltrada.clear();
                          });
                        },
                        child: Text(
                          text['value'],
                          style: const TextStyle(
                              color: Colors.black, fontSize: 18),
                        ),
                      ));
                }).toList()),
              ],
            ),
          ),
          Divider(color: AppColors.colorRecipes, thickness: 5, height: 30),
          Container(
            child: Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: Text(
                      '${TranslateService.translate('addIngredient.choose_ingredient')} :',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: Text(ingredienteAlternativoEscogido,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 18)),
                  ),
                ])
              ],
            ),
          ),
          Divider(color: AppColors.colorRecipes, thickness: 5, height: 30),
          Container(
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(1),
              },
              children: [
                TableRow(children: [
                  Text(
                    TranslateService.translate('addIngredient.amount'),
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    TranslateService.translate('addIngredient.unit'),
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ]),
                TableRow(children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 0, 2.5, 0),
                    child: DropdownButton(
                      items: cantidades.map((text) {
                        return DropdownMenuItem(
                          value: {'id': text['id'], 'value': text['value']},
                          child: Text(text['value']),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          cantidadAlternativoEscogida = value!['value'];
                          idCantidadAlternativo = value!['id'];
                          validateDropDownButtonAlternatives();
                        });
                      },
                      hint: Text(cantidadAlternativoEscogida),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(2.5, 0, 0, 0),
                    child: DropdownButton(
                      items: unidades.map((text) {
                        return DropdownMenuItem(
                          value: {'id': text['id'], 'value': text['value']},
                          child: Text(text['value']),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          unidadAlternativoEscogida = value!['value'];
                          idUnidadAlternativo = value!['id'];
                          validateDropDownButtonAlternatives();
                        });
                      },
                      hint: Text(unidadAlternativoEscogida),
                    ),
                  ),
                ]),
                TableRow(
                  children: [
                    underLineAmountAlternative,
                    underLineUnitAltertnative,
                  ],
                )
              ],
            ),
          ),
          Divider(color: AppColors.colorRecipes, thickness: 5, height: 30),
          Container(
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: () {
                if (_formKeyalternative.currentState!.validate() &&
                    idCantidadAlternativo != 0 &&
                    idUnidadAlternativo != 0) {
                  Map result = {
                    'idIngrediente': idIngredienteAlternativo,
                    'ingrediente': ingredienteAlternativoEscogido,
                    'idCantidad': idCantidadAlternativo,
                    'cantidad': cantidadAlternativoEscogida,
                    'idUnidad': idUnidadAlternativo,
                    'unidad': unidadAlternativoEscogida,
                  };
                  setState(() {
                    ingredientesAlternos.add(result);
                  });

                  idIngredienteAlternativo = 0;
                  ingredienteAlternativoEscogido = '';
                  ingredientAlternativoController.clear();
                  idCantidadAlternativo = 0;
                  cantidadAlternativoEscogida =
                      TranslateService.translate('addIngredient.choose_amount');
                  idUnidadAlternativo = 0;
                  unidadAlternativoEscogida =
                      TranslateService.translate('addIngredient.choose_unit');
                } else {
                  validateDropDownButtonAlternatives();
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    AppColors.colorButtonRecipes),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
              child: Text(
                TranslateService.translate('addIngredient.addAlternative'),
              ),
            ),
          )
        ],
      );
    } else {
      return Container();
    }
  }

  @override
  void initState() {
    loadIngredients();
    loadAmounts();
    loadUnits();
    super.initState();
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
                        padding: const EdgeInsets.fromLTRB(10, 20, 30, 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                              child: Text(
                                TranslateService.translate(
                                    'addIngredient.title'),
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              child: Form(
                                key: _formKey,
                                child: TextFormField(
                                  validator: (value) {
                                    if (ingredienteEscogido == '') {
                                      return TranslateService.translate(
                                          'addIngredient.validateText');
                                    }
                                  },
                                  decoration: InputDecoration(
                                      suffixIcon: const Icon(Icons.search),
                                      label: Text(
                                        TranslateService.translate(
                                            'addIngredient.find_ingredient'),
                                      )),
                                  controller: ingredientController,
                                  onChanged: (text) {
                                    filtrando(text);
                                  },
                                ),
                              ),
                            ),
                            Container(
                                constraints: const BoxConstraints(
                                  minHeight: 100.0,
                                  maxHeight: 100.0,
                                ),
                                margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                                child: ListView(
                                  children: [
                                    Column(
                                        children:
                                            ingredientesFiltrada.map((text) {
                                      return Container(
                                          width: 200,
                                          child: OutlinedButton(
                                            onPressed: () {
                                              setState(() {
                                                ingredienteEscogido =
                                                    text['value'];
                                                idIngrediente = text['id'];
                                                ingredientController.clear();
                                                ingredientesFiltrada.clear();
                                              });
                                            },
                                            child: Text(
                                              text['value'],
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18),
                                            ),
                                          ));
                                    }).toList()),
                                  ],
                                )),
                            Divider(
                                color: AppColors.colorRecipes,
                                thickness: 5,
                                height: 30),
                            Container(
                              child: Table(
                                defaultVerticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                children: [
                                  TableRow(children: [
                                    Container(
                                      margin: const EdgeInsets.fromLTRB(
                                          0, 0, 0, 10),
                                      child: Text(
                                        '${TranslateService.translate('addIngredient.choose_ingredient')} :',
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.fromLTRB(
                                          10, 0, 0, 0),
                                      child: Text(ingredienteEscogido,
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 18)),
                                    ),
                                  ])
                                ],
                              ),
                            ),
                            Divider(
                                color: AppColors.colorRecipes,
                                thickness: 5,
                                height: 30),
                            Container(
                              child: Table(
                                columnWidths: const {
                                  0: FlexColumnWidth(1),
                                  1: FlexColumnWidth(1),
                                },
                                children: [
                                  TableRow(children: [
                                    Text(
                                      TranslateService.translate(
                                          'addIngredient.amount'),
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      TranslateService.translate(
                                          'addIngredient.unit'),
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ]),
                                  TableRow(children: [
                                    Container(
                                      margin: const EdgeInsets.fromLTRB(
                                          0, 0, 2.5, 0),
                                      child: DropdownButton(
                                        items: cantidades.map((text) {
                                          return DropdownMenuItem(
                                            value: {
                                              'id': text['id'],
                                              'value': text['value']
                                            },
                                            child: Text(text['value']),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            cantidadEscogida = value!['value'];
                                            idCantidad = value!['id'];
                                            validateDropDownButton();
                                          });
                                        },
                                        hint: Text(cantidadEscogida),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.fromLTRB(
                                          2.5, 0, 0, 0),
                                      child: DropdownButton(
                                        items: unidades.map((text) {
                                          return DropdownMenuItem(
                                            value: {
                                              'id': text['id'],
                                              'value': text['value']
                                            },
                                            child: Text(text['value']),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            unidadEscogida = value!['value'];
                                            idUnidad = value!['id'];
                                            validateDropDownButton();
                                          });
                                        },
                                        hint: Text(unidadEscogida),
                                      ),
                                    ),
                                  ]),
                                  TableRow(
                                    children: [underLineAmount, underLineUnit],
                                  )
                                ],
                              ),
                            ),
                            Divider(
                                color: AppColors.colorRecipes,
                                thickness: 5,
                                height: 30),
                            Container(
                              alignment: Alignment.centerLeft,
                              margin: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                              child: Text(
                                TranslateService.translate(
                                    'addIngredient.alternative'),
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                              child: Column(
                                  children: ingredientesAlternos.map((text) {
                                return Container(
                                    padding: const EdgeInsets.fromLTRB(
                                        20, 10, 30, 3),
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
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              Container(
                                                child: Text(
                                                  text['ingrediente'],
                                                  textAlign: TextAlign.start,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
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
                                child: Column(
                              children: [
                                Container(
                                  child: InkWell(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          TranslateService.translate(
                                              'addIngredient.addAlternative'),
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Icon(extra
                                            ? Icons.arrow_drop_up
                                            : Icons.arrow_drop_down)
                                      ],
                                    ),
                                    onTap: () {
                                      if (extra) {
                                        setState(() {
                                          extra = false;
                                        });
                                      } else {
                                        setState(() {
                                          extra = true;
                                        });
                                      }
                                    },
                                  ),
                                ),
                                presentaIngredientesAlternos()
                              ],
                            )),
                            Divider(
                                color: AppColors.colorRecipes,
                                thickness: 5,
                                height: 30),
                            Container(
                              alignment: Alignment.center,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate() &&
                                      idCantidad != 0 &&
                                      idUnidad != 0) {
                                    Map result = {
                                      'idIngrediente': idIngrediente,
                                      'ingrediente': ingredienteEscogido,
                                      'idCantidad': idCantidad,
                                      'cantidad': cantidadEscogida,
                                      'idUnidad': idUnidad,
                                      'unidad': unidadEscogida,
                                      'alternos': ingredientesAlternos,
                                    };
                                    Navigator.pop(context, result);
                                  }
                                  validateDropDownButton();
                                },
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
                                      'addIngredient.add_ingredient'),
                                ),
                              ),
                            )
                          ],
                        )),
                  ])),
        ));
  }
}
