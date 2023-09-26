/*
* this file will control the bottonNavigation that it can see of the bottom of a couple of pages
* */
import 'package:flutter/material.dart';
import 'package:perusano/pages/calendar/calendar_page.dart';
import 'package:perusano/pages/home_page.dart';
import 'package:perusano/pages/family/myFamilyPage.dart';
import '../services/translateService.dart';

class BottomNavigationPage extends StatefulWidget {
  @override
  State<BottomNavigationPage> createState() => _BottomNavigationPage();
}

class _BottomNavigationPage extends State<BottomNavigationPage> {
  _changePage(index) {
    if (index == 0) {
      // Navigator.of(context).popUntil(ModalRoute.withName('/home'));
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else if (index == 1) {
      // Navigator.of(context).popUntil(ModalRoute.withName('/home'));
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => CalendarPage()),
      );
    } else if (index == 2) {
      // Navigator.of(context).popUntil(ModalRoute.withName('/home'));
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => MyFamilyPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: const Icon(Icons.home),
          label: TranslateService.translate('bottomNavBar.home'),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.calendar_month),
          label: TranslateService.translate('bottomNavBar.calendar'),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.supervised_user_circle),
          label: TranslateService.translate('bottomNavBar.account'),
        ),
      ],
      onTap: _changePage,
      unselectedItemColor: Colors.black,
      selectedItemColor: Colors.black,
    ));
  }
}
