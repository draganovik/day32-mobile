import 'dart:convert';

import 'package:day32/providers/google_events_provider.dart';
import 'package:day32/widgets/edit_event_modal.dart';
import 'package:provider/provider.dart';

import '../models/EventDataSource.dart';
import '../providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/calendar/v3.dart' as cal;
import 'package:syncfusion_flutter_calendar/calendar.dart' as sf;
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({Key? key}) : super(key: key);

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthProvider, GoogleEventsProvider>(
      builder: (context, auth, gep, child) {
        if (auth.authClient != null && gep.events.isNotEmpty) {
          return sf.SfCalendar(
            headerHeight: 50,
            showCurrentTimeIndicator: true,
            headerStyle: const CalendarHeaderStyle(
                textAlign: TextAlign.left,
                backgroundColor: Colors.transparent,
                textStyle: TextStyle(
                  color: Colors.black87,
                )),
            scheduleViewSettings: const ScheduleViewSettings(
                hideEmptyScheduleWeek: true,
                appointmentItemHeight: 80,
                monthHeaderSettings: MonthHeaderSettings(
                    height: 50,
                    textAlign: TextAlign.left,
                    backgroundColor: Colors.transparent,
                    monthTextStyle: TextStyle(
                      color: Colors.black87,
                    )),
                appointmentTextStyle:
                    TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            firstDayOfWeek: 1,
            view: sf.CalendarView.schedule,
            dataSource: EventDataSource(gep.events),
            onTap: (CalendarTapDetails details) {
              dynamic appointments = details.appointments;
              DateTime date = details.date!;
              CalendarElement element = details.targetElement;
              if (appointments != null) {
                showEditEventModal(appointments[0]).then((value) {
                  if (value != null) {
                    Future.delayed(const Duration(seconds: 1), () {
                      setState(() {
                        gep.loadEvents();
                      });
                    });
                  }
                });
              }
            },
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Future showEditEventModal([cal.Event? event]) async {
    await showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: false,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      context: context,
      builder: (ctx) {
        return EditEventModal(editEvent: event);
      },
    );
  }
}
