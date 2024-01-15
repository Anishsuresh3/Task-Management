import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:taskm/Models/task_controler.dart';
import 'package:taskm/Models/provider/tasks_provider.dart';

class CompletedTaskTile extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(CompletedTasksDataProvider);
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return Card(
          color: Color(0xFF7EF889),
          margin: EdgeInsets.all(5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0), // Border radius
          ),
          child: ListTile(
            title: Text(task!.title),
            subtitle: Text(task.description.toString()),
          ),
        );
      },
    );
  }
}
