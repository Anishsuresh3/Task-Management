import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:taskm/home.dart';

import 'Models/data/task.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  await Hive.openBox<Task>('tasksBox');
  await Alarm.init();
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Management',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: HomePage(),
    );
  }
}


// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//
//   late DateTime dateTime;
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text('Editable Text Fields'),
//         ),
//         body: Column(
//           children: [
//             Center(
//               child: ElevatedButton(
//                 onPressed: () async{
//                   dateTime = (await showOmniDateTimePicker(context: context))!;
//                   print(dateTime);
//                 },
//                 child: Text("SELECT"),
//               ),
//             ),
//             Center(
//               child: ElevatedButton(
//                 onPressed: () async{
//                   final alarmSettings = AlarmSettings(
//                     id: 42,
//                     dateTime: dateTime,
//                     assetAudioPath: 'assets/audio/alarm.mp3',
//                     loopAudio: false,
//                     vibrate: true,
//                     fadeDuration: 3.0,
//                     notificationTitle: 'This is the title',
//                     notificationBody: 'This is the body',
//                     enableNotificationOnKill: true,
//                   );
//                   await Alarm.set(alarmSettings: alarmSettings);
//                 },
//                 child: Text("START"),
//               ),
//             ),
//           ],
//         )
//     );
//   }
// }