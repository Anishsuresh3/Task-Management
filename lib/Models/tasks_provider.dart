import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskm/Models/TaskHive.dart';
import 'package:taskm/Models/data/task.dart';

final TasksDataProvider = Provider<List<Task?>>((ref) {
  final hiveTasks = ref.watch(hiveData);
  List<Task?>? TaskData = hiveTasks?.where((element) {
    return element?.isCompleted!=true;
  }).toList();
  return TaskData ?? [];
});

final CompletedTasksDataProvider = Provider<List<Task?>>((ref) {
  final hiveTasks = ref.watch(hiveData);
  List<Task?>? TaskData = hiveTasks?.where((element) {
    return element?.isCompleted==true;
  }).toList();
  return TaskData ?? [];
});

final hiveData = StateNotifierProvider<TaskHive, List<Task?>?>((ref) => TaskHive(ref));