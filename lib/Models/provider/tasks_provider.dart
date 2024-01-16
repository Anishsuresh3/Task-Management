import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskm/Models/TaskHive.dart';
import 'package:taskm/Models/data/task.dart';

import '../FilertsAndSort.dart';

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

final fliteredTasks = Provider<List<Task?>>((ref)  {
  final hiveTasks = ref.watch(hiveData);
  final filter = ref.watch(filterProvider);
  switch (filter) {
    case Filters.Completed:
      return hiveTasks?.where((task) {
        return task?.isCompleted==true;
      }).toList() ?? [];
    case Filters.Pending:
      return hiveTasks?.where((task) {
        return task?.isCompleted!=true;
      }).toList() ?? [];
    case Filters.VeryImportant:
      return hiveTasks?.where((task) {
        return task?.priority==0;
      }).toList() ?? [];
    case Filters.Important:
      return hiveTasks?.where((task) {
        return task?.priority==1;
      }).toList() ?? [];
    case Filters.Medium:
      return hiveTasks?.where((task) {
        return task?.priority==2;
      }).toList() ?? [];
    case Filters.Low:
      return hiveTasks?.where((task) {
        return task?.priority==3;
      }).toList() ?? [];
    case Filters.all:
      return hiveTasks?.toList() ?? [];
  }
});

final sortTasks = Provider<List<Task?>>((ref)  {
  final hiveTasks = ref.watch(hiveData);
  final filterTasks = ref.watch(fliteredTasks);
  final sort = ref.watch(sortProvider);
  final filterSortData = filterTasks.isEmpty?hiveTasks??[]:filterTasks;
  switch (sort) {
      case Sort.DeadLine_By_Ascending:
        filterSortData.sort((a,b) => a!.deadline.compareTo(b!.deadline));
      case Sort.DeadLine_By_Descending:
        filterSortData.sort((a,b) => b!.deadline.compareTo(a!.deadline));
      case Sort.Name_By_Ascending:
        filterSortData.sort((a,b) => a!.title.compareTo(b!.title));
      case Sort.Name_By_Descending:
        filterSortData.sort((a,b) => b!.title.compareTo(a!.title));
      case Sort.Priority_High_to_Low:
        filterSortData.sort((a,b) => a!.priority.compareTo(b!.priority));
      case Sort.Priority_Low_to_High:
        filterSortData.sort((a,b) => b!.priority.compareTo(a!.priority));
      case Sort.all:
        return filterSortData.toList() ?? [];
  }
  return filterSortData;
});

final searchedTasks = Provider<List<Task?>>((ref) {
  final hiveTasks = ref.watch(hiveData);
  final filteredSortedList = ref.watch(sortTasks);
  final query = ref.watch(searchProvider);
  var res = filteredSortedList.isEmpty ? hiveTasks ?? []
      :filteredSortedList
      .where((task) => task!.title.toLowerCase().contains(query.toLowerCase()))
      .toList();
  if (res.isEmpty){
    res = filteredSortedList
        .where((task) => task!.tags!.contains(query.toLowerCase()))
        .toList();
  }
  return res.isEmpty?[]:res;
});

final hiveData = StateNotifierProvider<TaskHive, List<Task?>?>((ref) => TaskHive(ref));

final filterProvider = StateProvider<Filters>((ref) => Filters.all);

final searchProvider = StateProvider<String>((ref) => '');

final sortProvider = StateProvider<Sort>((ref) => Sort.all);