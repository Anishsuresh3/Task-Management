import 'dart:io';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:path/path.dart';
import 'package:simple_chips_input/select_chips_input.dart';
import 'package:simple_chips_input/simple_chips_input.dart';
import 'package:taskm/Models/task_controler.dart';
import 'package:taskm/Models/provider/tasks_provider.dart';
import 'package:toast/toast.dart';
import '../Models/data/task.dart';
import '../ScreenComponent/ScreenSize.dart';

class NewTask extends StatefulHookConsumerWidget {
  const NewTask({Key? key}) : super(key: key);

  @override
  ConsumerState<NewTask> createState() => _NewTaskState();
}

class _NewTaskState extends ConsumerState<NewTask>{

  final TextEditingController _controllerTitle = TextEditingController();
  final TextEditingController _controllerDesc = TextEditingController();
  final TextEditingController _controllerDate = TextEditingController();
  late SingleValueDropDownController _cnt;
  bool isTextNotEmpty = false;
  DateTime _selectedDate = DateTime.now();
  List<String> tags =[];
  late String time;
  List<String> files = [];
  late DateTime dateTime;

  final keySimpleChipsInput = GlobalKey<FormState>();
  final FocusNode focusNode = FocusNode();
  final TextFormFieldStyle style = const TextFormFieldStyle(
    keyboardType: TextInputType.text,
    decoration: InputDecoration(
      contentPadding: EdgeInsets.all(0.0),
      border: InputBorder.none,
    ),
  );

  @override
  void initState() {
    super.initState();
    _cnt = SingleValueDropDownController();
    _controllerTitle.addListener(_checkText);
    _controllerDesc.addListener(_checkText);
    _controllerDate.addListener(_checkText);
  }

  @override
  void dispose() {
    _cnt.dispose();
    _controllerTitle.dispose();
    _controllerDesc.dispose();
    _controllerDate.dispose();
    super.dispose();
  }

  void _checkText() {
    setState(() {
      isTextNotEmpty = _controllerTitle.text.isNotEmpty;
    });
  }

  void clearText(TextEditingController controller) {
    setState(() {
      controller.clear();
      isTextNotEmpty = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    ToastContext().init(context);
    return Scaffold(
          appBar: AppBar(
            title: const Text("New Task",
              style: TextStyle(
                  fontFamily: 'UbuntuB',
                  fontSize: 30
              ),),
            leading: IconButton(
              icon: Icon(Iconsax.backward),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            actions: [
              IconButton(onPressed: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);

                if (result != null) {
                  List<File> file = result.paths.map((path) => File(path!)).toList();
                  setState(() {
                    file.forEach((element) { 
                      files.add(element.path);
                    });
                  });
                } else {
                  
                }

              }, icon: Icon(Iconsax.paperclip)
              )
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: getProportionateScreenHeight(30.0),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 35),
                    child: Text('Title:',
                      style: TextStyle(fontFamily: 'UbuntuB',fontSize: 18),),
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(10.0),
                  ),
                  Container(
                      width: getProportionateScreenWidth(330.0),
                      padding: EdgeInsets.only(left: getProportionateScreenWidth(30.0)),
                      child: TextFormField(
                        controller: _controllerTitle,
                        decoration: InputDecoration(
                          labelText: 'Title',
                          labelStyle: TextStyle(color: Colors.deepPurple[400]),
                          filled: true,
                          fillColor: Colors.deepPurple[50],
                          contentPadding: const EdgeInsets.all(16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Color(0xFF9575CD)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(color: Color(0xFF9575CD)),
                          ),
                          suffixIcon: _controllerTitle.text.isNotEmpty
                              ? IconButton(
                            icon: const ImageIcon(
                              AssetImage('assets/images/icon_clear.png'),
                            ),
                            onPressed: () {
                              clearText(_controllerTitle);
                            },
                          ) : null,
                        ),
                        style: const TextStyle(color: Colors.black),
                        textInputAction: TextInputAction.next,
                        maxLines: 1,
                      )
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(10.0),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 35),
                    child: Text('Description:',
                      style: TextStyle(fontFamily: 'UbuntuB',fontSize: 18),),
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(10.0),
                  ),
                  Container(
                      width: getProportionateScreenWidth(330.0),
                      padding: EdgeInsets.only(left: getProportionateScreenWidth(30.0)),
                      child: TextFormField(
                        controller: _controllerDesc,
                        decoration: InputDecoration(
                          labelText: 'Description',
                          labelStyle: TextStyle(color: Colors.deepPurple[400]),
                          filled: true,
                          fillColor: Colors.deepPurple[50],
                          contentPadding: const EdgeInsets.all(16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Color(0xFF9575CD)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(color: Color(0xFF9575CD)),
                          ),
                          suffixIcon: _controllerDesc.text.isNotEmpty
                              ? IconButton(
                            icon: const ImageIcon(
                              AssetImage('assets/images/icon_clear.png'),
                            ),
                            onPressed: () {
                              clearText(_controllerDesc);
                            },
                          ) : null,
                        ),
                        style: const TextStyle(color: Colors.black),
                        textInputAction: TextInputAction.next,
                      )
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(10.0),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 35),
                    child: Text('Deadline:',
                      style: TextStyle(fontFamily: 'UbuntuB',fontSize: 18),),
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(10.0),
                  ),
                  Container(
                      width: getProportionateScreenWidth(330.0),
                      padding: EdgeInsets.only(left: getProportionateScreenWidth(30.0)),
                      child: TextFormField(
                        controller: _controllerDate,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: !_controllerDate.text.isNotEmpty?'Select Date and Time':'Date and Time',
                          labelStyle: TextStyle(color: Colors.deepPurple[400]),
                          filled: true,
                          fillColor: Colors.deepPurple[50],
                          contentPadding: const EdgeInsets.all(16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Color(0xFF9575CD)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(color: Color(0xFF9575CD)),
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(Iconsax.calendar),
                            onPressed: () async {
                              var dateTimeData = (await showOmniDateTimePicker(
                                  context: context))!;
                              if (dateTimeData != null) {
                              String formattedDateTime = DateFormat('yyyy-MM-dd h:mm a')
                                  .format(dateTimeData);
                              setState(() {
                              dateTime = dateTimeData;
                              _controllerDate.text = formattedDateTime;
                              });
                              }
                            },
                          ),
                        ),
                        style: const TextStyle(color: Colors.black),
                        textInputAction: TextInputAction.next,
                        maxLines: 1,
                      )
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(10.0),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 35),
                    child: Text('Priority:',
                      style: TextStyle(fontFamily: 'UbuntuB',fontSize: 18),),
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(10.0),
                  ),
                  Container(
                    width: getProportionateScreenWidth(300.0),
                    padding: const EdgeInsets.only(left: 10),
                    margin: EdgeInsets.only(left: getProportionateScreenWidth(30.0)),
                    decoration: BoxDecoration(
                        color: Colors.deepPurple[50],
                        border: const Border(
                          top: BorderSide(width: 1,color: Colors.black),
                          left: BorderSide(width: 1,color: Colors.black),
                          right: BorderSide(width: 1,color: Colors.black),
                        ),
                        borderRadius: const BorderRadius.all(Radius.circular(5.0))
                    ),
                    child: DropDownTextField(
                      controller: _cnt,
                      clearOption: true,
                      dropDownList: const [
                        DropDownValueModel(name: 'Very Important', value:0),
                        DropDownValueModel(name: 'High', value:1),
                        DropDownValueModel(name: 'Medium', value:2),
                        DropDownValueModel(name: 'Low', value:3),
                      ],
                      textStyle: const TextStyle(
                        fontFamily: 'UbuntuR',
                      ),
                      textFieldDecoration: InputDecoration(
                          hintText: "Set Priority",
                          hintStyle: TextStyle(color: Colors.deepPurple[400])
                      ),
                    ),
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(10.0),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 35),
                    child: Text('Tags:',
                      style: TextStyle(fontFamily: 'UbuntuB',fontSize: 18),),
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(10.0),
                  ),
                  Container(
                    width: getProportionateScreenWidth(310.0),
                    padding: const EdgeInsets.only(left: 10),
                    margin: EdgeInsets.only(left: getProportionateScreenWidth(20.0)),
                    child: SimpleChipsInput(
                      separatorCharacter: "\n",
                      focusNode: focusNode,
                      textFormFieldStyle: style,
                      onSubmitted: (p0) {
                      },
                      onChipDeleted: (p0, p1) {
                        tags.remove(p0);
                      },
                      onChipAdded: ((p){
                        tags.add(p.toString());
                      }),
                      chipTextStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                      deleteIcon: const Icon(
                        Iconsax.close_circle,
                        size: 14.0,
                        color: Colors.black,
                      ),
                      widgetContainerDecoration: BoxDecoration(
                        color: Colors.deepPurple[50],
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(color: Colors.black),
                      ),
                      chipContainerDecoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.deepPurple[100]
                      ),
                      placeChipsSectionAbove: false,
                    ),
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(10.0),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount: files.length,
                    itemBuilder: (context, index) {
                      final file = files[index];
                      return Card(
                        color: Colors.deepPurple[50],
                        margin: EdgeInsets.all(5),
                        child: ListTile(
                          title: Text(basename(file)),
                          leading: Icon(Icons.file_present_sharp),
                          trailing:
                          IconButton(
                            onPressed: () {
                              setState(() {
                                files.removeAt(index);
                              });
                            },
                            icon: Icon(Iconsax.trash) ,
                          ),
                          onTap: (){
                            setState(() {
                            });
                          },
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(20.0),
                  ),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFD1C4E9),
                        minimumSize: Size(280, 50),
                      ),
                      onPressed: () async {
                        if(validateInput() && DateTime.now().compareTo(dateTime)==-1){
                          final task = Task(
                              title: _controllerTitle.text,
                              description: _controllerDesc.text,
                              deadline: dateTime,
                              priority: _cnt.dropDownValue?.value ?? 3,
                              tags: tags,
                              filePath: files
                          );
                          ref.read(hiveData.notifier).addTask(task);
                          Navigator.pop(context);
                        }
                        else{
                          Toast.show("Please fill the Details",
                              duration: Toast.lengthLong,
                              backgroundColor: const Color(0xFFEDE7F6),
                              backgroundRadius: 2,
                              textStyle: const TextStyle(
                                  color: Colors.black
                              ),
                              gravity:  Toast.bottom);
                        }
                      },
                      child: const Text(
                        'Create Task',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ),
        );
  }

  bool validateInput(){
    if(_controllerTitle.text.isEmpty || _controllerDate.text.isEmpty) {
      return false;
    }
    return true;
  }
}
