import 'dart:io';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:material_tag_editor/tag_editor.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart';
import 'package:taskm/Models/provider/tasks_provider.dart';
import 'package:toast/toast.dart';
import 'package:intl/intl.dart';
import '../Models/task_controler.dart';
import '../ScreenComponent/ScreenSize.dart';
class TaskDetails extends StatefulHookConsumerWidget {
  const TaskDetails({Key? key,required this.task}) : super(key: key);

  final task;

  @override
  ConsumerState<TaskDetails> createState() => _TaskDetailsState(task: task);
}

class _TaskDetailsState extends ConsumerState<TaskDetails> {
  _TaskDetailsState({required this.task});

  final task;
  late final key;
  bool _isEditable = false;
  DateTime _selectedDate = DateTime.now();
  late String time;
  DateTime? dateTime;
  TextEditingController _controllerDesc = TextEditingController();
  TextEditingController _controllerDeadLine = TextEditingController();
  TextEditingController _controllerPri = TextEditingController();
  List<String> priority = ['Very Important', 'High', 'Medium', 'Low'];

  @override
  void initState() {
    super.initState();
    _controllerDesc.text = task!.description.toString();
    _controllerDeadLine.text = DateFormat('yyyy-MM-dd h:mm a')
        .format(task!.deadline);
    _controllerPri.text = priority[task!.priority];
    key = task.key;
  }

  void _openFile(String? path) {
    OpenFile.open(path);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    ToastContext().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          task!.title,
          style: const TextStyle(fontFamily: 'UbuntuB'),
        ),
        leading: IconButton(
          icon: Icon(Iconsax.backward),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          _isEditable ?
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFECE4FD),
                  shadowColor: Colors.black
              ),
              onPressed: () {
                ref.read(hiveData.notifier).updateTodo(
                  key,
                    task.copyWith(
                    title: task!.title,
                    description: _controllerDesc.text,
                    isCompleted: false,
                    deadline: dateTime??task.deadline,
                    filePath: task?.filePath,
                    tags: task.tags,
                    priority: priority.indexOf(_controllerPri.text),
                  )
                );
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
          ) :
          IconButton(
              onPressed: () {
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
              onPressed: () {
                AndroidAlarmManager.cancel(key);
                ref.read(hiveData.notifier).updateTodo(
                    key,
                    task!.copyWith(
                        title: task!.title,
                        description: task!.description,
                        isCompleted: true,
                        deadline: task!.deadline,
                        priority: task!.priority));
                Toast.show("Task Completed!!!",
                    duration: Toast.lengthLong,
                    backgroundColor: const Color(0xFFEDE7F6),
                    backgroundRadius: 2,
                    textStyle: const TextStyle(
                        color: Colors.black
                    ),
                    gravity:  Toast.bottom);
                Navigator.pop(context);
              },
              icon: Icon(Iconsax.tick_square)
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
              onSubmitted: (e) {
                print(e);
                setState(() {
                  _controllerDesc.text = e;
                });
              },
            ),
            SizedBox(
              height: getProportionateScreenHeight(20.0),
            ),
            TextFormField(
              controller: _controllerDeadLine,
              enabled: _isEditable,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Deadline',
                labelStyle: TextStyle(color: Colors.deepPurple[400]),
                fillColor: Colors.deepPurple[50],
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Iconsax.calendar),
                  onPressed: () async {
                    var dateTimeData = (await showOmniDateTimePicker(
                        context: context))!;
                    if (dateTimeData != null) {
                      AndroidAlarmManager.cancel(key);
                      String formattedDateTime = DateFormat('yyyy-MM-dd h:mm a')
                          .format(dateTimeData);
                      setState(() {
                        dateTime = dateTimeData;
                      });
                      _controllerDeadLine.text = formattedDateTime;
                    }
                  },
                ),
              ),
              style: const TextStyle(color: Colors.black),
            ),
            SizedBox(
              height: getProportionateScreenHeight(20.0),
            ),
            Container(
              margin: EdgeInsets.only(left: 5, right: 10),
              child: DropdownMenu<String>(
                enabled: _isEditable,
                controller: _controllerPri,
                enableFilter: true,
                requestFocusOnTap: true,
                width: getProportionateScreenWidth(380),
                label: Text(
                  'Priority',
                  style: TextStyle(color: Colors.deepPurple[400]),
                ),
                inputDecorationTheme: const InputDecorationTheme(
                  contentPadding: EdgeInsets.symmetric(vertical: 5.0),
                ),
                onSelected: (String? label) {
                  print(_controllerPri.text);
                },
                dropdownMenuEntries: priority.map<DropdownMenuEntry<String>>(
                      (String label) {
                    return DropdownMenuEntry<String>(
                      value: label,
                      label: label,
                    );
                  },
                ).toList(),
              ),
            ),
            SizedBox(
              height: getProportionateScreenHeight(20.0),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                "Tags",
                style: TextStyle(
                    color: Colors.deepPurple[400]
                ),
              ),
            ),
            TagEditor(
                enabled: _isEditable,
                length: task?.tags?.length ?? 0,
                delimiters: const [',', ' '],
                hasAddButton: true,
                inputDecoration: const InputDecoration(
                  border: OutlineInputBorder(borderSide: BorderSide()),
                ),
                onTagChanged: (newValue) {
                  print(newValue);
                  setState(() {
                    task?.tags?.add(newValue);
                  });
                },
                tagBuilder: (context, index) =>
                    Chip(
                      labelPadding: const EdgeInsets.only(left: 8.0),
                      label: Text(task!.tags![index]),
                      deleteIcon: _isEditable ? const Icon(
                        Icons.close,
                        size: 18,
                      ) : null,
                      onDeleted: () {
                        if(_isEditable){
                          setState(() {
                            task?.tags?.removeAt(index);
                          });
                        }
                      },
                    )
            ),
            SizedBox(
              height: getProportionateScreenHeight(20.0),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                children: [
                  Text(
                    "Files",
                    style: TextStyle(
                        color: Colors.deepPurple[400]
                    ),
                  ),
                  Spacer(),
                  IconButton(
                      onPressed: () async {
                        if(_isEditable){
                          FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);
                          if (result != null) {
                            List<File> file = result.paths.map((path) => File(path!)).toList();
                            setState(() {
                              file.forEach((element) {
                                task?.filePath.add(element.path);
                              });
                            });
                          } else {

                          }
                        }
                      },
                      icon: Icon(Iconsax.paperclip)
                  )
                ],
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemCount: task?.filePath?.length ?? 0,
              itemBuilder: (context, index) {
                if (task?.filePath != null) {
                  final file = task?.filePath![index];
                  return Card(
                    color: Colors.deepPurple[50],
                    margin: EdgeInsets.all(5),
                    child: ListTile(
                      enabled: _isEditable,
                      title: Text(basename(file!)),
                      leading: Icon(Icons.file_present_sharp),
                      trailing: _isEditable ?
                      IconButton(
                        onPressed: () {
                          setState(() {
                            task?.filePath?.removeAt(index);
                          });
                        },
                        icon: Icon(Iconsax.trash),
                      ) : null,
                      onTap: () {
                        if(_isEditable){
                          _openFile(file);
                        }
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}