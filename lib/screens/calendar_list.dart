import 'dart:async';

import 'package:alarm/alarm.dart';
import 'package:alarm/utils/alarm_set.dart';
import 'package:flutter/material.dart';
import 'package:manage_calendar_events/manage_calendar_events.dart';

import '../services/alarms.dart';
import '../services/permissions.dart';
import 'event_list.dart';

class CalendarList extends StatefulWidget {
  CalendarList({super.key});

  @override
  State<CalendarList> createState() => _CalendarListState();
}

class _CalendarListState extends State<CalendarList> {
  late final AppLifecycleListener _listener;

  late final StreamSubscription? _ringSubscription;

  @override
  void initState() {
    super.initState();
    _listener = AppLifecycleListener(onResume: _onResume);

    _ringSubscription = Alarm.ringing.listen(_onAlarmsRinging);
    Permissions().checkPermissions();
  }

  @override
  void dispose() {
    _listener.dispose();
    _ringSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendars'),
      ),
      body: FutureBuilder<bool?>(
          future: CalendarPlugin().hasPermissions(),
          builder: (context, snapshot) {
            final bool? hasPermissions = snapshot.data;
            if (hasPermissions == null) {
              return Center(child: CircularProgressIndicator());
            }

            if (!hasPermissions) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 80),
                  child: ElevatedButton(
                    onPressed: () => CalendarPlugin().requestPermissions(),
                    child: Text('Request Access to Calendars'),
                  ),
                ),
              );
            }

            return FutureBuilder<List<Calendar>?>(
              future: CalendarPlugin().getCalendars(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Container();

                final List<Calendar> calendars = snapshot.data!;
                return ListView.separated(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.only(left: 16, right: 16, top: 16),
                  itemCount: calendars.length,
                  itemBuilder: (context, index) {
                    final Calendar calendar = calendars[index];
                    return Card(
                      child: ListTile(
                        title: Text(calendar.name!),
                        subtitle:
                            calendar.isReadOnly != null && calendar.isReadOnly!
                                ? Text('Read Only')
                                : null,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return EventList(calendarId: calendar.id!);
                              },
                            ),
                          );
                        },
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      SizedBox(height: 12),
                );
              },
            );
          }),
    );
  }

  void _onResume() => setState(() {});

  Future<void> _onAlarmsRinging(AlarmSet alarms) async {
    if (alarms.alarms.isEmpty) return;
    for (final alarm in alarms.alarms) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog.adaptive(
            title: Text(alarm.notificationSettings.title),
            content: Text(alarm.notificationSettings.body),
            actions: <Widget>[
              TextButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                  AlarmsManager().stopAlarm(alarm);
                },
              ),
            ],
          );
        },
      );
    }
  }
}
