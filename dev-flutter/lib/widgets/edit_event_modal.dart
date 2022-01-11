import 'package:date_time_picker/date_time_picker.dart';
import 'package:day32/providers/google_events_provider.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:provider/provider.dart';
import '../models/EventDataSource.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

class EditEventModal extends StatefulWidget {
  EditEventModal({Key? key, this.editEvent}) : super(key: key);
  Event? editEvent;
  @override
  _EditEventModalState createState() => _EditEventModalState();
}

class _EditEventModalState extends State<EditEventModal> {
  Event? _event;
  final _form = GlobalKey<FormState>();
  bool _isLoading = false;
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
    // TODO: implement initState
    super.initState();
    _event ??= widget.editEvent ?? Event();
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState?.validate() ?? false;
    if (isValid) {
      setState(() {
        _isLoading = true;
      });
      _form.currentState?.save();
      if (_event?.summary != '') {
        await Provider.of<GoogleEventsProvider>(context, listen: false)
            .addEventToCalendar(_event!)
            .catchError((error) {
          return showDialog<void>(
              context: context,
              builder: (ctx) => AlertDialog(
                    title: Text('Error happened'),
                    content: Text('Connection failed'),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.of(ctx).pop(),
                          child: Text('OK'))
                    ],
                  ));
        }).then((response) {
          setState(() {
            _isLoading = false;
          });
          Navigator.of(context).pop('added');
        });
      } else {
        /* await Provider.of<GoogleEventsProvider>(context, listen: false)
            .updateProduct(_event)
            .then((value) {
          setState(() {
            _isLoading = false;
          });
          Navigator.of(context).pop();
        }); */
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).viewInsets.top + 80,
            bottom: MediaQuery.of(context).viewInsets.bottom + 40,
            left: 20,
            right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Create new event',
              style: Theme.of(context).textTheme.headline5,
            ),
            const SizedBox(
              height: 20,
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
                      type: DateTimePickerType.dateTime,
                      firstDate: DateTime.now(),
                      initialDate: _event?.start?.dateTime ?? DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 730)),
                      onSaved: (value) {
                        print(value);
                        if (value?.replaceAll(' ', '') != '') {
                          _event!.start = EventDateTime(
                              //date: DateTime.parse(value!),
                              dateTime: DateTime.parse(value!));
                        }
                      },
                    ),
                    CheckboxListTile(
                      contentPadding: EdgeInsets.only(left: 8, right: 0),
                      value: _event?.start?.date != null,
                      onChanged: (newVal) {},
                      title: const Text('All day event'),
                    ),
                    DateTimePicker(
                      decoration: _inputDecoration(context, 'End time'),
                      type: DateTimePickerType.dateTime,
                      firstDate: _event?.start?.dateTime ?? DateTime.now(),
                      initialDate: _event?.end?.dateTime ?? DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 730)),
                      onSaved: (value) {
                        if (value?.replaceAll(' ', '') != '') {
                          _event!.end = EventDateTime(
                              //date: DateTime.parse(value!),
                              dateTime: DateTime.parse(value!));
                        }
                      },
                    ),
                    CheckboxListTile(
                      contentPadding: EdgeInsets.only(left: 10, right: 0),
                      value: false,
                      onChanged: (newVal) {},
                      title: const Text('Share event to public calendar'),
                    ),
                    TextFormField(
                      initialValue: _event?.description,
                      maxLines: 3,
                      minLines: 3,
                      maxLength: 300,
                      keyboardType: TextInputType.multiline,
                      decoration: _inputDecoration(context, 'Description'),
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
                                selectedColor: (mapColor.value.last as Color)
                                    .withAlpha(40),
                                selected: _event?.colorId == mapColor.key,
                                onSelected: (value) {
                                  setState(() {
                                    _event?.colorId = mapColor.key;
                                  });
                                },
                                backgroundColor:
                                    Theme.of(context).colorScheme.surface,
                                elevation: 2,
                                avatar: CircleAvatar(
                                  backgroundColor: mapColor.value.last as Color,
                                ),
                                label: Text(mapColor.value.first as String),
                                labelStyle: Theme.of(context)
                                    .chipTheme
                                    .labelStyle
                                    .copyWith(
                                        color: mapColor.value.last as Color)),
                          )
                          .toList(),
                    ),
                  ],
                )),
            SizedBox(
              height: 40,
            ),
            Divider(),
            Row(
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    child: Text(
                      'CANCEL',
                    )),
                TextButton(
                    onPressed: () {
                      _saveForm();
                    },
                    style: TextButton.styleFrom(
                      textStyle: Theme.of(context)
                          .textTheme
                          .button
                          ?.copyWith(fontSize: 18),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    child: Text('ADD EVENT'))
              ],
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
