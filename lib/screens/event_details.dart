import 'package:flutter/material.dart';
import 'package:manage_calendar_events/manage_calendar_events.dart';

import '../utils/date_formatter.dart';

class EventDetails extends StatefulWidget {
  const EventDetails({
    required this.event,
    super.key,
  });

  final CalendarEvent event;

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.event.title!),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.event.description != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    'Description: ${widget.event.description}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              if (widget.event.startDate != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text(
                      'Start Date: ${formatDate(widget.event.startDate!)}'),
                ),
              if (widget.event.endDate != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text('End Date: ${formatDate(widget.event.endDate!)}'),
                ),
              if (widget.event.location != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text('Location: ${widget.event.location}'),
                ),
              FutureBuilder<List<Attendee>?>(
                future: CalendarPlugin()
                    .getAttendees(eventId: widget.event.eventId!),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Text('No Attendee found');
                  }
                  final List<Attendee> attendees = snapshot.data!;
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Attendees: ${attendees.length}'),
                      SizedBox(height: 4),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemCount: attendees.length,
                        itemBuilder: (context, index) {
                          final Attendee attendee = attendees.elementAt(index);
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(child: Text(attendee.name)),
                                    if (attendee.isOrganiser) Text('Organizer'),
                                  ],
                                ),
                                if (attendee.name != attendee.emailAddress)
                                  Text(attendee.emailAddress),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
