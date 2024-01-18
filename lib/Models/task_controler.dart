import 'dart:math';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:taskm/main.dart';
import 'data/task.dart';
import 'hive_provider.dart';

final taskControllerProvider = Provider<TaskController>((ref) {
  final hiveBox = ref.watch(hiveBoxProvider);
  return TaskController(hiveBox);
});

var flutterLocalNotificationsPlugin = MyApp.flutterLocalNotificationsPlugin;

class TaskController{
  final Box<Task>? _taskBox;

  TaskController(this._taskBox);

  @pragma('vm:entry-point')
  static Future<void> callback() async {
    print("sdvg");
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails('channel_id', 'Channel Name',
        channelDescription: 'Channel Description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker');

    int notification_id = Random().nextInt(1000);
    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);

    await flutterLocalNotificationsPlugin
        .show(notification_id,"There's a task at due" , 'Today is the deadline!!!', notificationDetails, payload: 'Not present');
  }

  List<Task?> addTask(Task task) {
    _taskBox?.add(task);
    final deadline = task.deadline.hour-DateTime.now().hour>=1?
    task.deadline.copyWith(hour: task.deadline.hour-1):task.deadline;
    print(deadline);
    notify(task.title,deadline,task.key);
    return _taskBox?.values.toList() ?? [];
  }

  Future<void> notify(String title,DateTime time, dynamic id) async {
    // var dd = time.copyWith(time.minute-)
    await AndroidAlarmManager.oneShotAt(
      time,
      id,
      callback,
      exact: true,
      wakeup: true,
    );
  }

  List<Task?> updateTask(dynamic key,Task value)  {
    _taskBox?.put(key, value);
    if(!value.isCompleted){
      final deadline = value.deadline.hour-DateTime.now().hour>=1?
      value.deadline.copyWith(hour: value.deadline.hour-1):value.deadline;
      print(deadline);
      notify(value.title,deadline,value.key);
    }
    return _taskBox?.values.toList() ?? [];
  }

  List<Task?> deleteTask(dynamic key) {
    _taskBox?.delete(key);
    return _taskBox?.values.toList() ?? [];
  }

  List<Task?> getTasks() {
    return _taskBox?.values.toList() ?? [];
  }

  Task? getParticularTask(dynamic key){
    return _taskBox?.get(key);
  }
}