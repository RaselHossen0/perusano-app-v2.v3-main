import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

//import 'package:perusano/database/databaseCare.dart';
import 'package:perusano/pages/family/familyMember/choose_family_member_page.dart';
import 'package:perusano/pages/cred/cred_principal_page.dart';
import 'package:perusano/pages/join/loginPage.dart';
import 'package:perusano/services/fileManagement/fileManagement.dart';
import 'package:perusano/services/notificationService.dart';
import 'package:perusano/services/synchronization/upload.dart';
import 'package:perusano/services/translateService.dart';
import 'package:perusano/util/controller/connectionStatus/connectionCheck.dart';
import 'package:perusano/util/globalVariables.dart';
import 'package:perusano/util/internVariables.dart';
import 'package:perusano/util/myColors.dart';
import 'package:perusano/pages/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// Usually this will be initialized one time at the start of the app
final internetChecker = CheckInternetConnection();

class Start extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Start();
}

class _Start extends State<Start> {
  // This method redirect the page to Login or ChooseFamilyMember depending if is already login
  Future<void> redirigir() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String? stringValue = prefs.getString('token');
    int? idUser = prefs.getInt('idUser');
    int? idFamily = prefs.getInt('idFamily');
    String? username = prefs.getString('username');
    await GlobalVariables.isConnected();

    if (stringValue != null &&
        stringValue != '' &&
        idUser != null &&
        idUser != 0 &&
        idFamily != null &&
        idFamily != 0) {
      InternVariables.idUser = idUser;
      InternVariables.idFamily = idFamily;
      InternVariables.userName = username!;
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ChooseFamilyMemberPage(idFamily: InternVariables.idFamily)),
      ).then((value) => SystemNavigator.pop());
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
          settings: const RouteSettings(name: "/login"),
        ),
      ).then((value) => redirigir());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GlobalVariables.isConnected();
    redirigir();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}

void main() async {
  runApp(const MyApp());
  //await DatabaseCare().asignDatabase();
  await initNotifications();

  Future<String> Function() path = await FileManagement.localPath;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    TranslateService.load();
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('es'), // Spanish
      ],
      title: 'Perusano',
      initialRoute: '/',
      routes: {
        '/home': (context) => HomePage(),
        '/login': (context) => LoginPage(),
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: AppColors.primary,
        // useMaterial3: true,
      ),
      home: Start(),
    );
  }
}
