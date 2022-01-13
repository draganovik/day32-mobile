import '../providers/google_events_provider.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class AddPublicEventModal extends StatefulWidget {
  AddPublicEventModal({Key? key, this.event}) : super(key: key);
  Event? event;
  @override
  _EditEventModalState createState() => _EditEventModalState();
}

class _EditEventModalState extends State<AddPublicEventModal> {
  Event? _event;
  final _form = GlobalKey<FormState>();
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
    final googleResponseEvent =
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
    });
    Navigator.of(context).pop('added');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).viewInsets.top + 10,
                bottom: MediaQuery.of(context).viewInsets.bottom + 40,
                left: 20,
                right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: Text(
                    'Add event to personal calendar:',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
              border: Border.symmetric(
                  horizontal: BorderSide(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withAlpha(10)))),
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewPadding.bottom, top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: TextButton.styleFrom(
                    primary: Theme.of(context).colorScheme.error,
                    textStyle: Theme.of(context)
                        .textTheme
                        .button
                        ?.copyWith(fontSize: 18),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                  ),
                  child: const Text(
                    'CANCEL',
                  )),
              TextButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                          _saveForm();
                        },
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context)
                        .textTheme
                        .button
                        ?.copyWith(fontSize: 18),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                  ),
                  child: Text('ADD EVENT'))
            ],
          ),
        ),
      ],
    );
  }
}
