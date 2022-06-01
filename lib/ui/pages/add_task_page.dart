import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vs1_application_1/models/task.dart';
import 'package:vs1_application_1/ui/widgets/button.dart';
import 'package:intl/intl.dart';

import '../../controllers/task_controller.dart';
import '../theme.dart';
import '../widgets/input_field.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = Get.put(TaskController());

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _startTime = DateFormat.jm().format(DateTime.now()).toString();
  String _endTime = DateFormat.jm()
      .format(DateTime.now().add(const Duration(minutes: 15)))
      .toString();
  int _selectedRemind = 5;
  List<int> remindList = [5, 10, 15, 20];
  String _selectedRepeat = 'None';
  List<String> repeatList = ['None', 'Daily', 'Weekly', 'Monthly'];

  int _selectColor = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 24,
            color: Get.isDarkMode ? Colors.white : Colors.black,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        actions: const [
          CircleAvatar(
            backgroundImage: AssetImage('images/person.jpeg'),
            radius: 17,
          ),
          SizedBox(
            width: 10,
          ),
        ],
        elevation: 0,
        backgroundColor: Theme.of(context).backgroundColor,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "Add Task",
                style: headingStyle,
              ),
              InputField(
                title: "Title",
                hint: "Enter title here",
                controller: _titleController,
              ),
              InputField(
                title: "Note",
                hint: "Enter note here",
                controller: _noteController,
              ),
              InputField(
                title: "Date",
                hint: DateFormat.yMd().format(_selectedDate),
                widget: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.access_alarm_outlined,
                      ),
                      onPressed: () => _getDateFromUser(),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: InputField(
                      title: "Start Time",
                      hint: _startTime,
                      widget: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.access_alarm_outlined),
                            onPressed: () =>
                                _getTimeFromUser(isStartTime: true),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: InputField(
                      title: "End Time",
                      hint: _endTime,
                      widget: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.access_alarm_outlined),
                            onPressed: () =>
                                _getTimeFromUser(isStartTime: false),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              InputField(
                title: "Remind",
                hint: "$_selectedRemind minutes early",
                widget: Row(
                  children: [
                    DropdownButton(
                      value: _selectedRemind.toString(),
                      items: remindList
                          .map((e) => DropdownMenuItem(
                                value: e.toString(),
                                child: Text(
                                  "$e",
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ))
                          .toList(),
                      onChanged: (String? val) {
                        setState(() {
                          _selectedRemind = int.parse(val!);
                        });
                      },
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.grey,
                      ),
                      iconSize: 32,
                      underline: Container(
                        height: 0,
                      ),
                      style: subHeadingStyle,
                      elevation: 5,
                      dropdownColor: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ),
              InputField(
                title: "Repeat",
                hint: _selectedRepeat,
                widget: Row(
                  children: [
                    DropdownButton(
                      value: _selectedRepeat,
                      items: repeatList
                          .map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(
                                  e,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ))
                          .toList(),
                      onChanged: (String? val) {
                        setState(() {
                          _selectedRepeat = val!;
                        });
                      },
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.grey,
                      ),
                      iconSize: 32,
                      underline: Container(
                        height: 0,
                      ),
                      style: subHeadingStyle,
                      elevation: 5,
                      dropdownColor: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  colorsmethods(),
                  MyButton(
                      label: "Add Task",
                      onTap: () {
                        _validateDate();
                        _taskController.getTasks();
                      })
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _validateDate() {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      _addTaskToDb();
      Get.back();
    } else if (_titleController.text.isEmpty || _noteController.text.isEmpty) {
      Get.snackbar(
        "required",
        " All fields are required !",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: pinkClr,
        duration: const Duration(seconds: 1),
        icon: const Icon(
          Icons.warning_amber_rounded,
          color: Colors.red,
        ),
      );
    } else {
      print("not impty or completed");
    }
  }

  _addTaskToDb() async {
    int value = await _taskController.addTask(
      task: Task(
        title: _titleController.text,
        note: _noteController.text,
        isCompleted: 0,
        date: DateFormat.yMd().format(_selectedDate),
        startTime: _startTime,
        endTime: _endTime,
        color: _selectColor,
        remind: _selectedRemind,
        repeat: _selectedRepeat,
      ),
    );
    print('$value');
  }

  Column colorsmethods() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Color',
          style: titleStyle,
        ),
        Wrap(
          children: List.generate(
            3,
            (i) => GestureDetector(
              onTap: () {
                setState(() {
                  _selectColor = i;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 6.0),
                child: CircleAvatar(
                  backgroundColor: i == 0
                      ? blueClr
                      : i == 1
                          ? pinkClr
                          : orangeClr,
                  radius: 11,
                  child: _selectColor == i
                      ? const Icon(
                          Icons.done,
                          size: 13,
                          color: Colors.white,
                        )
                      : null,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  _getDateFromUser() async {
    DateTime? _pickedDate = await showDatePicker(
      context: context,
      initialEntryMode: DatePickerEntryMode.calendar,
      initialDate: _selectedDate,
      firstDate: DateTime(2015),
      lastDate: DateTime(2030),
    );
    if (_pickedDate != null) {
      setState(
        () => _selectedDate = _pickedDate,
      );
    } else {
      print("It \'s null or something is wrong ");
    }
  }

  _getTimeFromUser({required bool isStartTime}) async {
    TimeOfDay? _pickedTime = await showTimePicker(
      context: context,
      initialEntryMode: TimePickerEntryMode.input,
      initialTime: isStartTime
          ? TimeOfDay.fromDateTime(DateFormat.jm().parse(_startTime))
          : TimeOfDay.fromDateTime(DateFormat.jm().parse(_endTime)),
    );
    if (_pickedTime != null) {
      if (isStartTime) {
        setState(() {
          _startTime = _pickedTime.format(context);
        });
      } else if (!isStartTime) {
        setState(() {
          _endTime = _pickedTime.format(context);
        });
      } else {
        print("time Canceled ");
      }
    } else {
      print("is null value");
    }
  }
}
