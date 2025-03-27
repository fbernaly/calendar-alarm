import 'dart:developer';

import 'package:alarm/alarm.dart';
import 'package:manage_calendar_events/manage_calendar_events.dart';
import 'package:permission_handler/permission_handler.dart';

class Permissions {
  Future<void> checkPermissions() async {
    CalendarPlugin().requestPermissions();
    await checkNotificationPermission();
    await checkAndroidScheduleExactAlarmPermission();
  }

  Future<void> checkNotificationPermission() async {
    final status = await Permission.notification.status;
    if (status.isDenied) {
      log('Requesting notification permission...');
      final res = await Permission.notification.request();
      log(
        'Notification permission ${res.isGranted ? '' : 'not '}granted',
      );
    }
  }

  Future<void> checkAndroidScheduleExactAlarmPermission() async {
    if (!Alarm.android) return;
    final status = await Permission.scheduleExactAlarm.status;
    log('Schedule exact alarm permission: $status.');
    if (status.isDenied) {
      log('Requesting schedule exact alarm permission...');
      final res = await Permission.scheduleExactAlarm.request();
      log(
        'Schedule exact alarm permission ${res.isGranted ? '' : 'not'} granted',
      );
    }
  }
}
