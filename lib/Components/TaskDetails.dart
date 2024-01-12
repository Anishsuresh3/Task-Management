import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:taskm/Models/task_controler.dart';
import 'package:taskm/Models/tasks_provider.dart';
import 'package:toast/toast.dart';

import '../Models/data/task.dart';
import '../ScreenComponent/ScreenSize.dart';
class TaskDetails extends StatefulHookConsumerWidget {
  const TaskDetails({Key? key,required this.id}) : super(key: key);

  final id;

  @override
  ConsumerState<TaskDetails> createState() => _TaskDetailsState(id: id);
}

class _TaskDetailsState extends ConsumerState<TaskDetails> {
   _TaskDetailsState({required this.id});
  final id;
  late Task? task;
  bool _isEditable = false;
  TextEditingController _controllerDesc = TextEditingController();

   @override
  Widget build(BuildContext context) {
     SizeConfig().init(context);
     ToastContext().init(context);
    task = ref.watch(taskControllerProvider).getParticularTask(id);
    _controllerDesc.text = task!.description.toString();
    return Scaffold(
      appBar: AppBar(
        title: Text(
            task!.title,
          style: const TextStyle(fontFamily: 'UbuntuB'),
        ),
        leading:  IconButton(
          icon: Icon(Iconsax.backward),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
              onPressed: (){
                setState(() {
                  _isEditable = !_isEditable;
                  if (!_isEditable) {
                    FocusScope.of(context).unfocus();
                  }
                });
              },
              icon: Icon(Iconsax.edit)
          ),
          IconButton(
              onPressed: (){
                ref.read(hiveData.notifier).updateTodo(
                    id,
                    task!.copyWith(
                        title: task!.title,
                        description: task!.description,
                        isCompleted: true,
                        deadline: task!.deadline,
                        priority: task!.priority));
                Navigator.pop(context);
              },
              icon: Icon(Iconsax.tick_square)
          )
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: getProportionateScreenHeight(20.0),
          ),
          Container(
            color: _isEditable?Colors.deepPurple[50]:Colors.white30,
            child: TextField(
              controller: _controllerDesc,
              enabled: _isEditable,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
                fillColor: _isEditable?Colors.black26:Colors.deepPurple[50],
              ),
            ),
          ),
          SizedBox(
            height: getProportionateScreenHeight(20.0),
          ),

        ],
      ),
    );
  }
}

