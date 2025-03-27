import 'package:flutter/material.dart';

import 'screens/calendar_list.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: CalendarList());
  }
}
