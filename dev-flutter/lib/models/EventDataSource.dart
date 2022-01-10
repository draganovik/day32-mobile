import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class EventDataSource extends CalendarDataSource {
  EventDataSource(List<Event> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return _getEventData(index).start?.dateTime ?? DateTime.now();
  }

  @override
  DateTime getEndTime(int index) {
    return _getEventData(index).end?.dateTime ?? DateTime.now();
  }

  @override
  String getSubject(int index) {
    return _getEventData(index).summary ?? 'Unnamed';
  }

  @override
  Color getColor(int index) {
    //return _getEventData(index).colorId;
    return const Color(0xFF42A5F5);
  }

  @override
  bool isAllDay(int index) {
    return _getEventData(index).end == null;
  }

  Event _getEventData(int index) {
    final dynamic event = appointments![index];
    late final Event eventData;
    if (event is Event) {
      eventData = event;
    }

    return eventData;
  }
}
