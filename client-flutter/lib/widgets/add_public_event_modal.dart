import '../providers/google_events_provider.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

class AddPublicEventModal extends StatefulWidget {
  const AddPublicEventModal({Key? key, this.event}) : super(key: key);
  final Event? event;
  @override
  State<AddPublicEventModal> createState() => _EditEventModalState();
}

class _EditEventModalState extends State<AddPublicEventModal> {
  Event? _event;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (_event == null) {
      if (widget.event != null) {
        _event = widget.event;
        _event?.id = null;
        if (_event!.start!.dateTime == null) {}
      } else {
        _event = Event();
        _event!.start = EventDateTime(dateTime: DateTime.now());
        _event!.end = EventDateTime(
            dateTime: DateTime.now().add(const Duration(minutes: 30)));
      }
    }
  }

  Future<void> _saveForm() async {
    setState(() {
      _isLoading = true;
    });
    await Provider.of<GoogleEventsProvider>(context, listen: false)
        .addEventToCalendar(_event!)
        .catchError((error) {
      showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
                title: const Text('Error happened'),
                content: const Text('Connection failed'),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: const Text('OK'))
                ],
              ));
    });
    setState(() {
      _isLoading = false;
      Navigator.of(context).pop('added');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).viewInsets.top + 30,
                bottom: MediaQuery.of(context).viewInsets.bottom + 40,
                left: 20,
                right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  (_event?.summary?.length ?? 0) < 100
                      ? _event?.summary ?? '(No title)'
                      : '${_event?.summary?.substring(0, 40) ?? ''}...',
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      ?.copyWith(fontSize: 30),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 4),
                Row(children: [
                  Text(
                    _event?.start?.date == null
                        ? '${intl.DateFormat('HH:mm').format(_event?.start?.dateTime?.toLocal() ?? DateTime.now())} - ${intl.DateFormat('HH:mm').format(_event?.end?.dateTime?.toLocal() ?? DateTime.now())}'
                        : 'All day event',
                    style: Theme.of(context).textTheme.caption,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    _event?.start?.date == null
                        ? intl.DateFormat('dd.MM.yyyy.').format(
                            _event?.start?.dateTime?.toLocal() ??
                                DateTime.now())
                        : 'All day event',
                    style: Theme.of(context).textTheme.caption,
                  ),
                ]),
                const SizedBox(height: 10),
                Text(_event?.location ?? 'No location set',
                    style: Theme.of(context).textTheme.caption),
                const SizedBox(height: 20),
                Text(_event?.description ??
                    'No description is provided for this event...'),
              ],
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
              border: Border(
                  top: BorderSide(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withAlpha(40)))),
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewPadding.bottom + 10, top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                  onPressed: _isLoading ? null : () => _saveForm(),
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context)
                        .textTheme
                        .button
                        ?.copyWith(fontSize: 18),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                  ),
                  child: const Text('ADD TO CALENDAR'))
            ],
          ),
        ),
      ],
    );
  }
}
