// ignore_for_file: unnecessary_null_comparison

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import '../notification/NotificationService.dart';
import 'TaskModel.dart';
import 'package:uuid/uuid.dart';

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
   _sortTasksByDateDesc();
    notificationTimer = Timer.periodic(Duration(seconds:20), (timer) {
  
      scheduleNotifications();
    });
  }

 void addTask(Task task) async {
  final box = await Hive.openBox('TODO');
  String id = Uuid().v4();
  final newTask = task.copyWith(id: id); 
  await box.put(id, newTask);
  tasks.add(newTask); 
  _sortTasksByDateDesc(); 
  pushNotification(newTask);
}

  void deleteTask(Task task, int index) async {
    final box = await Hive.openBox('TODO');
    final taskToDelete = tasks.firstWhere((t) => t.id == task.id);
    if (taskToDelete.id.length > 0) {
    
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
      await box.put(task.id, updatedTask); 
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
      Get.defaultDialog(
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

            Text("${task.title}",style: GoogleFonts.cairo(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 28,
                  ),),
                  SizedBox(height: 15,),
                  Image.asset("assets/logo.png",
                  height: 50,
                  width: 50,
                  ),
                   SizedBox(height: 15,),
                     Text("${task.description}",style: GoogleFonts.cairo(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),),

          ]),
          backgroundColor: Color(0xfffff2e4),
          titleStyle: TextStyle(color: Colors.black),
          middleTextStyle: TextStyle(color: Colors.black),
          radius: 30);
    }
  }
  void _sortTasksByDateDesc() {
  tasks.sort((a, b) {
    return b.date!.compareTo(a.date!);
  });
}
 void sortTasksByDateDesc() {
    tasks.sort((a, b) => b.date!.compareTo(a.date!));
  }
  void cancelNotification(Task task) {
  
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

   
    Get.offNamed('/login');
  }
}
