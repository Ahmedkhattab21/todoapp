import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import 'package:vs1_application_1/ui/pages/notification_screen.dart';
import 'package:vs1_application_1/ui/theme.dart';

import '../../controllers/task_controller.dart';
import '../../models/task.dart';
import '../../services/notification_services.dart';
import '../../services/theme_services.dart';
import '../size_config.dart';
import '../widgets/button.dart';
import '../widgets/task_tile.dart';
import 'add_task_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TaskController _taskController = Get.put(TaskController());
  //kllk
  late NotifyHelper notifyHelper;
  @override
  void initState() {
    notifyHelper = NotifyHelper();
    super.initState();
    notifyHelper.requestIOSPermissions();
    notifyHelper.initializeNotification();
    _taskController.getTasks();
  }

  DateTime _selectedDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: _appbar(context),
      body: Column(
        children: [
          _addTaskBar(),
          _addDateBar(),
          const SizedBox(
            height: 7,
          ),
          _showTask(context),
        ],
      ),
    );
  }

  AppBar _appbar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(
          Get.isDarkMode
              ? Icons.wb_sunny_outlined
              : Icons.nightlight_round_outlined,
          size: 24,
          color: Get.isDarkMode ? Colors.white : Colors.black,
        ),
        onPressed: () {
          ThemeServices().switchTheme();
        },
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.cleaning_services_outlined,
            size: 20,
            color: Get.isDarkMode ? Colors.white : Colors.black,
          ),
          onPressed: () {
            notifyHelper.cancelAllNotification();
            _taskController.deleteAllTasks();
          },
        ),
        const CircleAvatar(
          backgroundImage: AssetImage('images/person.jpeg'),
          radius: 17,
        ),
        const SizedBox(
          width: 10,
        ),
      ],
      elevation: 0,
      backgroundColor: Theme.of(context).backgroundColor,
    );
  }

  _addTaskBar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 10, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.yMMMd().format(DateTime.now()),
                style: subHeadingStyle,
              ),
              Text(
                "Today",
                style: headingStyle,
              ),
            ],
          ),
          MyButton(
            label: '+ Add Task',
            onTap: () async {
              await Get.to(() => const AddTaskPage());
            },
          ),
        ],
      ),
    );
  }

  _addDateBar() {
    return Container(
      margin: const EdgeInsets.only(top: 10, left: 20),
      child: DatePicker(
        DateTime.now(),
        initialSelectedDate: _selectedDate,
        height: 100,
        width: 100,
        selectedTextColor: Colors.white,
        selectionColor: primaryClr,
        monthTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
        dateTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.grey,
            fontSize: 16,
          ),
        ),
        dayTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.grey,
            fontSize: 18,
          ),
        ),
        onDateChange: (newDate) {
          setState(() {
            _selectedDate = newDate;
          });
        },
      ),
    );
  }

  _showTask(BuildContext conx) {
    return Expanded(
      child: Obx(
        (() {
          if (_taskController.taskList.isEmpty) {
            return _noTaskmg();
          } else {
            return RefreshIndicator(
              onRefresh: _onreferesh,
              child: ListView.builder(
                scrollDirection: SizeConfig.orientation == Orientation.landscape
                    ? Axis.horizontal
                    : Axis.vertical,
                itemCount: _taskController.taskList.length,
                itemBuilder: ((context, index) {
                  var task = _taskController.taskList[index];
                  if (_selectedDate
                          .isAfter(DateFormat.yMd().parse(task.date!)) ||
                      _selectedDate == DateFormat.yMd().parse(task.date!)) {
                    if (task.repeat == 'Daily' ||
                        task.date == DateFormat.yMd().format(_selectedDate) ||
                        (task.repeat == 'Weekly' &&
                            _selectedDate
                                        .difference(
                                            DateFormat.yMd().parse(task.date!))
                                        .inDays %
                                    7 ==
                                0) ||
                        (task.repeat == 'Monthly' &&
                            DateFormat.yMd().parse(task.date!).day ==
                                _selectedDate.day)) {
                      var date = DateFormat.jm().parse(task.startTime!);

                      // notifyHelper.displayNotification(task: task);
                      notifyHelper.scheduledNotification(
                          int.parse(date.hour.toString()),
                          int.parse(date.minute.toString()),
                          task);

                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 500),
                        child: SlideAnimation(
                          horizontalOffset: 400.0,
                          child: FadeInAnimation(
                            child: GestureDetector(
                              onTap: () {
                                showBottomSheet(
                                  context,
                                  task,
                                );
                              },
                              child: TaskTile(task),
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  } else {
                    return Container();
                  }
                }),
              ),
            );
          }
        }),
      ),
    );
  }

  _noTaskmg() {
    return RefreshIndicator(
      onRefresh: _onreferesh,
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(seconds: 2),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                direction: SizeConfig.orientation == Orientation.landscape
                    ? Axis.horizontal
                    : Axis.vertical,
                children: [
                  SizeConfig.orientation == Orientation.landscape
                      ? const SizedBox(
                          height: 10,
                        )
                      : const SizedBox(
                          height: 200,
                        ),
                  SvgPicture.asset(
                    'images/task.svg',
                    width: 70,
                    height: 70,
                    color: primaryClr.withOpacity(.5),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "You dont have any tasks yet! \n Add new Tasks to make your day productive",
                      style: subHeadingStyle2,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizeConfig.orientation == Orientation.landscape
                      ? const SizedBox(
                          height: 10,
                        )
                      : const SizedBox(
                          height: 110,
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(
      SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(top: 5),
          width: SizeConfig.screenWidth,
          height: (SizeConfig.orientation == Orientation.landscape)
              ? (task.isCompleted == 1
                  ? SizeConfig.screenHeight * .6
                  : SizeConfig.screenHeight * .8)
              : (task.isCompleted == 1
                  ? SizeConfig.screenHeight * .3
                  : SizeConfig.screenHeight * .39),
          color: Get.isDarkMode ? darkHeaderClr : Colors.white,
          child: Column(children: [
            Flexible(
              child: Container(
                height: 6,
                width: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300],
                ),
              ),
            ),
            task.isCompleted == 1
                ? Container()
                : _buildBottomSheet(
                    label: "Task Completed",
                    ontap: () {
                      notifyHelper.cancelNotification(task);
                      _taskController.markTaskCompleted(id: task.id!);
                      Get.back();
                    },
                    clr: primaryClr),
            _buildBottomSheet(
                label: "delete Task",
                ontap: () {
                  _taskController.deleteTasks(task: task);
                  notifyHelper.cancelNotification(task);
                  Get.back();
                },
                clr: Colors.red[300]!),
            Divider(
              color: Get.isDarkMode ? Colors.grey : darkGreyClr,
            ),
            _buildBottomSheet(
                label: "Cancel",
                ontap: () {
                  Get.back();
                },
                clr: primaryClr),
            const SizedBox(
              height: 20,
            ),
          ]),
        ),
      ),
    );
  }

  _buildBottomSheet(
      {required label,
      required Function() ontap,
      required Color clr,
      bool isClose = false}) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        height: 65,
        width: SizeConfig.screenWidth * .9,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: isClose
                ? Get.isDarkMode
                    ? Colors.grey[600]!
                    : Colors.grey[300]!
                : clr,
          ),
          borderRadius: BorderRadius.circular(20),
          color: isClose ? Colors.transparent : clr,
        ),
        child: Center(
          child: Text(
            label,
            style: isClose
                ? titleStyle
                : titleStyle.copyWith(
                    color: Colors.white,
                  ),
          ),
        ),
      ),
    );
  }

  Future<void> _onreferesh() async {
    _taskController.getTasks();
  }
}
