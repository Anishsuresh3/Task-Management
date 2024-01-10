import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskm/Models/data/task.dart';
import 'package:taskm/Models/task_controler.dart';

class TaskHive extends StateNotifier<List<Task?>?>{
  TaskHive(this.ref) : super(null){
    repo = ref.read(taskControllerProvider);
  }
  late TaskController repo;
  final StateNotifierProviderRef ref;

  void getTasks(){
    state = repo.getTasks();
  }

  void getCompletedTasks(){
    state = repo.getCompletedTasks();
  }

  void addTask(Task task) {
    state = repo.addTask(task);
  }

  void removeTask(dynamic id) {
    state = repo.deleteTask(id);
  }

  void updateTodo(dynamic key, Task task) {
    state = repo.updateTask(key, task);
  }

}