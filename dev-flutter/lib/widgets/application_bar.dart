import '../providers/app_settings_provider.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter/material.dart';

class ApplicationBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  ApplicationBar({Key? key, this.title = 'Day32', required context})
      : super(key: key);

  @override
  State<ApplicationBar> createState() => _ApplicationBarState();

  @override
  Size get preferredSize => const Size.fromHeight(80.0);
}

class _ApplicationBarState extends State<ApplicationBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(widget.title),
      titleTextStyle:
          Theme.of(context).textTheme.headline6!.copyWith(fontSize: 26),
      toolbarHeight: 80,
      centerTitle: false,
      backgroundColor: Theme.of(context).colorScheme.surface,
      foregroundColor: Theme.of(context).colorScheme.onSurface,
      elevation: 2,
      actions: [
        PopupMenuButton(
          icon: Icon(Icons.filter_list),
          itemBuilder: (_) => [
            const PopupMenuItem(
              child: Text('Schedule'),
              value: CalendarView.schedule,
            ),
            const PopupMenuItem(
              child: Text('Week view'),
              value: CalendarView.week,
            ),
          ],
          onSelected: (CalendarView value) {
            setState(() {
              Provider.of<AppSettingsProvider>(context, listen: false)
                  .mainCalendarController
                  .view = value;
              Provider.of<AppSettingsProvider>(context, listen: false)
                  .notifyListeners();
            });
          },
        ),
        IconButton(
            onPressed: () {}, icon: const Icon(Icons.notifications_outlined))
        /* Consumer<NotificationsProvider>(
          builder: (_, notifications, child) => Badge(
            child: child!,
            value: notifications.itemCount.toString(),
          ),
          child: IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              Navigator.of(context).pushNamed(NotificationsPage.routeName);
            },
          ),
        ) */
      ],
    );
  }
}
