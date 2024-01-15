import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'data/task.dart';
import 'hive_provider.dart';

final taskControllerProvider = Provider<TaskController>((ref) {
  final hiveBox = ref.watch(hiveBoxProvider);
  return TaskController(hiveBox);
});

class TaskController{
  final Box<Task>? _taskBox;

  TaskController(this._taskBox);

  List<Task?> addTask(Task task)  {
    _taskBox?.add(task);
    return _taskBox?.values.toList() ?? [];
  }

  List<Task?> updateTask(dynamic key,Task value)  {
    _taskBox?.put(key, value);
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