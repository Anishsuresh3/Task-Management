import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'task.dart';
import 'hive_provider.dart';

final taskControllerProvider = Provider<TaskController>((ref) {
  final hiveBox = ref.watch(hiveBoxProvider);
  return TaskController(hiveBox);
});

class TaskController{
  final Box<Task>? _taskBox;

  TaskController(this._taskBox);

  Future<void> addTask(Task task) async {
    await _taskBox?.add(task);
  }

  Future<void> updateTask(Task task) async {
    await task.save();
  }

  Future<void> deleteTask(Task task) async {
    await task.delete();
  }

  List<Task> getTasks() {
    return _taskBox?.values.toList() ?? [];
  }

  Task? getParticularTask(dynamic key){
    return _taskBox?.get(key);
  }

  List<Task> getCompletedTasks() {
    return _taskBox?.values.where((task) => task.isCompleted).toList() ?? [];
  }
}