import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:simple_chips_input/select_chips_input.dart';
import 'package:simple_chips_input/simple_chips_input.dart';
import 'package:taskm/Models/task_controler.dart';
import 'package:taskm/Models/tasks_provider.dart';
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
                          onPressed: () {
                            _getDateFromUser();
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
                      // print(p);
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
                  height: getProportionateScreenHeight(110.0),
                ),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFD1C4E9),
                      minimumSize: Size(280, 50),
                    ),
                    onPressed: () {
                      if(validateInput()){
                        final task = Task(
                            title: _controllerTitle.text,
                            description: _controllerDesc.text,
                            deadline: getDateTime(),
                            priority: _cnt.dropDownValue!.value,
                            tags: tags,
                            filePath: []
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

  DateTime getDateTime(){
    List<String> dateParts = _controllerDate.text.substring(0,10).split('-');
    int year = int.parse(dateParts[0]);
    int month = int.parse(dateParts[1]);
    int day = int.parse(dateParts[2]);

    DateTime parsedDate = DateTime(year, month, day);
    DateTime parsedTime = DateTime.parse('1970-01-01 ' + time);

    DateTime combinedDateTime = DateTime(parsedDate.year, parsedDate.month, parsedDate.day, parsedTime.hour, parsedTime.minute);

    return combinedDateTime;
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
        _selectedDate = _pickedDate;
        _controllerDate.text = _pickedDate.toString().substring(0,11);
      });
      _getTimeFromUser();
    }
  }
  _getTimeFromUser() async {
    var _pickedTime = await _showTimePicker();
    if(_pickedTime != null){
      setState(() {
        _controllerDate.text += _pickedTime.format(context).toString();
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
