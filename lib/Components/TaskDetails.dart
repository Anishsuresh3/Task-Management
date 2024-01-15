import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:taskm/Models/task_controler.dart';
import 'package:taskm/Models/provider/tasks_provider.dart';
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
  DateTime _selectedDate = DateTime.now();
  late String time;
  TextEditingController _controllerDesc = TextEditingController();
  TextEditingController _controllerDeadLine = TextEditingController();
   TextEditingController _controllerPri = TextEditingController();
   @override
  Widget build(BuildContext context) {
     SizeConfig().init(context);
     ToastContext().init(context);
    task = ref.watch(taskControllerProvider).getParticularTask(id);
    _controllerDesc.text = task!.description.toString();
     _controllerDeadLine.text = task!.deadline.toString();
     _controllerPri.text = task!.priority.toString();
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
          _isEditable?
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFECE4FD),
                shadowColor: Colors.black
              ),
              onPressed: (){
                setState(() {
                  _isEditable = false;
                });
              },
              child: const Text(
                'Save',
                style: TextStyle(
                  fontSize: 12
                ),
              )
          ):
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
          TextField(
            controller: _controllerDesc,
            enabled: _isEditable,
            decoration: InputDecoration(
              labelText: 'Description',
              labelStyle: TextStyle(color: Colors.deepPurple[400]),
              border: OutlineInputBorder(),
            ),
            style: const TextStyle(color: Colors.black),
          ),
          SizedBox(
            height: getProportionateScreenHeight(20.0),
          ),
          TextFormField(
            controller: _controllerDeadLine,
            enabled: _isEditable,
            decoration: InputDecoration(
              labelText: 'Deadline',
              labelStyle: TextStyle(color: Colors.deepPurple[400]),
              fillColor: Colors.deepPurple[50],
              border: OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: const Icon(Iconsax.calendar),
                onPressed: () {
                  _getDateFromUser();
                },
              ),
            ),
            style: const TextStyle(color: Colors.black),
          ),
          SizedBox(
            height: getProportionateScreenHeight(20.0),
          ),
          TextFormField(
            controller: _controllerPri,
            enabled: _isEditable,
            decoration: InputDecoration(
              labelText: 'Priority',
              labelStyle: TextStyle(color: Colors.deepPurple[400]),
              fillColor: Colors.deepPurple[50],
              border: OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: const Icon(Icons.arrow_drop_down_sharp),
                onPressed: () {

                },
              ),
            ),
            style: const TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
   _getDateFromUser() async {
     final DateTime? _pickedDate = await showDatePicker(
         context: context,
         initialDate: _selectedDate,
         initialDatePickerMode: DatePickerMode.day,
         firstDate: DateTime(2015),
         lastDate: DateTime(2101));
     if (_pickedDate != null) {
       setState(() {
         _controllerDeadLine.text = _pickedDate.toString().substring(0,11);
       });
       _getTimeFromUser();
     }
   }
   _getTimeFromUser() async {
     var _pickedTime = await _showTimePicker();
     if(_pickedTime != null){
       setState(() {
         _controllerDeadLine.text += _pickedTime.format(context).toString();
         time = _pickedTime.toString().substring(10,15);
       });
     }
   }
   _showTimePicker() async {
     return showTimePicker(
       initialTime: TimeOfDay(hour: 8, minute: 30),
       initialEntryMode: TimePickerEntryMode.input,
       context: context,
     );
   }
}

