import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import '../notification/NotificationService.dart';
import 'TaskModel.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class TaskController extends GetxController {
  final tasks = <Task>[].obs;
  @override
  void onInit() async {
    super.onInit();
    Noti.initialize(flutterLocalNotificationsPlugin);
    final box = await Hive.openBox('TODO');
    tasks.assignAll(box.values.map((e) => e as Task).toList());
    scheduleNotifications();
  }

  void addTask(Task task) async {
    final box = await Hive.openBox('TODO');
    String id = Uuid().v4();
    await box.put(id, task);
    tasks.add(task.copyWith(id: id));
    scheduleNotification(task.copyWith(id: id));
  }

  void deleteTask(Task task, int index) async {
    final box = await Hive.openBox('TODO');
    final taskToDelete = tasks.firstWhere((t) => t.id == task.id);
    if (taskToDelete.id.length > 0) {
      print("deleted${taskToDelete.id}");
      await box.deleteAt(index);
      cancelNotification(task);
      tasks.remove(taskToDelete);
      update();
    }
  }

  void updateTask(Task task) async {
    final box = await Hive.openBox('TODO');
    final index = tasks.indexWhere((t) => t.id == task.id);
    final taskToUpdate = await box.get(task.id);
    if (taskToUpdate != null) {
      final updatedTask = taskToUpdate.copyWith(
        title: task.title,
        description: task.description,
        time: task.time,
        color: task.color,
        id: task.id,
        date: task.date,
      );
      await box.put(task.id, updatedTask);
      tasks[index] = updatedTask;
      update();
    }
  }

  Future<void> scheduleNotifications() async {
    final box = await Hive.openBox('TODO');
    final tasks = box.values.map((e) => e as Task).toList();
    for (final task in tasks) {
      await scheduleNotification(task);
    }
  }

  Future<void> scheduleNotification(Task task) async {
    int now = DateTime.now() as int;
    print("now$now");
    final dueDateTime =
        DateTime.parse(task.date.toString() + " " + task.time.toString());
          print("now$dueDateTime");
    final notificationDateTime =
        dueDateTime.subtract(Duration(minutes: int.parse("${task.time}")));
          print("now$notificationDateTime");

    if (dueDateTime == null ||
        dueDateTime.isBefore(now as DateTime) ||
        notificationDateTime.isBefore(now as DateTime)) {
      // Task is overdue or has no due date/time, or notification time is already passed, don't schedule a notification
      return;
    }

    await Noti.showBigTextNotification(
      id: task.id,
      title: "${task.title}",
      body: "${task.description}",
      scheduledDate: notificationDateTime,
      fln: flutterLocalNotificationsPlugin,
    );
  }

  void cancelNotification(Task task) {
    // Cancel any scheduled notifications for the given task
    flutterLocalNotificationsPlugin.cancel(task.id.hashCode);
  }

  @override
  void onClose() async {
    final box = await Hive.openBox('TODO');
    box.close();
    super.onClose();
  }

  void logOut() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('token');

    // Navigate to the login page
    Get.offNamed('/login');
  }
}
