import '../models/event_data_source.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/calendar/v3.dart' as cal;
import 'package:intl/intl.dart' as intl;

class EventCard extends StatelessWidget {
  cal.Event event;
  Color themeColor = Colors.blue;
  void Function(BuildContext context, cal.Event event) onTap;
  EventCard(this.event, this.onTap, {Key? key}) : super(key: key) {
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
        onTap: () {
          onTap(context, event);
        },
        child: ListTile(
          contentPadding: const EdgeInsets.all(12),
          tileColor: themeColor,
          textColor: Theme.of(context).colorScheme.onBackground,
          leading: CircleAvatar(
              radius: 30,
              foregroundColor: themeColor,
              backgroundColor: Theme.of(context).colorScheme.onBackground,
              child: FittedBox(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(intl.DateFormat('dd. MMM').format(
                      event.start?.dateTime ??
                          event.start?.date ??
                          DateTime.now())),
                ),
              )),
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 1),
            child: Text(
              (event.summary ?? '(No title)').length > 160
                  ? '${event.summary?.substring(0, 160) ?? ''}...'
                  : event.summary ?? '(No title)',
              style: const TextStyle(
                fontSize: 19,
              ),
            ),
          ),
          subtitle: Text(
            event.start?.date == null
                ? '${intl.DateFormat('HH:mm').format(event.start?.dateTime?.toLocal() ?? DateTime.now())} - ${intl.DateFormat('HH:mm').format(event.end?.dateTime?.toLocal() ?? DateTime.now())}'
                : 'All day event',
            style: Theme.of(context).textTheme.caption?.copyWith(
                fontSize: 14,
                color:
                    Theme.of(context).colorScheme.onBackground.withAlpha(160)),
          ),
          trailing: Text(intl.DateFormat('yyyy').format(
              event.start?.dateTime ?? event.start?.date ?? DateTime.now())),
        ),
      ),
    );
  }
}
