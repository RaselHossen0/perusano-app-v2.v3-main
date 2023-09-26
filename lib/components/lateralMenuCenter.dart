/*
* this class will control an especial Drawer where only health personal will can use.
* */

import 'package:flutter/material.dart';
import 'package:perusano/util/globalVariables.dart';
import 'package:get/get.dart';

import '../pages/cred/appointments/add_appointment_page.dart';
import '../pages/cred/ironSupplement/add_iron_supplement_page.dart';
import '../pages/healthCenter/addVaccinePage.dart';
import '../pages/cred/weightHeight/add_weight_and_height.dart';
import '../pages/family/kids/create_kid_page.dart';
import '../pages/join/createUserPage.dart';
import '../services/translateService.dart';
import '../util/controller/connectionStatus/connectionStatusController.dart';

final internetController = Get.put(ConnectionStatusController());

class LateralMenuCenter extends StatefulWidget {
  int idFamily = 0;
  int idKid = 0;
  int opcionCRED = 0;
  String kidName = '';
  /*bool fromDescarte = false;
  bool fromVaccines = false;
  bool fromAppointments = false;
  bool fromWeightHeight = false;
  bool fromIronSupplement = false;*/

  LateralMenuCenter();
  LateralMenuCenter.fromFamily(this.idFamily);
  LateralMenuCenter.fromKid(this.idKid);
  LateralMenuCenter.fromInsideCRED(this.opcionCRED, this.idKid, this.kidName);

  @override
  State<LateralMenuCenter> createState() => _LateralMenuCenterState();
}

class _LateralMenuCenterState extends State<LateralMenuCenter> {
  /*LateralMenuCenter.fromDescarte(this.fromDescarte);
  LateralMenuCenter.fromVaccines(this.fromVaccines);
  LateralMenuCenter.fromAppointments(this.fromAppointments);
  LateralMenuCenter.fromWeightHeight(this.fromWeightHeight);
  LateralMenuCenter.fromIronSupplement(this.fromIronSupplement);*/
  permitirDeslogueo() async {
    bool isConnected = await GlobalVariables.isConnected();

    if (isConnected) {
      print('conectado');
    } else {
      print('no conectado');
    }
  }

  Widget presentaOpciones(BuildContext context) {
    if (widget.idFamily == 0 && widget.idKid == 0 && widget.opcionCRED == 0) {
      return addUser(context);
    } else if (widget.idFamily != 0) {
      return Column(
        children: [addKid(context), addFamilyMember(context)],
      );
    } else if (widget.opcionCRED > 0 && widget.idKid > 0) {
      switch (widget.opcionCRED) {
        case 1:
          {
            return addDescarte(context);
          }
          break;
        case 2:
          {
            return addVaccine(context);
          }
          break;
        case 3:
          {
            return addAppointment(context);
          }
          break;
        case 4:
          {
            return addWeightHeight(context);
          }
          break;
        case 5:
          {
            return addIronSupplement(context);
          }
          break;
        default:
          {
            return Container();
          }
          break;
      }
    } else {
      return Container();
    }
  }

  Widget addUser(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.supervised_user_circle),
      title: Text(TranslateService.translate('lateralMenuCenterPage.add_user')),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CreateUserPage()),
        );
      },
    );
  }

  Widget addKid(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.supervised_user_circle),
      title: Text(TranslateService.translate('lateralMenuCenterPage.add_kid')),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CreateKidPage(widget.idFamily)),
        );
      },
    );
  }

  Widget addFamilyMember(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.settings),
      title:
          Text(TranslateService.translate('lateralMenuCenterPage.add_member')),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Redirigiendo a página de configuración')));
      },
    );
  }

  Widget addDescarte(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.supervised_user_circle),
      title: Text(
          TranslateService.translate('lateralMenuCenterPage.add_anemia_check')),
      onTap: () {
        /*Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddAnemiaCheckPage(idKid: widget.idKid, kidName: widget.kidName,)),
        );*/
      },
    );
  }

  Widget addVaccine(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.supervised_user_circle),
      title:
          Text(TranslateService.translate('lateralMenuCenterPage.add_vaccine')),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AddVaccinePage(
                    idKid: widget.idKid,
                    kidName: widget.kidName,
                  )),
        );
      },
    );
  }

  Widget addAppointment(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.supervised_user_circle),
      title: Text(
          TranslateService.translate('lateralMenuCenterPage.add_appointment')),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AddAppointmentPage(
                    idKid: widget.idKid,
                    kidName: widget.kidName,
                  )),
        );
      },
    );
  }

  Widget addWeightHeight(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.supervised_user_circle),
      title: Text(TranslateService.translate(
          'lateralMenuCenterPage.add_weight_height')),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AddWeightAndHeightPage(
                    idKid: widget.idKid,
                    kidName: widget.kidName,
                  )),
        );
      },
    );
  }

  Widget addIronSupplement(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.supervised_user_circle),
      title: Text(TranslateService.translate(
          'lateralMenuCenterPage.add_iron_supplement')),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AddIronSupplementPage(
                    idKid: widget.idKid,
                    kidName: widget.kidName,
                  )),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(padding: EdgeInsets.zero, children: <Widget>[
      DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.lightBlue,
          ),
          child: Column(
            children: [],
          )),
      presentaOpciones(context),
      ListTile(
        leading: Icon(Icons.settings),
        title: Text('Configuración'),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Redirigiendo a página de configuración')));
        },
      ),
      ListTile(
        leading: Icon(Icons.logout),
        title: Text('Cerrar sesión'),
        onTap: () async {
          await permitirDeslogueo();
        },
      ),
    ]));
  }
}
