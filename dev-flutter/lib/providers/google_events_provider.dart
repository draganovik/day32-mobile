import 'package:flutter/foundation.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:http/http.dart';

class GoogleEventsProvider with ChangeNotifier {
  List<Event>? _googleEvents;
  late CalendarApi _calendarApi;

  GoogleEventsProvider(googleAuthClient) {
    _calendarApi = CalendarApi(googleAuthClient ?? Client());
    if (googleAuthClient != null) {
      loadEvents();
    }
  }

  Future<void> loadEvents() async {
    var events =
        await _calendarApi.events.list('primary', timeMin: DateTime.now());
    _googleEvents = events.items;
    notifyListeners();
  }

  List<Event> get events {
    return _googleEvents ?? [];
  }

  Future<void> addEventToCalendar(Event event) async {
    try {
      _calendarApi.events.insert(event, 'primary');
      notifyListeners();
    } catch (err) {
      print(err.toString());
      rethrow;
      // handle error
    }
  }

  Future<void> updateEventToCalendar(Event event) async {
    try {
      _calendarApi.events.update(event, 'primary', event.id ?? '');
      notifyListeners();
    } catch (err) {
      print(err.toString());
      rethrow;
      // handle error
    }
  }
}
