import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'task.dart';

final hiveBoxProvider = Provider<Box<Task>>((ref) {
  Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  return Hive.box<Task>('tasksBox');
});
