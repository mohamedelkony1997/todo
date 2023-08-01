import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import '../notification/NotificationService.dart';
import 'TaskModel.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class TaskController extends GetxController {
  Timer? notificationTimer;
  final tasks = <Task>[].obs;
  @override
  void onInit() async {
    super.onInit();

    final box = await Hive.openBox('TODO');
    tasks.assignAll(box.values.map((e) => e as Task).toList());
    startContinuousExecution();
  }

  void startContinuousExecution() {
    // Start a timer that executes pushNotification every second
    notificationTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      // Execute your function here
      scheduleNotifications();
    });
  }

  void addTask(Task task) async {
    final box = await Hive.openBox('TODO');
    String id = Uuid().v4();
    await box.put(id, task);
    tasks.add(task.copyWith(id: id));
    pushNotification(task.copyWith(id: id));
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
    final taskToUpdate = tasks.firstWhere((t) => t.id == task.id);
    if (taskToUpdate != null) {
      final updatedTask = taskToUpdate.copyWith(
        title: task.title,
        description: task.description,
        time: task.time,
        color: task.color,
        id: task.id,
        date: task.date,
      );
      await box.put(task, updatedTask);
      tasks[index] = updatedTask;
      update();
    }
  }

  Future<void> scheduleNotifications() async {
    final box = await Hive.openBox('TODO');
    final tasks = box.values.map((e) => e as Task).toList();
    for (final task in tasks) {
      await pushNotification(task);
    }
  }

  Future<void> pushNotification(Task task) async {
    final scheduledDate =
        DateFormat('MM-dd-yyyy hh:mm a').parse('${task.date} ${task.time}');
    var now = DateTime.now();
    final currentDate = DateTime(
      now.year,
      now.month,
      now.day,
      now.hour,
      now.minute,
      0,
    );
   
    if (currentDate.isAtSameMomentAs(scheduledDate)) {
      await Noti.showBigTextNotification(
        id: task.id,
        title: "${task.title}",
        body: "${task.description}",
        scheduledDate: scheduledDate,
        fln: flutterLocalNotificationsPlugin,
      );
    }
  }

  void cancelNotification(Task task) {
    // Cancel any scheduled notifications for the given task
    flutterLocalNotificationsPlugin.cancel(task.id.hashCode);
  }

  @override
  void onClose() async {
    final box = await Hive.openBox('TODO');
    box.close();
    notificationTimer?.cancel();
    super.onClose();
  }

  void logOut() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('token');

    // Navigate to the login page
    Get.offNamed('/login');
  }
}
