import 'package:day32/models/EventDataSource.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/calendar/v3.dart' as cal;

class EventCard extends StatelessWidget {
  cal.Event event;
  Color themeColor = Colors.blue;
  EventCard(this.event, {Key? key}) : super(key: key) {
    if (googleEventColors[event.colorId]?.last != null) {
      themeColor = (googleEventColors[event.colorId]?.last as Color);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12))),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        splashColor: Theme.of(context).colorScheme.surface.withAlpha(20),
        highlightColor: Theme.of(context).colorScheme.surface.withAlpha(10),
        onTap: () {},
        child: ListTile(
          contentPadding: const EdgeInsets.all(12),
          tileColor: themeColor,
          textColor: Theme.of(context).colorScheme.onBackground,
          leading: CircleAvatar(
              radius: 30,
              backgroundColor:
                  Theme.of(context).colorScheme.surface.withAlpha(140)),
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 1),
            child: Text(
              event.summary ?? '(No title)',
              style: const TextStyle(
                fontSize: 19,
              ),
            ),
          ),
          subtitle: Text(
            '${event.start?.dateTime ?? event.start?.date}',
            style: Theme.of(context).textTheme.caption?.copyWith(
                fontSize: 14,
                color:
                    Theme.of(context).colorScheme.onBackground.withAlpha(160)),
          ),
        ),
      ),
    );
  }
}
