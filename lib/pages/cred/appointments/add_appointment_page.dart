import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:perusano/util/class/cred/appointments/appointmentClass.dart';
import 'package:intl/intl.dart';
import 'package:perusano/util/class/join/date_picker/date_picker.dart';
import 'package:perusano/util/class/join/date_picker/i18n/date_picker_i18n.dart';
// import 'package:timezone/browser.dart';

import '../../../components/lateralMenu.dart';
import '../../../services/apis/cred/credRegisterCenter.dart';
import '../../../services/fileManagement/cred/appointmentFM.dart';
import '../../../services/notificationService.dart';
import '../../../services/translateService.dart';
import '../../../util/globalVariables.dart';
import '../../../util/internVariables.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../../../util/myColors.dart';

class AddAppointmentPage extends StatefulWidget {
  int idKid = 0;
  String kidName = '';

  AddAppointmentPage({required this.idKid, required this.kidName});

  @override
  State<AddAppointmentPage> createState() =>
      _AddAppointmentPage(idKid: idKid, kidName: kidName);
}

class _AddAppointmentPage extends State<AddAppointmentPage> {
  int idKid = 0;
  String kidName = '';

  AppointmentFM storage = AppointmentFM();

  _AddAppointmentPage({required this.idKid, required this.kidName});

  final _formKey = GlobalKey<FormState>();

  TextEditingController descriptionController = new TextEditingController();

  DateTime selectedDate = DateTime.now();
  late String formattedDate = DateFormat().add_yMMMd().format(selectedDate);

  // This method show the date selector
  Future<void> _selectDate(BuildContext context) async {
    var picked = await DatePicker.showSimpleDatePicker(
      context,
      initialDate: selectedDate,
      firstDate: DateTime.parse(InternVariables.kid['birthday']),
      lastDate: DateTime(2101),
      dateFormat: "dd-MMMM-yyyy",
      locale: GlobalVariables.language == 'ES'
          ? DateTimePickerLocale.es
          : DateTimePickerLocale.en_us,
      titleText: TranslateService.translate('addAppointment.datePickerTitle'),
      confirmText: TranslateService.translate('addAppointment.accept'),
      cancelText: TranslateService.translate('addAppointment.cancel'),
    );

    // final DateTime? picked = await showDatePicker(
    //     builder: (context, child) {
    //       return Theme(
    //         data: Theme.of(context).copyWith(
    //           colorScheme: ColorScheme.light(
    //             primary: AppColors.colorCREDBoy, // header background color
    //             onPrimary: Colors.black, // header text color
    //             onSurface: Colors.black, // body text color
    //           ),
    //           textButtonTheme: TextButtonThemeData(
    //             style: ButtonStyle(
    //               backgroundColor:
    //                   MaterialStateProperty.all<Color>(AppColors.colorCREDBoy),
    //               foregroundColor:
    //                   MaterialStateProperty.all<Color>(AppColors.font_primary),
    //             ),
    //           ),
    //           textTheme: const TextTheme(
    //             labelSmall:
    //                 TextStyle(fontSize: 16, overflow: TextOverflow.visible),
    //           ),
    //         ),
    //         child: child!,
    //       );
    //     },
    //     helpText: TranslateService.translate('addAppointment.datePickerTitle'),
    //     confirmText: TranslateService.translate('addAppointment.accept'),
    //     cancelText: TranslateService.translate('addAppointment.cancel'),
    //     context: context,
    //     initialDate: selectedDate,
    //     firstDate: DateTime.parse(InternVariables.kid['birthday']),
    //     lastDate: DateTime(2101),
    //     locale: Locale(
    //         GlobalVariables.language.toLowerCase(), GlobalVariables.language));
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        formattedDate = DateFormat().add_yMMMd().format(selectedDate);
      });
    }
  }

  // This method add the register to local storage and, if exist a connection, into the network database
  Future<bool> addAppointment() async {
    Map localAnswer = {};
    Map globalAnswer = {};
    tz.initializeTimeZones();
    var local = tz.getLocation('Europe/London');
    tz.setLocalLocation(local);
    if (selectedDate.isAfter(DateTime.now()))
      await _scheduleNotification(idKid, "Appointment Reminder",
          "Your appointment is today!", selectedDate);
    else {
      await _showImmediateNotification(
          idKid, "Appointment Reminder", "Your appointment is today!");
    }
    AppointmentRegister register = AppointmentRegister(
        0,
        idKid,
        0,
        formattedDate,
        selectedDate.toString(),
        null,
        null,
        descriptionController.text,
        'Pendiente',
        2,
        false,
        false);

    //tz.setLocalLocation(tz.getLocation(Location('Peru'));
    Map registerJson = register.toJson();
    await storage.writeRegister(registerJson);
    localAnswer = registerJson;
    final oneDayBefore = selectedDate.subtract(Duration(days: 1));
    if (selectedDate.isAfter(DateTime.now()))
      await _scheduleNotification(idKid, "Appointment Reminder",
          "Your appointment is tomorrow!", oneDayBefore);

    bool isConnected = await GlobalVariables.isConnected();
    if (isConnected) {
      globalAnswer = await CredRegisterCenter().addAppointment(
        InternVariables.kid['id'],
        selectedDate.toString(),
        descriptionController.text,
      );
      await storage.updateIdRegister(
          idKid, localAnswer['idLocal'], globalAnswer['id']);
    }

    if (localAnswer['id'] >= 0) {
      return true;
    }
    return false;
  }

  Future<void> _showImmediateNotification(
      int id, String title, String body) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      importance: Importance.max,
      priority: Priority.high,
    );
    // var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      platformChannelSpecifics,
    );
  }

  Future<void> _scheduleNotification(
      int id, String title, String body, DateTime scheduledDate) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      importance: Importance.max,
      priority: Priority.high,
    );
    // var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
  // In the _scheduleNotification function, we use the flutterLocalNotificationsPlugin to schedule a notification at the specified date and time. Adjust the notification details (e.g., title, body, channel settings) according to your app's requirements.
  //
  // Don't forget to initialize the flutterLocalNotificationsPlugin and configure it properly in your app. Also, make sure to handle any necessary permissions for notifications.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'CRED - ${kidName}',
              style: const TextStyle(color: Colors.black),
            ),
          ],
        ),
        backgroundColor: AppColors.colorCREDBoy,
        elevation: 0,
      ),
      endDrawer: LateralMenu(),
      body: Container(
        margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                child: Text(
                  TranslateService.translate('addAppointment.title'),
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                child: Row(
                  children: [
                    Flexible(
                      child: Container(
                          padding: const EdgeInsets.fromLTRB(10, 20, 30, 10),
                          child: Form(
                            key: _formKey,
                            child: TextFormField(
                              validator: (value) {
                                if (value == '') {
                                  return TranslateService.translate(
                                      'addAppointment.validateText');
                                }
                              },
                              controller: descriptionController,
                              maxLines: null,
                              decoration: InputDecoration(
                                icon: const Icon(Icons.description),
                                label: Text(TranslateService.translate(
                                    'addAppointment.description')),
                              ),
                            ),
                          )),
                    ),
                  ],
                ),
              ),
              Divider(color: AppColors.colorCREDBoy, thickness: 5, height: 30),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 20, 30, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      child: Text(
                        TranslateService.translate('addAppointment.date'),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    Container(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              AppColors.colorCREDBoy),
                          foregroundColor: MaterialStateProperty.all<Color>(
                              AppColors.font_primary),
                        ),
                        onPressed: () => _selectDate(context),
                        child: Text(formattedDate),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      bool answer = await addAppointment();

                      if (answer == true) {
                        final snackBar = SnackBar(
                          content: Text(TranslateService.translate(
                              'addAppointment.confirm')),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        Navigator.pop(context);
                      } else {
                        final snackBar = SnackBar(
                          content: Text(TranslateService.translate(
                              'addAppointment.denied')),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        AppColors.colorCREDBoy),
                    foregroundColor: MaterialStateProperty.all<Color>(
                        AppColors.font_primary),
                  ),
                  child: Text(
                    TranslateService.translate('addAppointment.add'),
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
