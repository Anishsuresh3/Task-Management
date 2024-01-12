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

final getNumberOfTasks = Provider<List<double>>((ref) {
  final Tasks = ref.watch(TasksDataProvider).length;
  final CompletedTasks = ref.watch(CompletedTasksDataProvider).length;
  List<double> noTasks = [];
  noTasks.add(Tasks.toDouble());
  noTasks.add(CompletedTasks.toDouble());
  noTasks.add((CompletedTasks/(Tasks+CompletedTasks) * 100));
  return noTasks;
});

final hiveData = StateNotifierProvider<TaskHive, List<Task?>?>((ref) => TaskHive(ref));