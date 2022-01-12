import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:http/http.dart' as http;

class FirebaseEventsProvider with ChangeNotifier {
  List<Event> _firebaseEvents = [];
  final String _firebaseUrl = 'day-32.firebaseio.com';

  void publishTest() {
    Uri uri = Uri.https(_firebaseUrl, '/events.json');
  }

  List<Event> get events {
    return [..._firebaseEvents];
  }

  Future<void> fetchAndSetEvents() async {
    Uri url = Uri.https(_firebaseUrl, '/events.json');
    try {
      final response = await http.get(url);
      final responseMap = json.decode(response.body) as Map<String, dynamic>;
      _firebaseEvents.clear();
      responseMap.forEach((key, value) {
        _firebaseEvents.add(Event.fromJson(value));
        print(_firebaseEvents.length);
      });
    } catch (err) {
      rethrow;
    } finally {
      //notifyListeners();
    }
  }

  Future<void> addEvent(Event event) async {
    Uri url = Uri.https(_firebaseUrl, '/events.json');
    try {
      await http.post(url, body: jsonEncode(event));
      _firebaseEvents.add(event);
      notifyListeners();
    } catch (err) {
      rethrow;
    }
  }

  Future<void> updateEvent(Event event) async {
    final updateIndex =
        _firebaseEvents.indexWhere((element) => element.id == event.id);
    Uri url = Uri.https(_firebaseUrl, '/events.json');
    if (updateIndex > -1) {
      await http.patch(url, body: json.encode(event));
      _firebaseEvents[updateIndex] = event;
      notifyListeners();
    }
  }

  Event getEventById(String id) {
    return _firebaseEvents.firstWhere((element) => element.id == id);
  }

  Future<void> deleteEventById(String id) async {
    Uri url = Uri.https(_firebaseUrl, '/events/$id.json');
    var delEventIndex =
        _firebaseEvents.lastIndexWhere((element) => element.id == id);
    var delEvent = _firebaseEvents[delEventIndex];
    _firebaseEvents.removeWhere((element) => element.id == id);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _firebaseEvents.insert(delEventIndex, delEvent);
      notifyListeners();
      throw Exception();
    }
  }
}
