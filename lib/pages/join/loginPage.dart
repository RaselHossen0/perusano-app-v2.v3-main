import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:perusano/pages/join/createUserPage.dart';
import 'package:perusano/pages/healthCenter/homeCenterPage.dart';
import 'package:perusano/services/apis/join/loginService.dart';
import 'package:perusano/util/globalVariables.dart';
import 'package:perusano/util/internVariables.dart';
import 'package:perusano/util/myColors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/synchronization/download.dart';
import '../../services/translateService.dart';
import '../family/familyMember/choose_family_member_page.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginPage();
  }
}

class _LoginPage extends State<LoginPage> {
  Languages chosenLanguage = Languages.ES;

  late Map dataUser;

  bool isLoading = false;

  final TextEditingController userController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  // Calls the login api and validate if login is right
  Future<bool> _login(user, pass) async {
    dataUser =
        await LoginService.validate(userController.text, passController.text);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String? stringValue = prefs.getString('token');

    if (dataUser['id'] > 0) {
      return true;
    }
    return false;
  }

  // Go to different homepage checking isHealthPerson flag
  redirigir() {
    InternVariables.idUser = dataUser['id'] ?? 1;
    InternVariables.idFamily = dataUser['idFamily'] ?? 1;
    InternVariables.userName = dataUser['username'] ?? 'Anonymous';

    if (dataUser['is_health_person']) {
      InternVariables.isHealthPeson = true;
      return HomeCenterPage();
    } else {
      InternVariables.isHealthPeson = false;
      //return HomePage();
      return ChooseFamilyMemberPage(idFamily: dataUser['id']);
    }
  }

  var title = 'My app';
  //LoginPage({required Key key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            GlobalVariables.appName,
          ),
        ),
        body: Center(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                width: 200,
                height: 200,
                child: Image.asset(
                    '${GlobalVariables.logosAddress}thumbnail_mama alimentando bebe logo app.png'),
              ),
              Container(
                  padding: const EdgeInsets.fromLTRB(10, 20, 30, 10),
                  child: TextFormField(
                    controller: userController,
                    decoration: InputDecoration(
                      icon: const Icon(Icons.person),
                      label: Text(TranslateService.translate('loginPage.user')),
                    ),
                  )),
              Container(
                  padding: const EdgeInsets.fromLTRB(10, 20, 30, 10),
                  child: TextFormField(
                    controller: passController,
                    obscureText: true,
                    decoration: InputDecoration(
                      icon: const Icon(Icons.lock),
                      label: Text(
                          TranslateService.translate('loginPage.password')),
                      //labelText: TranslateService.translate('login.user'),
                    ),
                  )),
              Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: RadioListTile(
                          title: const Text('Español'),
                          value: "ES",
                          groupValue: GlobalVariables.language,
                          onChanged: (value) {
                            setState(() {
                              GlobalVariables.language = value.toString();

                              TranslateService.load();
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile(
                          title: const Text("English"),
                          value: "EN",
                          groupValue: GlobalVariables.language,
                          onChanged: (value) {
                            setState(() {
                              GlobalVariables.language = value.toString();
                              print(GlobalVariables.language);
                              TranslateService.load();
                            });
                          },
                        ),
                      ),
                    ],
                  )),
              Container(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: SizedBox(
                    width: 100.0,
                    height: 40.0,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(AppColors.primary),
                        foregroundColor: MaterialStateProperty.all<Color>(
                            AppColors.font_primary),
                      ),
                      onPressed: () async {
                        if (await _login(
                            userController.text, passController.text)) {
                          setState(() {
                            isLoading = true;
                          });
                          if (await GlobalVariables.isConnected()) {
                            await DownloadService()
                                .downloadData(dataUser['id']);
                          }
                          // ignore: use_build_context_synchronously
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => redirigir()),
                          ).then((value) => {});
                        } else {
                          final snackBar = SnackBar(
                              content: Text(TranslateService.translate(
                                  'loginPage.login_failed')));

                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      },
                      child: isLoading
                          ? Container(
                              padding: const EdgeInsets.all(5),
                              child: const CircularProgressIndicator(
                                  color: Colors.white),
                            )
                          : Text(
                              TranslateService.translate('loginPage.submit')),
                    ),
                  )),
              Container(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(TranslateService.translate(
                        'loginPage.registerMessage')),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CreateUserPage()),
                          );
                        },
                        child: Text(
                            TranslateService.translate('loginPage.register')))
                  ],
                ),
              ),
            ],
          ),
        ))
        // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
