import 'dart:isolate';
import 'dart:math';
import 'dart:ui';

// import 'package:alarm/alarm.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:taskm/home.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'Models/data/task.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

const String isolateName = 'isolate';

/// A port used to communicate from a background isolate to the UI isolate.
ReceivePort port = ReceivePort();

Future<void> requestNotificationPermission() async {
  var status = await Permission.notification.status;
  var storageStatus = await Permission.storage.status;

  if (status.isDenied) {
    await Permission.notification.request();
  }
  if(storageStatus.isDenied){
    await Permission.storage.request();
  }
}



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  await Hive.openBox<Task>('tasksBox');
  IsolateNameServer.registerPortWithName(
    port.sendPort,
    isolateName,
  );
  requestNotificationPermission();
  await AndroidAlarmManager.initialize();
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<void> init() async {
    // Initialize native android notification
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    // Initialize native Ios Notifications
    const DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
    InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await MyApp.flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  @override
  void initState(){
    super.initState();
    init();
  }


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


