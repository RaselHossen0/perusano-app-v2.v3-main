import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:perusano/components/bottomNavigation.dart';
import 'package:perusano/util/globalVariables.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../services/translateService.dart';
import '../../../util/myColors.dart';

class InsideHealthNutritionPage extends StatefulWidget {
  int idKid;
  String name;
  int pageId;

  InsideHealthNutritionPage(
      {super.key,
      required this.idKid,
      required this.name,
      required this.pageId});

  @override
  State<StatefulWidget> createState() =>
      _InsideHealthNutritionPage(idKid: idKid, name: name, pageId: pageId);
}

class _InsideHealthNutritionPage extends State<InsideHealthNutritionPage> {
  int idKid;
  String name;
  int pageId;

  _InsideHealthNutritionPage(
      {required this.idKid, required this.name, required this.pageId});

  loadPage() async {
    String dataObj =
        await DefaultAssetBundle.of(context).loadString("assets/data.json");
    final jsonResult = jsonDecode(dataObj);
    // dataObj = await
  }

  generatePage(int pageId) {
    if (pageId == 1) {
      return [
        Container(
          margin: const EdgeInsets.fromLTRB(20, 20, 0, 20),
          child: const Text(
            'Lactancia Materna',
            style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.black87),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(20),
          child: const Text(
            '¿Por qué es importante dar de lactar en los primeros meses de vida?',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(20),
          child: const Text(
              'Porque es el alimento ideal, que brindará a su niña o niño todos los nutrientes y las defensas que necesita.'),
        ),
        Container(
          margin: const EdgeInsets.all(20),
          child: const Text(
            '¿Como cargar al bebé para dar de lactar (posición del niño o niña)?',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(20),
          child: const Text(
              'Hay varias posiciones. La más clásica la vemos en la figura:'),
        ),
        Container(
          width: 150,
          height: 150,
          margin: const EdgeInsets.fromLTRB(110, 0, 0, 0),
          child: Image.asset('${GlobalVariables.logosCREDAddress}feeding.png'),
        ),
        Container(
          margin: const EdgeInsets.all(20),
          child: const Text(
            'Vemos esto: ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(20),
          child: const Text('• La cabeza y el cuerpo del bebé alineados'),
        ),
        Container(
          margin: const EdgeInsets.all(20),
          child: const Text('• Su cuerpo muy cerca del cuerpo de la mamá'),
        ),
        Container(
          margin: const EdgeInsets.all(20),
          child: const Text('• Sostenido por la cabeza y hombros'),
        ),
        Container(
          margin: const EdgeInsets.all(20),
          child: const Text('• Si es recién nacido, todo el cuerpo.'),
        ),
        Container(
          margin: const EdgeInsets.all(20),
          child: const Text(
            'BENEFICIOS PARA LA MADRE:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(20),
          child: const Text(
              '•	Dar de lactar permite la liberación de hormonas que la calman y ayudan a su recuperación (la oxitocina y endorfinas, que producen bienestar y placer, así como la prolactina, que permite la producción de leche y tiene un efecto relajante).'),
        ),
        Container(
          margin: const EdgeInsets.all(20),
          child: const Text(
              '•	Disminuye los niveles de depresión y ansiedad postparto (trastornos del estado de ánimo materno).'),
        ),
        Container(
          margin: const EdgeInsets.all(20),
          child: const Text(
            'BENEFICIOS PARA EL BEBÉ:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(20),
          child: const Text('•	Lo mantiene caliente.'),
        ),
        Container(
          margin: const EdgeInsets.all(20),
          child: const Text('•	Mejora su estabilidad cardio respiratoria.'),
        ),
        Container(
          margin: const EdgeInsets.all(20),
          child: const Text('•	Llora menos.'),
        ),
        Container(
          margin: const EdgeInsets.all(20),
          child: const Text(
              '•	Contribuye a que el calostro fluya con más facilidad, favoreciendo el tiempo de inicio de la lactancia y al éxito del amamantamiento.'),
        ),
        Container(
          margin: const EdgeInsets.all(20),
          child: const Text(
              '•	Estimula el apego temprano a la madre y desarrolla una adecuada succión.'),
        ),
      ];
    } else if (pageId == 2) {
      return [
        Container(
          margin: const EdgeInsets.fromLTRB(20, 20, 0, 20),
          child: const Text(
            'Alimentación complementaria ',
            style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.black87),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(20),
          child: const Text(
              'A partir de los 6 meses debido al rápido crecimiento físico y desarrollo neurológico, las necesidades nutricionales son elevadas, por lo que necesitan empezar a consumir alimentos complementarios en pequeñas cantidades que permitan cubrir las brechas nutricionales, principalmente de energía y hierro.'),
        ),
        Container(
          width: 250,
          height: 250,
          margin: const EdgeInsets.fromLTRB(70, 0, 0, 0),
          child: Image.asset(
              '${GlobalVariables.logosCREDAddress}complementary_feeding.png'),
        ),
        Container(
          margin: const EdgeInsets.all(20),
          child: const Text(
              'La Organizacion Mundial de la Salud (OMS) indica que, a partir de los 6 meses de edad, los niños pueden comer alimentos bajo la forma de papillas o purés y alimentos semisólidos. Estas preparaciones son necesarias al comienzo, hasta que aparezca la habilidad de mordisquear (movimientos de la mandíbula hacia arriba y abajo) o masticar (uso de los dientes).'),
        ),
        Container(
          margin: const EdgeInsets.all(20),
          child: const Text(
            'Una apropiada alimentación complementariaconsiste en:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(20),
          child: const Text(
              '1.	Alimentos que sean ricos en energía, proteína de alto valor biológico y en micronutrientes (especialmente hierro, zinc, calcio, vitamina A, vitamina C y folatos).'),
        ),
        Container(
          margin: const EdgeInsets.all(20),
          child: const Text(
              '2.	En cantidades, consistencia y frecuencias apropiadas.'),
        ),
        Container(
          margin: const EdgeInsets.all(20),
          child: const Text(
              '3.	Fáciles de preparar con alimentos de la olla familiar y con alimentos accesibles  por las familias. '),
        ),
        Container(
          margin: const EdgeInsets.all(20),
          child: const Text(
              '4.	Adecuados en calidad microbiológica y libre de contaminación (patógenos, toxinas o sustancias químicas dañinas).'),
        ),
        Container(
          margin: const EdgeInsets.all(20),
          child: const Text('5.	Sin sal o condimentos.'),
        ),
        Container(
          margin: const EdgeInsets.all(20),
          child: const Text(
              '6.	Fácil de comer y fácil de ser aceptado por el infante.'),
        ),
        Container(
          margin: const EdgeInsets.all(20),
          child: const Text(
              'Fuente: Guias alimentarias para niños y niñas menores de dos años de edad'),
        ),
        // Container(
        //   margin: const EdgeInsets.all(20),
        //   child: RichText(
        //     text: TextSpan(
        //       text: 'Fuente',
        //       style: const TextStyle(color: Colors.blue),
        //       recognizer: TapGestureRecognizer()
        //         ..onTap = () {
        //           launchUrl(Uri.parse(
        //               'https://cdn.www.gob.pe/uploads/document/file/1811895/Gu%C3%ADas%20Alimentarias%20para%20niños%20y%20niñas%20menores%20a%202%20años%20de%20edad.pdf '));
        //         },
        //     ),
        //   ),
        // ),
      ];
    } else if (pageId == 3) {
      return [
        Container(
          margin: const EdgeInsets.fromLTRB(20, 20, 0, 20),
          child: const Text(
            'Alimentación saludable',
            style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.black87),
          ),
        ),
        Container(
          width: 150,
          height: 150,
          margin: const EdgeInsets.fromLTRB(110, 0, 0, 0),
          child: Image.asset(
              '${GlobalVariables.logosCREDAddress}healthy_feeding_1.jpg'),
        ),
        Container(
          margin: const EdgeInsets.all(20),
          child: const Text(
              'Se debe ofrecer una variedad de frutas y verduras de diferentes colores y sabores; si acostumbramos al paladar a sabores ácidos, como algunas frutas, o amargos, como algu- nas verduras, su consumo es mayor a lo largo de la vida.'),
        ),
        Container(
          margin: const EdgeInsets.all(20),
          child: const Text(
              'Utiliza en la alimentación de tu niño alimentos como los huevos, pescados y frutas cítricas desde el inicio de la alimentación complementaria.'),
        ),
        Container(
          margin: const EdgeInsets.all(20),
          child: const Text(
              'La importancia de incluir fuentes de origen animal en la alimentación complementaria tiene su fundamento en que el consumo de carne, hígado, cerdo y aves de corral están asociados con el buen crecimiento, el desarrollo psicomotor y el buen estado de hierro en la infancia, además de no producir aumento excesivo de adiposidad'),
        ),
        Container(
          width: 400,
          height: 250,
          child: Image.asset(
              '${GlobalVariables.logosCREDAddress}healthy_feeding_2.png'),
        ),
        Container(
          margin: const EdgeInsets.all(20),
          child: const Text(
              'Fuente: Guias alimentarias para niños y niñas menores de dos años de edad'),
        ),
        // Container(
        //   margin: const EdgeInsets.all(20),
        //   child: RichText(
        //     text: TextSpan(
        //       text: 'Fuente',
        //       style: const TextStyle(color: Colors.blue),
        //       recognizer: TapGestureRecognizer()
        //         ..onTap = () {
        //           launchUrl(Uri.parse(
        //               'https://cdn.www.gob.pe/uploads/document/file/1811895/Gu%C3%ADas%20Alimentarias%20para%20niños%20y%20niñas%20menores%20a%202%20años%20de%20edad.pdf'));
        //         },
        //     ),
        //   ),
        // ),
      ];
    }
    return Container(
      child: const Text('Error'),
    );
  }

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Flexible(
              fit: FlexFit.tight,
              child: Text(
                '${TranslateService.translate('homePage.cred')} - $name',
                style: const TextStyle(color: Colors.black),
                overflow: TextOverflow.visible,
              ),
            ),
            const Spacer(),
          ],
        ),
        backgroundColor: AppColors.colorCREDBoy,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: generatePage(pageId),
        ),
      ),

      //endDrawer: LateralMenuCenter.fromInsideCRED(1, idKid, name),
      //onEndDrawerChanged: actualizar(),
      bottomNavigationBar: BottomNavigationPage(),
    );
  }
}
