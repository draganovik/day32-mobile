import 'dart:convert';

import 'package:day32/models/EventDataSource.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart' as sf;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:http/http.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({Key? key}) : super(key: key);

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  List<Event>? source;
  List<Event> _getDataSource() {
    final List<Event> events = <Event>[];
    for (var event in source!) {
      events.add(event);
    }
    return events;
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      CalendarApi.calendarScope,
    ],
  );
  Client httpClient = Client();

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    } finally {
      httpClient = (await _googleSignIn.authenticatedClient())!;
      var calendarApi = CalendarApi(httpClient);
      var events = await calendarApi.events
          .list('mladenoneacc@gmail.com', timeMin: DateTime.now());
      setState(() {
        source = events.items;
      });
      //print(json.encode(events));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: source == null
            ? Center(
                child: ElevatedButton(
                  child: const Text('Google Sign In'),
                  onPressed: () => _handleSignIn(),
                ),
              )
            : sf.SfCalendar(
                firstDayOfWeek: 1,
                view: sf.CalendarView.schedule,
                dataSource: EventDataSource(_getDataSource()),
                onTap: (CalendarTapDetails details) {
                  dynamic appointments = details.appointments;
                  DateTime date = details.date!;
                  CalendarElement element = details.targetElement;
                  if (appointments != null) {
                    print(json.encode(appointments));
                  }
                },
                /*monthViewSettings: const sf.MonthViewSettings(
                    appointmentDisplayMode:
                        sf.MonthAppointmentDisplayMode.appointment),*/
              ));
  }
}
