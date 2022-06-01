import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vs1_application_1/ui/theme.dart';

import '../../models/task.dart';
import '../size_config.dart';

class TaskTile extends StatelessWidget {
  const TaskTile(this._task, {Key? key}) : super(key: key);
  final Task _task;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: EdgeInsets.only(
        left: getProportionateScreenWidth(
            SizeConfig.orientation == Orientation.landscape ? 7 : 16),
        right: getProportionateScreenWidth(
            SizeConfig.orientation == Orientation.landscape ? 7 : 16),
        bottom: getProportionateScreenWidth(12),
      ),
      width: SizeConfig.orientation == Orientation.landscape
          ? SizeConfig.screenWidth / 2
          : SizeConfig.screenWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: _getBgColor(_task.color),
      ),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    _task.title!,
                    style: GoogleFonts.lato(
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: 17,
                        color: Colors.grey[100],
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        "${_task.startTime} - ${_task.endTime}",
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[200],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    _task.note!,
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[200],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            width: .4,
            height: 60,
            color: Colors.grey[200]!.withOpacity(.8),
          ),
          RotatedBox(
            quarterTurns: 3,
            child: Text(
              _task.isCompleted == 0 ? "To Do" : "Completed",
              style: GoogleFonts.lato(
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 5,
          ),
        ],
      ),
    );
  }

  _getBgColor(int? color) {
    switch (color) {
      case 0:
        return blueClr;
      case 1:
        return pinkClr;
      case 2:
        return orangeClr;
      default:
        return blueClr;
    }
  }
}
