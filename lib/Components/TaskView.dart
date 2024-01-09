import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:toast/toast.dart';
import '../ScreenComponent/ScreenSize.dart';
class NewTask extends StatefulWidget {
  const NewTask({Key? key}) : super(key: key);

  @override
  State<NewTask> createState() => _NewTaskState();
}

class _NewTaskState extends State<NewTask> {

  final TextEditingController _controllerTitle = TextEditingController();
  final TextEditingController _controllerDesc = TextEditingController();
  final TextEditingController _controllerDate = TextEditingController();
  bool isTextNotEmpty = false;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _controllerTitle.addListener(_checkText);
    _controllerDesc.addListener(_checkText);
    _controllerDate.addListener(_checkText);
  }

  @override
  void dispose() {
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
      ),
      body: Column(
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
