import 'package:flutter/material.dart';
import 'package:perusano/components/bottomNavigation.dart';
import 'package:perusano/util/class/calendar/eventClass.dart';
import 'package:perusano/util/class/join/date_picker/date_picker.dart';
import 'package:perusano/util/class/join/date_picker/i18n/date_picker_i18n.dart';
import 'package:perusano/util/internVariables.dart';
import 'package:intl/intl.dart';
import 'package:perusano/util/myColors.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../services/fileManagement/calendar/eventFM.dart';
import '../../services/translateService.dart';
import '../../services/notificationService.dart';

import 'package:timezone/data/latest_all.dart' as tzl;
import 'package:timezone/timezone.dart' as tz;

import '../../util/globalVariables.dart';

// Is a small class chich represents the event
class Event {
  final String title;
  final String date;
  Event({required this.title, required this.date});

  String toString() {
    return '$date - $title';
  }
}

class CalendarPage extends StatefulWidget {
  @override
  State<CalendarPage> createState() => _CalendarPage();
}

class _CalendarPage extends State<CalendarPage> {
  Map<DateTime, List<Event>> selectedEvents = {};
  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now().toUtc();
  DateTime focusedDay = DateTime.now();

  List<Event> _getEventsfromDay(DateTime date) {
    return selectedEvents[date] ?? [];
  }

  List<DateTime> _getSortedDatesWithEvents() {
    List<DateTime> eventDates = selectedEvents.keys.toList();
    eventDates.sort((a, b) {
      //sorting in descending order
      return a.compareTo(b);
    });
    return eventDates;
  }

  bool isCurrentDay = true;
  List dataObt = [];
  List data = [];
  Map<DateTime, List<Event>> eventos = {};

  final DateTime _dateTime = DateTime.now();

  EventFM storage = EventFM();

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _eventController = TextEditingController();

  ///Time
  TimeOfDay selectedTime = TimeOfDay.now();
  late String formattedTime = selectedTime.format(context);

  late String formattedDate = DateFormat().add_yMMMd().format(selectedDay);

  //This method allows show the time selector
  _selectedTime() async {
    var picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      helpText: TranslateService.translate('calendarPage.timePickerTitle'),
      confirmText: TranslateService.translate('calendarPage.accept'),
      cancelText: TranslateService.translate('calendarPage.cancel'),
    );

    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
        formattedTime = selectedTime.format(context);
        Navigator.pop(context);
        showCreateEventDialog();
      });
    }
  }

  //This method allows show the date selector
  _selectDate() async {
    var picked = await DatePicker.showSimpleDatePicker(
      context,
      initialDate: selectedDay,
      firstDate: DateTime.parse(InternVariables.kid['birthday']),
      lastDate: DateTime(2101),
      dateFormat: "dd-MMMM-yyyy",
      locale: GlobalVariables.language == 'ES'
          ? DateTimePickerLocale.es
          : DateTimePickerLocale.en_us,
      titleText: TranslateService.translate('calendarPage.datePickerTitle'),
      confirmText: TranslateService.translate('calendarPage.accept'),
      cancelText: TranslateService.translate('calendarPage.cancel'),
    );

    // var picked = await showDatePicker(
    //     helpText: TranslateService.translate('addAnemiaCheck.datePickerTitle'),
    //     confirmText: TranslateService.translate('addAnemiaCheck.accept'),
    //     cancelText: TranslateService.translate('addAnemiaCheck.cancel'),
    //     context: context,
    //     initialDate: selectedDay,
    //     firstDate: DateTime(1960),
    //     lastDate: DateTime(2101),
    //     locale: Locale(
    //         GlobalVariables.language.toLowerCase(), GlobalVariables.language));
    if (picked != null && picked != selectedDay) {
      setState(() {
        selectedDay = picked;
        formattedDate = DateFormat().add_yMMMd().format(selectedDay);
        Navigator.pop(context);
        showCreateEventDialog();
      });
    }
  }

  //this method loads events for local storage
  loadEvents() async {
    bool isConnected = await GlobalVariables.isConnected();

    /*if (isConnected){
      dataObt = await CalendarService().getEventsByFamilyId(InternVariables.idUser);
    }else{
      dataObt = await storage.readFile();
    }*/
    dataObt = await storage.readFile();
    setState(() {
      data = dataObt;
    });
    await creaMapaEventos();
  }

  // This method shows the events in the calendar
  creaMapaEventos() {
    for (var value in data) {
      if (selectedEvents[DateTime.parse(value['date'])] != null) {
        selectedEvents[DateTime.parse(value['date'])]!.add(
          Event(title: value['description'], date: value['date']),
        );
      } else {
        selectedEvents[DateTime.parse(value['date'])] = [
          Event(title: value['description'], date: value['date']),
        ];
      }
    }
  }

  showCreateEventDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        title: Text(TranslateService.translate('calendarPage.addEvent')),
        content: Container(
          height: 200,
          margin: const EdgeInsets.fromLTRB(10, 10, 10, 20),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    validator: (value) {
                      if (value == '') {
                        return TranslateService.translate(
                            'calendarPage.validateText');
                      }
                    },
                    controller: _eventController,
                    decoration: InputDecoration(
                      icon: const Icon(Icons.doorbell),
                      label: Text(
                          TranslateService.translate('calendarPage.eventName')),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              AppColors.colorCalendar)),
                      onPressed: () => _selectDate(),
                      child: Text(DateFormat('d MMMM yyyy',
                              GlobalVariables.language.toLowerCase())
                          .format(selectedDay)),
                    ),
                  ),
                  Container(
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              AppColors.colorCalendar)),
                      onPressed: () => _selectedTime(),
                      child: Text(formattedTime),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          Container(
            padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.transparent),
                shadowColor:
                    MaterialStateProperty.all<Color>(Colors.transparent),
              ),
              child: Text(TranslateService.translate('calendarPage.cancel')),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      AppColors.colorCalendar)),
              child: Text(TranslateService.translate('calendarPage.accept')),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  String hora = formattedTime.toString();
                  String horas = hora.split(':')[0];
                  String minutos = hora.split(':')[1];
                  DateTime fechaFinal2;
                  DateTime result = DateTime.now();
                  String dateToJson = selectedDay.toString();
                  DateTime mapDate;
                  if (isCurrentDay) {
                    final dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss.sss'Z'");
                    final dateJsonFormat =
                        DateFormat("yyyy-MM-dd 00:00:00.000'Z'");
                    DateTime currentDate = DateTime.utc(selectedDay.year,
                        selectedDay.month, selectedDay.day, 0, 0, 0);
                    result = currentDate.add(Duration(
                        hours: int.parse(horas), minutes: int.parse(minutos)));
                    fechaFinal2 = DateTime.parse(dateFormat.format(result));
                    dateToJson = dateJsonFormat.format(result);
                    mapDate = fechaFinal2;
                  } else {
                    selectedDay.subtract(Duration(
                        hours: selectedDay.hour,
                        minutes: selectedDay.minute,
                        seconds: selectedDay.second,
                        milliseconds: selectedDay.millisecond,
                        microseconds: selectedDay.microsecond));
                    fechaFinal2 = selectedDay.add(Duration(
                        hours: int.parse(horas), minutes: int.parse(minutos)));
                    mapDate = fechaFinal2;
                  }

                  if (_eventController.text.isEmpty) {
                  } else {
                    if (selectedEvents[mapDate] != null) {
                      selectedEvents[mapDate]!.add(
                        Event(title: _eventController.text, date: ''),
                      );
                    } else {
                      selectedEvents[mapDate] = [
                        Event(title: _eventController.text, date: ''),
                      ];
                    }
                  }
                  EventRegister eventRegister = EventRegister(
                      InternVariables.idFamily,
                      0,
                      dateToJson,
                      '',
                      '',
                      _eventController.text,
                      false);
                  Map registerJson = eventRegister.toJson();
                  await storage.writeRegister(registerJson);
                  showNotificacion(fechaFinal2.toString(), 'Notificación',
                      _eventController.text);
                  Navigator.pop(context);
                  _eventController.clear();
                  setState(() {});
                  return;
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget showEvents() {
    List<DateTime> dates = _getSortedDatesWithEvents();
    if (dates.isNotEmpty) {
      return Container(
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 100),
          child: Column(
            children: dates
                .map(
                  (date) => Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          DateFormat('d MMMM yyyy',
                                  GlobalVariables.language.toLowerCase())
                              .format(date),
                          style: const TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Column(
                        children: _getEventsfromDay(date)
                            .map(
                              (Event event) => Container(
                                margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                width: 350,
                                height: 60,
                                decoration: BoxDecoration(
                                    color: AppColors.colorCalendar,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 20, 20, 20),
                                  child: Row(
                                    children: [
                                      Text(
                                        event.title,
                                      ),
                                      const Spacer(),
                                      Text(
                                        DateFormat('hh:mm a').format(date),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      )
                    ],
                  ),
                )
                .toList(),
          ));
    }
    return Container();
  }

  @override
  void initState() {
    super.initState();

    loadEvents();

    tzl.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Etc/GMT-5'));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.colorCalendar,
        title: Text(TranslateService.translate('homePage.calendar')),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TableCalendar(
              locale: GlobalVariables.language,
              focusedDay: selectedDay,
              firstDay: DateTime(1990),
              lastDay: DateTime(2101),
              availableCalendarFormats: {
                CalendarFormat.month:
                    TranslateService.translate('calendarPage.month'),
                CalendarFormat.twoWeeks:
                    TranslateService.translate('calendarPage.2weeks'),
                CalendarFormat.week:
                    TranslateService.translate('calendarPage.week')
              },
              calendarFormat: format,
              onFormatChanged: (CalendarFormat _format) {
                setState(() {
                  format = _format;
                });
              },
              startingDayOfWeek: StartingDayOfWeek.sunday,
              daysOfWeekVisible: true,

              //Day Changed
              onDaySelected: (DateTime selectDay, DateTime focusDay) {
                setState(() {
                  isCurrentDay = false;
                  selectedDay = selectDay;
                  focusedDay = focusDay;
                });
              },
              selectedDayPredicate: (DateTime date) {
                return isSameDay(selectedDay, date);
              },

              eventLoader: _getEventsfromDay,

              //To style the Calendar
              calendarStyle: CalendarStyle(
                markersAlignment: Alignment.topRight,
                isTodayHighlighted: true,
                selectedDecoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                selectedTextStyle: const TextStyle(color: Colors.white),
                todayDecoration: BoxDecoration(
                  color: Colors.cyan,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                defaultDecoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                weekendDecoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              headerStyle: HeaderStyle(
                headerPadding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
                leftChevronVisible: false,
                rightChevronVisible: false,
                titleTextStyle: const TextStyle(fontSize: 35),
                formatButtonVisible: true,
                formatButtonShowsNext: false,
                formatButtonDecoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                formatButtonTextStyle: const TextStyle(
                  color: Colors.white,
                ),
              ),
              // builder
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, day, events) => events.isNotEmpty
                    ? Container(
                        width: 18,
                        height: 18,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: Colors.redAccent,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${events.length}',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 10),
                        ),
                      )
                    : null,
              ),
            ),
            Divider(color: AppColors.colorCalendar, thickness: 5, height: 30),
            showEvents(),
          ],
        ),
      ),
      floatingActionButton: Container(
        height: 50,
        width: GlobalVariables.language == 'ES' ? 190 : 150,
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Container(
          width: 200,
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(AppColors.colorAddButtons),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
            onPressed: () => {showCreateEventDialog()},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Icon(
                  Icons.add_circle,
                  color: Colors.white,
                  size: 24,
                ),
                Expanded(
                  child: Text(
                    TranslateService.translate('calendarPage.addEvent'),
                    style: const TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: BottomNavigationPage(),
    );
  }
}
