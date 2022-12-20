import '../providers/app_settings_provider.dart';
import '../widgets/edit_event_modal.dart';
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
      bottomNavigationBar: NavigationBar(
        elevation: 20,
        backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
        onDestinationSelected: (int index) => _selectPage(index),
        selectedIndex: appSettings.tabViewSelectedPage,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: 'Explore',
          ),
          NavigationDestination(
            icon: Icon(Icons.today_outlined),
            selectedIcon: Icon(Icons.today),
            label: 'Calendar',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
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
    );
  }
}
