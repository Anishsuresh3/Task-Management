import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:taskm/Components/TaskDetails.dart';
import 'package:taskm/Models/task_controler.dart';
import 'package:taskm/Models/tasks_provider.dart';

class TaskTile extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(TasksDataProvider);
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        if(tasks.isNotEmpty){
          final task = tasks[index];
            return ListTile(
              title: Text(task!.title),
              subtitle: Text(task.description.toString()),
              onLongPress: (){

              },
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TaskDetails(id: task.key,)),
                );
              },
            );
          }
        }

    );
  }
}
