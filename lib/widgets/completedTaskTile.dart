import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:taskm/Models/provider/tasks_provider.dart';

class CompletedTaskTile extends StatefulHookConsumerWidget {
  const CompletedTaskTile({Key? key}) : super(key: key);

  @override
  ConsumerState<CompletedTaskTile> createState() => _CompletedTaskTileState();
}

class _CompletedTaskTileState extends ConsumerState<CompletedTaskTile> {
  bool _isPressed = false;
  int indexTile = -1;
  @override
  Widget build(BuildContext context) {
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
            trailing: _isPressed && indexTile==index ?
            IconButton(
              onPressed: () {
                ref.read(hiveData.notifier).removeTask(task.key);
                setState(() {
                  _isPressed = false;
                });
              },
              icon: Icon(Iconsax.trash) ,
            ) : null,
            onTap: (){
              setState(() {
                _isPressed = true;
                indexTile = index;
              });
            },
          ),
        );
      },
    );
  }
}
