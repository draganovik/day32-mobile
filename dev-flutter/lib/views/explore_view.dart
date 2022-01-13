import '../providers/firebase_events_provider.dart';
import '../widgets/event_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExploreView extends StatelessWidget {
  const ExploreView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var fep = Provider.of<FirebaseEventsProvider>(context);
    return FutureBuilder(
      future: fep.fetchAndSetEvents(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snap.hasError) {
          return const Center(
            child: Text('Can\'t connect to the service right now'),
          );
        }
        if (fep.events.isEmpty) {
          return const Center(
            child: Text('There are no public events'),
          );
        }
        return ListView(
            padding: const EdgeInsets.all(8),
            children: fep.events.map((event) => EventCard(event)).toList()
              ..sort((evc1, evc2) {
                return (evc1.event.start?.dateTime ??
                        evc1.event.start?.date ??
                        DateTime.now())
                    .compareTo(evc2.event.start?.dateTime ??
                        evc2.event.start?.date ??
                        DateTime.now());
              }));
      },
    );
  }
}
