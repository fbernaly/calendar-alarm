import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'screens/calendar_list.dart';
import 'services/cache.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await Alarm.init();
  await Cache().init();

  runApp(
    MaterialApp(home: CalendarList()),
  );
}
