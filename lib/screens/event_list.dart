import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manage_calendar_events/manage_calendar_events.dart';

import '../utils/date_formatter.dart';
import 'event_details.dart';

class EventList extends StatefulWidget {
  const EventList({
    required this.calendarId,
    super.key,
  });

  final String calendarId;

  @override
  State<EventList> createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upcoming Events'),
      ),
      body: FutureBuilder<List<CalendarEvent>?>(
        future: _fetchEvents(),
        builder: (context, snapshot) {
          if (snapshot.data == null || snapshot.data!.isEmpty) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 80),
              child: Center(child: Text('No events found')),
            );
          }
          final List<CalendarEvent> events = snapshot.data!;
          return ListView.separated(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.only(left: 16, right: 16, top: 16),
            itemCount: events.length,
            itemBuilder: (context, index) {
              final CalendarEvent event = events.elementAt(index);
              return Card(
                child: ListTile(
                  title: Text(event.title!),
                  subtitle: Text(event.isAllDay == true
                      ? DateFormat.yMMMEd().format(event.startDate!)
                      : formatRange(event.startDate!, event.endDate!)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return EventDetails(event: event);
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
      ),
    );
  }

  Future<List<CalendarEvent>?> _fetchEvents() async {
    final events =
        await CalendarPlugin().getEvents(calendarId: widget.calendarId);
    return events
        ?.where((event) =>
            event.startDate != null &&
            event.startDate!.millisecondsSinceEpoch >
                DateTime.now().millisecondsSinceEpoch)
        .toList();
  }
}
