import 'package:flutter/material.dart';
import 'package:perusano/components/bottomNavigation.dart';

import '../../../services/translateService.dart';
import '../../../util/myColors.dart';

class ChildDevelopmentPage extends StatefulWidget {
  int idKid;
  String name;

  ChildDevelopmentPage({super.key, required this.idKid, required this.name});

  @override
  State<StatefulWidget> createState() =>
      _ChildDevelopmentPage(idKid: idKid, name: name);
}

class _ChildDevelopmentPage extends State<ChildDevelopmentPage> {
  int idKid;
  String name;

  _ChildDevelopmentPage({required this.idKid, required this.name});

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
                style: TextStyle(color: Colors.black),
                overflow: TextOverflow.visible,
              ),
            ),
            Spacer(),
          ],
        ),
        backgroundColor: AppColors.colorCREDBoy,
        elevation: 0,
      ),

      //endDrawer: LateralMenuCenter.fromInsideCRED(1, idKid, name),
      //onEndDrawerChanged: actualizar(),
      bottomNavigationBar: BottomNavigationPage(),
    );
  }
}
