import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:googleapis/calendar/v3.dart' as cal;
import 'package:syncfusion_flutter_calendar/calendar.dart';

class EventDataSource extends CalendarDataSource {
  EventDataSource(List<cal.Event> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return _getEventData(index).start?.dateTime ??
        _getEventData(index).start?.date ??
        DateTime.now();
  }

  @override
  DateTime getEndTime(int index) {
    return _getEventData(index).end?.dateTime ??
        _getEventData(index).start?.date ??
        DateTime.now();
  }

  @override
  String getSubject(int index) {
    return _getEventData(index).summary ?? '(No title)';
  }

  @override
  Color getColor(int index) {
    return (googleEventColors[_getEventData(index).colorId.toString()]?.last ??
        Colors.blue) as Color;
  }

  @override
  bool isAllDay(int index) {
    return _getEventData(index).start!.date != null;
  }

  cal.Event _getEventData(int index) {
    final dynamic event = appointments![index];
    late final cal.Event eventData;
    if (event is cal.Event) {
      eventData = event;
    }

    return eventData;
  }
}

Map<String, List<Object>> googleEventColors = {
  '1': ['Lavander', Colors.deepPurple.shade200],
  '2': ['Sage', Colors.green.shade400],
  '3': ['Grape', Colors.deepPurple],
  '4': ['Flamingo', Colors.red.shade400],
  '5': ['Banana', Colors.yellow.shade700],
  '6': ['Tangerine', Colors.orange.shade700],
  '7': ['Peacock', Colors.blue],
  '8': ['Graphite', Colors.grey.shade600],
  '9': ['Blueberry', Colors.blue.shade800],
  '10': ['Basil', Colors.green.shade800],
  '11': ['Tomato', Colors.red.shade900],
};
