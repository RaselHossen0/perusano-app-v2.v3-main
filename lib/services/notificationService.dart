import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:clock/clock.dart';

import 'package:flutter_native_timezone/flutter_native_timezone.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> initNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('icono_notificacion');

  const DarwinInitializationSettings initializationSettingsIOS =
  DarwinInitializationSettings();

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

int id=0;


Future<void> showNotificacion(String scheduledDate, String title, String body) async {
  const AndroidNotificationDetails androidNotificationDetails =
  AndroidNotificationDetails(
    'your channel id',
    'your channel name',
    importance: Importance.max,
    priority: Priority.high,
  );

  const NotificationDetails notificationDetails = NotificationDetails(
    android: androidNotificationDetails,
  );

  /*await flutterLocalNotificationsPlugin.show(
      1,
      'Titulo de notificacion',
      'Esta es una notificación de prueba para mostrar en el canal. Los quiero mucho.',
      notificationDetails);*/



  String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();



  /*final timeZone = tz.TimeZone();

  // The device's timezone.
  String timeZoneName = await timeZone.getTimeZoneName();*/

  // Find the 'current location'
  final location = tz.getLocation(timeZoneName);

  //final scheduledDate = tz.TZDateTime.from(dateTime, location);


  tz.TZDateTime fecha = tz.TZDateTime.parse(location , scheduledDate);



  String offsetString = fecha.timeZoneOffset.toString().split(':')[0];
  int offset = int.parse(offsetString);

  if(offset<0 || offset>0){
    offset = offset * (-1);
  }

  tz.TZDateTime finalDate = fecha.add(Duration(hours: offset));



  await flutterLocalNotificationsPlugin.zonedSchedule(
      id, title, body, finalDate,
      notificationDetails,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true);
}

