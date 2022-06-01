import 'package:get/get.dart';
import 'package:vs1_application_1/db/db_helper.dart';

import '../models/task.dart';

class TaskController extends GetxController {
  final taskList = <Task>[].obs;

  Future<int> addTask({required Task task}) {
    return DBHelper.insert(task);
  }

  Future<void> getTasks() async {
    List<Map<String, dynamic>> tasks = await DBHelper.query();
    taskList.assignAll(tasks.map((data) => Task.fromJson(data)).toList());
  }

  void deleteAllTasks() async {
    await DBHelper.deleteAll();
    getTasks();
  }

  void deleteTasks({required Task task}) async {
    await DBHelper.delete(task);
    getTasks();
  }

  void markTaskCompleted({required int id}) async {
    await DBHelper.update(id);
    getTasks();
  }
}
