import '../providers/app_settings_provider.dart';
import '../providers/google_events_provider.dart';
import '../widgets/edit_event_modal.dart';
import 'package:provider/provider.dart';

import '../models/event_data_source.dart';
import '../providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/calendar/v3.dart' as cal;
import 'package:syncfusion_flutter_calendar/calendar.dart' as sf;
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarView extends StatelessWidget {
  const CalendarView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var appData = Provider.of<AppSettingsProvider>(context);
    var auth = Provider.of<AuthProvider>(context);
    var gep = Provider.of<GoogleEventsProvider>(context);
    return FutureBuilder(
        future: gep.loadEvents(),
        builder: (context, snapshot) {
          if (auth.status == AuthState.registrated &&
              snapshot.connectionState == ConnectionState.done) {
            return sf.SfCalendar(
              initialSelectedDate: DateTime.now(),
              timeZone: 'Europe/Belgrade',
              headerHeight: 60,
              appointmentTimeTextFormat: 'HH:mm',
              showCurrentTimeIndicator: true,
              headerStyle: CalendarHeaderStyle(
                  textAlign: TextAlign.left,
                  backgroundColor: Colors.transparent,
                  textStyle: Theme.of(context).textTheme.headline6),
              scheduleViewSettings: ScheduleViewSettings(
                  hideEmptyScheduleWeek: true,
                  appointmentItemHeight: 70,
                  monthHeaderSettings: MonthHeaderSettings(
                      height: 50,
                      textAlign: TextAlign.left,
                      backgroundColor: Colors.transparent,
                      monthTextStyle: Theme.of(context).textTheme.subtitle1),
                  appointmentTextStyle: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500)),
              firstDayOfWeek: 1,
              view: appData.mainCalendarController.view ??
                  sf.CalendarView.schedule,
              controller: appData.mainCalendarController,
              dataSource: EventDataSource(
                  gep.events, Theme.of(context).colorScheme.surface),
              onTap: (CalendarTapDetails details) {
                dynamic appointments = details.appointments;
                if (appointments != null) {
                  showEditEventModal(context, appointments[0]);
                }
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  Future showEditEventModal(context, [cal.Event? event]) async {
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
