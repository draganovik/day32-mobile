import 'package:flutter/material.dart';
import 'package:googleapis/calendar/v3.dart' as cal;
import 'package:syncfusion_flutter_calendar/calendar.dart';

class EventDataSource extends CalendarDataSource {
  Color defaultEventColor;
  EventDataSource(List<cal.Event> source, this.defaultEventColor) {
    appointments = source.where((element) => element.summary != null).toList();
  }

  @override
  DateTime getStartTime(int index) {
    return appointments?[index].start?.dateTime?.toLocal() ??
        appointments?[index].start?.date?.toLocal() ??
        DateTime.now();
  }

  @override
  DateTime getEndTime(int index) {
    return appointments?[index].end?.dateTime?.toLocal() ??
        appointments?[index].start?.date?.toLocal() ??
        DateTime.now();
  }

  @override
  String getSubject(int index) {
    return appointments?[index].summary ?? '(No title)';
  }

  @override
  Color getColor(int index) {
    return (googleEventColors[appointments![index].colorId.toString()]?.last ??
        defaultEventColor) as Color;
  }

  @override
  bool isAllDay(int index) {
    return appointments?[index].start?.date != null;
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
