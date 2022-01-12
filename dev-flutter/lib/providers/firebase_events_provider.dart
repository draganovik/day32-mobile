import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseEventsProvider with ChangeNotifier {
  final List<Event> _firebaseEvents = [];
  FirebaseDatabase database = FirebaseDatabase.instance;

  List<Event> get events {
    return [..._firebaseEvents];
  }

  Future<void> fetchAndSetEvents() async {
    try {
      DatabaseReference eventRef = FirebaseDatabase.instance.ref("events");
      DatabaseEvent events = await eventRef.once();
      _firebaseEvents.clear();
      final responseMap = json.decode(json.encode(events.snapshot.value)) ??
          <String, dynamic>{};
      responseMap.forEach((key, value) {
        _firebaseEvents.add(Event.fromJson(value));
      });
    } catch (err) {
      rethrow;
    }
  }

  Future<void> addEvent(Event event) async {
    try {
      DatabaseReference eventRef =
          FirebaseDatabase.instance.ref("events/${event.id}");
      await eventRef.set(json.decode(json.encode(event)));
      notifyListeners();
    } catch (err) {
      rethrow;
    }
  }

  Future<void> updateEvent(Event event) async {
    DatabaseReference eventRef =
        FirebaseDatabase.instance.ref("events/${event.id}");
    final updateIndex =
        _firebaseEvents.indexWhere((element) => element.id == event.id);
    await eventRef.update(json.decode(json.encode(event)));
    if (updateIndex > -1) {
      _firebaseEvents[updateIndex] = event;
    }
    notifyListeners();
  }

  Event getEventById(String id) {
    return _firebaseEvents.firstWhere((element) => element.id == id);
  }

  Future<void> deleteEventById(String id) async {
    DatabaseReference refChild =
        FirebaseDatabase.instance.ref("events").child(id);
    _firebaseEvents.removeWhere((element) => element.id == id);
    await refChild.remove();
    notifyListeners();
  }
}
