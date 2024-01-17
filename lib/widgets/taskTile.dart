import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:taskm/Components/TaskDetails.dart';
import 'package:taskm/Models/provider/tasks_provider.dart';
import 'package:taskm/ScreenComponent/ScreenSize.dart';
class TaskTile extends StatefulHookConsumerWidget {
  const TaskTile({Key? key}) : super(key: key);

  @override
  ConsumerState<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends ConsumerState<TaskTile> {
  bool _isLongPressed = false;
  int indexTile = -1;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final tasks = ref.watch(TasksDataProvider);
    return ListView.builder(
        itemCount: tasks.length+1,
        itemBuilder: (context, index) {
          if(tasks.isNotEmpty && index!=tasks.length){
            final task = tasks[index];
            return Card(
              margin: EdgeInsets.all(5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0), // Border radius
              ),
              child: ListTile(
                title: Text(
                  task!.title,
                  style: const TextStyle(fontFamily: 'UbuntuB'),
                ),
                subtitle:  RichText(
                  text: TextSpan(
                    text: "${task.description}\n\n",
                    style: const TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: DateFormat('yyyy-MM-dd h:mm a')
                            .format(task.deadline).toString(),
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.black
                        ),
                      ),
                    ],
                  ),
                ),
                trailing: _isLongPressed && indexTile==index ?
                IconButton(
                  onPressed: () {
                    AndroidAlarmManager.cancel(task.key);
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
                    MaterialPageRoute(builder: (context) => TaskDetails(task: task,)),
                  );
                },
              ),
            );
          }
          return Container(
            height: getProportionateScreenHeight(80),
          );
        }
    );
  }
}

