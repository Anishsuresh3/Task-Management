import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:taskm/Models/task_controler.dart';
import 'package:taskm/Models/tasks_provider.dart';

class CompletedTaskTile extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(hiveData);
    return ListView.builder(
      itemCount: tasks!.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return ListTile(
          title: Text(task!.title),
          subtitle: Text(task.description.toString()),
        );
      },
    );
  }
}
