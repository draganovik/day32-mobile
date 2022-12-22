import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class AppSettingsProvider with ChangeNotifier {
  static const String settingStore = 'app_data';
  late int _tabViewSelectedPage = 1;
  CalendarController _mainCalendarController = CalendarController();
  bool hasLoaded = false;
  AppSettingsProvider() {
    _mainCalendarController.view = CalendarView.schedule;
    _restoreAppData();
  }

  Future<void> _restoreAppData() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(settingStore)) return;

    final _appData = json.decode(prefs.getString(settingStore) ?? '');
    _tabViewSelectedPage = _appData['tab_view_selected_index'];
    _mainCalendarController.view =
        CalendarView.values[_appData['main_calendar_view']];
    hasLoaded = true;
    notifyListeners();
  }

  Future<void> _cacheAppData() async {
    final prefs = await SharedPreferences.getInstance();
    final _appData = json.encode({
      'tab_view_selected_index': _tabViewSelectedPage,
      'main_calendar_view': _mainCalendarController.view!.index
    });
    await prefs.setString(settingStore, _appData);
  }

  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _tabViewSelectedPage = 1;
    notifyListeners();
  }

  int get tabViewSelectedPage {
    return _tabViewSelectedPage;
  }

  CalendarController get mainCalendarController {
    return _mainCalendarController;
  }

  set tabViewSelectedPage(value) {
    _tabViewSelectedPage = value;
    notifyListeners();
  }

  set mainCalendarController(value) {
    _mainCalendarController = value;
    notifyListeners();
  }

  @override
  void notifyListeners() {
    _cacheAppData().then((value) => super.notifyListeners());
  }
}
