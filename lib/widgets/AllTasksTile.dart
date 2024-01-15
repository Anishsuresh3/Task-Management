import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:taskm/Components/TaskDetails.dart';
import 'package:taskm/Models/provider/tasks_provider.dart';
class AllTaskTile extends StatefulHookConsumerWidget {
  const AllTaskTile({Key? key}) : super(key: key);

  @override
  ConsumerState<AllTaskTile> createState() => _AllTaskTile();
}

class _AllTaskTile extends ConsumerState<AllTaskTile> {
  bool _isLongPressed = false;
  int indexTile = -1;
  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(sortTasks);
    final sort = ref.watch(sortProvider);
    return ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          if(tasks.isNotEmpty){
            final task = tasks[index];
            return Card(
              margin: EdgeInsets.all(5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0), // Border radius
              ),
              child: ListTile(
                title: Text(task!.title),
                subtitle: Text(task.description.toString()),
                trailing: _isLongPressed && indexTile==index ?
                IconButton(
                  onPressed: () {
                    ref.read(hiveData.notifier).removeTask(task.key);
                    setState(() {
                      _isLongPressed = false;
                    });
                  },
                  icon: Icon(Iconsax.trash) ,
                ) : null,
                onLongPress: (){
                  setState(() {
                    _isLongPressed = true;
                    indexTile = index;
                  });
                },
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TaskDetails(id: task.key,)),
                  );
                },
              ),
            );
          }
        }
    );
  }
}
