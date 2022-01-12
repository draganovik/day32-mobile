import 'package:flutter/foundation.dart';
import 'package:googleapis/calendar/v3.dart';

class GoogleEventsProvider with ChangeNotifier {
  List<Event>? _googleEvents;
  late CalendarApi _calendarApi;

  GoogleEventsProvider(googleAuthClient) {
    if (googleAuthClient != null) {
      _calendarApi = CalendarApi(googleAuthClient);
      if (googleAuthClient != null) {
        //loadEvents();
      }
    }
  }

  Future<void> loadEvents() async {
    var events = await _calendarApi.events.list('primary',
        timeMin: DateTime.now().subtract(const Duration(days: 31)));
    _googleEvents = events.items;
    //notifyListeners();
  }

  List<Event> get events {
    return _googleEvents ?? [];
  }

  Future<Event?> addEventToCalendar(Event event) async {
    Event? googleEvent;
    try {
      googleEvent = await _calendarApi.events.insert(event, 'primary');
      _googleEvents?.add(googleEvent);
      notifyListeners();
    } catch (err) {
      // handle error
      rethrow;
    }
    return googleEvent;
  }

  Future<Event?> updateEventToCalendar(Event event) async {
    Event? googleEvent;
    try {
      googleEvent =
          await _calendarApi.events.update(event, 'primary', event.id ?? '');
      _googleEvents?.forEach((element) {
        if (element.id == event.id && googleEvent != null) {
          element = googleEvent;
        }
      });
      notifyListeners();
    } catch (err) {
      // handle error
      rethrow;
    }
    return googleEvent;
  }

  Future<bool> deleteEventFromCalendar(Event event) async {
    bool isSuccess;
    try {
      _calendarApi.events.delete('primary', event.id ?? '');
      _googleEvents?.removeWhere((element) => element.id == event.id);
      notifyListeners();
      isSuccess = true;
    } catch (err) {
      // handle error
      rethrow;
    }
    return isSuccess;
  }
}
