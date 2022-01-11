import 'package:date_time_picker/date_time_picker.dart';
import 'package:day32/models/EventDataSource.dart';
import 'package:day32/providers/app_settings_provider.dart';
import 'package:day32/providers/google_events_provider.dart';
import 'package:day32/widgets/edit_event_modal.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:provider/provider.dart';

import '../views/calendar_view.dart';
import '../views/explore_view.dart';
import '../views/profile_view.dart';
import '../widgets/application_bar.dart';
import 'package:flutter/material.dart';

class TabsPage extends StatefulWidget {
  const TabsPage({Key? key}) : super(key: key);

  @override
  State<TabsPage> createState() => _TabsPageState();
}

class _TabsPageState extends State<TabsPage> {
  late AppSettingsProvider appSettings;
  var _pages = [];

  void _selectPage(int index) {
    setState(() {
      appSettings.tabViewSelectedPage = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _pages = [
      {'title': 'Explore', 'page': const ExploreView()},
      {'title': 'My Events', 'page': const CalendarView()},
      {'title': 'Profile & Settings', 'page': const ProfileView()},
    ];
  }

  @override
  Widget build(BuildContext context) {
    appSettings = Provider.of<AppSettingsProvider>(context);
    return Scaffold(
      appBar: ApplicationBar(
          context: context,
          title: _pages[appSettings.tabViewSelectedPage]['title']),
      body: _pages[appSettings.tabViewSelectedPage]['page'] as Widget,
      floatingActionButton: appSettings.tabViewSelectedPage == 1
          ? FloatingActionButton.extended(
              icon: const Icon(Icons.add),
              onPressed: () {
                showEditEventModal();
              },
              label: const Text("Add event"))
          : null,
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Theme.of(context).colorScheme.primaryVariant,
        currentIndex: appSettings.tabViewSelectedPage,
        onTap: _selectPage,
        backgroundColor: Theme.of(context).colorScheme.surface,
        selectedFontSize: 12,
        unselectedFontSize: 11,
        items: const [
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.all(4.0),
              child: Icon(Icons.explore_outlined),
            ),
            activeIcon: Padding(
              padding: EdgeInsets.all(4.0),
              child: Icon(Icons.explore),
            ),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.all(4.0),
              child: Icon(Icons.calendar_today_outlined),
            ),
            activeIcon: Padding(
              padding: EdgeInsets.all(4.0),
              child: Icon(Icons.calendar_today),
            ),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.all(4.0),
              child: Icon(Icons.person_outline),
            ),
            activeIcon: Padding(
              padding: EdgeInsets.all(4.0),
              child: Icon(Icons.person),
            ),
            label: 'Profile',
          )
        ],
      ),
    );
  }

  void showEditEventModal([event]) {
    showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: false,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      context: context,
      builder: (ctx) {
        return EditEventModal(editEvent: event);
      },
    ).then((value) {
      if (value != null) {
        Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            Provider.of<GoogleEventsProvider>(context, listen: false)
                .loadEvents();
          });
        });
      }
    });
  }
}
