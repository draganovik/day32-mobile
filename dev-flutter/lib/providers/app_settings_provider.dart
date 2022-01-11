import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettingsProvider with ChangeNotifier {
  static const String settingStore = 'app_data';
  late int _tabViewSelectedPage = 1;
  bool hasLoaded = false;
  AppSettingsProvider() {
    _restoreAppData();
  }

  Future<void> _restoreAppData() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(settingStore)) return;

    final _appData = json.decode(prefs.getString(settingStore) ?? '');
    _tabViewSelectedPage = _appData['tab_view_selected_index'];
    hasLoaded = true;
    notifyListeners();
  }

  Future<void> _cacheAppData() async {
    final prefs = await SharedPreferences.getInstance();
    final _appData = json.encode({
      'tab_view_selected_index': _tabViewSelectedPage,
    });
    prefs.setString(settingStore, _appData);
  }

  int get tabViewSelectedPage {
    return _tabViewSelectedPage;
  }

  set tabViewSelectedPage(value) {
    _tabViewSelectedPage = value;
    notifyListeners();
  }

  @override
  void notifyListeners() {
    // TODO: implement notifyListeners
    super.notifyListeners();
    _cacheAppData();
  }
}
