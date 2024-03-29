import 'package:date_time_picker/date_time_picker.dart';
import '../providers/firebase_events_provider.dart';
import '../providers/google_events_provider.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:provider/provider.dart';
import '../adapters/event_data_source.dart';
import 'package:flutter/material.dart';

class EditEventModal extends StatefulWidget {
  const EditEventModal({Key? key, this.editEvent}) : super(key: key);
  final Event? editEvent;
  @override
  State<EditEventModal> createState() => _EditEventModalState();
}

class _EditEventModalState extends State<EditEventModal> {
  Event? _event;
  final _form = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isMoodify = false;
  bool _isAllDay = false;
  bool _isPublic = false;
  InputDecoration _inputDecoration(BuildContext context, String label) =>
      InputDecoration(
          alignLabelWithHint: true,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Theme.of(context).colorScheme.background, width: 1.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Theme.of(context).colorScheme.background, width: 1.0),
          ),
          label: Text(label));

  @override
  void initState() {
    super.initState();
    if (_event == null) {
      if (widget.editEvent != null) {
        _isMoodify = true;
        _event = widget.editEvent;
        if (_event!.start!.dateTime == null) {
          _isAllDay = true;
        }
      } else {
        _event = Event();
        _event!.start = EventDateTime(dateTime: DateTime.now());
        _event!.end = EventDateTime(
            dateTime: DateTime.now().add(const Duration(minutes: 30)));
      }
      _adaptChangeTime();
    }
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState?.validate() ?? false;
    if (isValid) {
      setState(() {
        _isLoading = true;
      });
      final googleEventsProvider =
          Provider.of<GoogleEventsProvider>(context, listen: false);
      final firebaseEventsProvider =
          Provider.of<FirebaseEventsProvider>(context, listen: false);
      _form.currentState?.save();
      if (!_isMoodify) {
        final googleResponseEvent = await googleEventsProvider
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
        if (googleResponseEvent != null && _isPublic) {
          await firebaseEventsProvider.addEvent(googleResponseEvent);
        }

        setState(() {
          _isLoading = false;
          Navigator.of(context).pop('added');
        });
      } else {
        if (_event?.id != '') {
          final googleResponseEvent =
              await googleEventsProvider.updateEventToCalendar(_event!);
          if (googleResponseEvent != null && _isPublic) {
            await firebaseEventsProvider.updateEvent(googleResponseEvent);
          }
          setState(() {
            _isLoading = false;
            Navigator.of(context).pop('eddited');
          });
        }
      }
    }
  }

  Future<bool> _deleteEvent() async {
    setState(() {
      _isLoading = true;
    });
    final googleEventsProvider =
        Provider.of<GoogleEventsProvider>(context, listen: false);
    final firebaseEventsProvider =
        Provider.of<FirebaseEventsProvider>(context, listen: false);
    final String? eventId = _event!.id;
    final googleDeleted =
        await googleEventsProvider.deleteEventFromCalendar(_event!);
    if (googleDeleted && eventId != null) {
      await firebaseEventsProvider.deleteEventById(eventId);
    }
    setState(() {
      _isLoading = false;
    });
    return googleDeleted;
  }

  Future<bool> _showDeleteEventDialog() async {
    bool confirm = false;
    if (_event!.id != null) {
      await showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
                title: const Text('Delete Event?'),
                content: Text(
                    'Are you sure you want to delete: "${_event!.summary}"?'),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: const Text('DON\'T DELETE')),
                  TextButton(
                    onPressed: () {
                      confirm = true;
                      Navigator.of(ctx).pop();
                    },
                    style: TextButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.error),
                    child: const Text('DELETE EVENT'),
                  )
                ],
              ));
    }
    return confirm;
  }

  void _adaptChangeTime() {
    if (_isAllDay) {
      DateTime date = _event?.start?.dateTime?.toLocal() ?? DateTime.now();
      _event?.start?.date ??= DateTime(date.year, date.month, date.day);
      _event?.end?.date ??= DateTime(date.year, date.month, date.day);
      _event!.start!.dateTime = null;
      _event!.end!.dateTime = null;
    } else {
      DateTime date = _event?.start?.dateTime?.toLocal() ??
          DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day);
      _event?.start?.dateTime ??= date.add(const Duration(hours: 8));
      _event?.end?.dateTime ??= date.add(const Duration(hours: 8, minutes: 30));
      _event!.start!.dateTime = _event!.start!.dateTime?.toLocal();
      _event!.end!.dateTime = _event!.end!.dateTime?.toLocal();
      _event!.start!.date = null;
      _event!.end!.date = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).viewInsets.top + 40,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 40,
                  left: 20,
                  right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: Text(
                      _isMoodify ? 'Update event' : 'Create new event',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ),
                  Form(
                      key: _form,
                      child: Wrap(
                        runSpacing: 10,
                        children: [
                          TextFormField(
                            initialValue: _event?.summary,
                            maxLength: 200,
                            textInputAction: TextInputAction.next,
                            decoration: _inputDecoration(context, 'Event name'),
                            onSaved: (value) {
                              if (value?.replaceAll(' ', '') != '') {
                                _event!.summary = value;
                              }
                            },
                          ),
                          DateTimePicker(
                            decoration: _inputDecoration(context, 'Start time'),
                            type: _isAllDay
                                ? DateTimePickerType.date
                                : DateTimePickerType.dateTime,
                            initialValue: _isAllDay
                                ? _event?.start?.date?.toIso8601String()
                                : _event?.start?.dateTime?.toIso8601String(),
                            initialDate: _isAllDay
                                ? _event?.start?.date
                                : _event?.start?.dateTime,
                            firstDate: DateTime.now()
                                .subtract(const Duration(days: 730)),
                            lastDate:
                                DateTime.now().add(const Duration(days: 730)),
                            onSaved: (value) {
                              if (value != null &&
                                  value.replaceAll(' ', '') != '') {
                                if (_isAllDay) {
                                  _event!.start = EventDateTime(
                                      date: DateTime.parse(value));
                                } else {
                                  _event!.start = EventDateTime(
                                      dateTime: DateTime.parse(value));
                                }
                              }
                            },
                          ),
                          CheckboxListTile(
                            contentPadding:
                                const EdgeInsets.only(left: 8, right: 0),
                            value: _isAllDay,
                            onChanged: (newVal) {
                              setState(() {
                                _isAllDay = !_isAllDay;
                                _adaptChangeTime();
                              });
                            },
                            title: const Text('All day event'),
                          ),
                          DateTimePicker(
                            decoration: _inputDecoration(context, 'End time'),
                            type: _isAllDay
                                ? DateTimePickerType.date
                                : DateTimePickerType.dateTime,
                            initialValue: _isAllDay
                                ? _event?.end?.date?.toIso8601String()
                                : _event?.end?.dateTime?.toIso8601String(),
                            initialDate: _isAllDay
                                ? _event?.end?.date
                                : _event?.end?.dateTime,
                            firstDate: _isAllDay
                                ? _event?.start?.date
                                : _event?.start?.dateTime,
                            lastDate:
                                DateTime.now().add(const Duration(days: 730)),
                            onSaved: (value) {
                              if (value != null &&
                                  value.replaceAll(' ', '') != '') {
                                if (_isAllDay) {
                                  _event!.end = EventDateTime(
                                      date: DateTime.parse(value));
                                } else {
                                  _event!.end = EventDateTime(
                                      dateTime: DateTime.parse(value));
                                }
                              }
                            },
                          ),
                          CheckboxListTile(
                            contentPadding:
                                const EdgeInsets.only(left: 10, right: 0),
                            value: _isPublic,
                            onChanged: (status) {
                              setState(() {
                                _isPublic = !_isPublic;
                              });
                            },
                            title: Text(_isMoodify
                                ? 'Share changes to public calendar'
                                : 'Share event to public calendar'),
                          ),
                          TextFormField(
                            initialValue: _event?.description,
                            maxLines: 3,
                            minLines: 3,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.multiline,
                            decoration:
                                _inputDecoration(context, 'Description'),
                            onSaved: (value) {
                              if (value?.replaceAll(' ', '') != '') {
                                _event!.description = value;
                              }
                            },
                          ),
                          Wrap(
                            spacing: 8,
                            runSpacing: 2,
                            children: googleEventColors.entries
                                .map(
                                  (mapColor) => ChoiceChip(
                                      selectedColor:
                                          mapColor.value.last as Color,
                                      selected: _event?.colorId == mapColor.key,
                                      onSelected: (value) {
                                        setState(() {
                                          _event?.colorId = mapColor.key;
                                        });
                                      },
                                      avatar: CircleAvatar(
                                        backgroundColor:
                                            mapColor.value.last as Color,
                                      ),
                                      label:
                                          Text(mapColor.value.first as String)),
                                )
                                .toList(),
                          ),
                          if (_isMoodify)
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  ElevatedButton(
                                    onPressed: _isLoading
                                        ? null
                                        : () => _showDeleteEventDialog()
                                                .then((isConfirmed) {
                                              if (isConfirmed) {
                                                _deleteEvent().then((value) =>
                                                    Navigator.of(context)
                                                        .pop('deleted'));
                                              }
                                            }),
                                    style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16),
                                        foregroundColor: Theme.of(context)
                                            .colorScheme
                                            .onErrorContainer,
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .error),
                                    child: const Text(
                                      'DELETE EVENT',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ],
                              ),
                            )
                        ],
                      )),
                ],
              ),
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
              bottom: MediaQuery.of(context).viewPadding.bottom + 10, top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.error,
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
                  child: Text(_isMoodify ? 'UPDATE EVENT' : 'ADD EVENT'))
            ],
          ),
        ),
      ],
    );
  }
}
