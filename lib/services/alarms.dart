import 'dart:io';

import 'package:alarm/alarm.dart';
import 'package:alarm/model/volume_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:manage_calendar_events/manage_calendar_events.dart';

import 'cache.dart';

class AlarmsManager extends ChangeNotifier {
  factory AlarmsManager() => _instance;

  AlarmsManager._();

  static final AlarmsManager _instance = AlarmsManager._();

  bool hasAlarms(CalendarEvent event) {
    try {
      final id = Cache().get(_getKey(event)) as int?;
      return id != null;
    } catch (e) {
      return false;
    }
  }

  void setAlarm(CalendarEvent event) {
    final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    Cache().put(_getKey(event), id);
    final alarmSettings = AlarmSettings(
      id: id,
      dateTime: event.startDate!,
      assetAudioPath: 'assets/audio/star_wars.mp3',
      loopAudio: true,
      vibrate: true,
      warningNotificationOnKill: Platform.isIOS,
      androidFullScreenIntent: true,
      volumeSettings: VolumeSettings.staircaseFade(
        volume: 1.0,
        volumeEnforced: true,
        fadeSteps: [
          VolumeFadeStep(const Duration(seconds: 5), 0.01),
          VolumeFadeStep(const Duration(seconds: 10), 0.02),
          VolumeFadeStep(const Duration(seconds: 15), 0.05),
          VolumeFadeStep(const Duration(seconds: 20), 0.1),
          VolumeFadeStep(const Duration(seconds: 25), 1),
        ],
      ),
      notificationSettings: NotificationSettings(
        title: 'You have a meeting',
        body: '"${event.title}" just started!',
        stopButton: 'Stop the alarm',
        icon: 'notification_icon',
      ),
    );
    Alarm.set(alarmSettings: alarmSettings);
    notifyListeners();
  }

  void cancelAlarm(CalendarEvent event) {
    final id = Cache().get(_getKey(event)) as int?;
    Cache().delete(_getKey(event));
    if (id != null) {
      Alarm.stop(id);
    }
    notifyListeners();
  }

  void stopAlarm(AlarmSettings alarm) {
    Alarm.stop(alarm.id);
    final keys = Cache().getAllKeys();
    for (final key in keys) {
      try {
        if (Cache().get(key) == alarm.id) {
          Cache().delete(key);
          break;
        }
      } catch (_) {
        continue;
      }
    }
    notifyListeners();
  }

  String _getKey(CalendarEvent event) {
    return '${event.eventId!}_${event.startDate!.millisecondsSinceEpoch}';
  }
}
