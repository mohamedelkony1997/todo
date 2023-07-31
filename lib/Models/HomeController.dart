import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'TaskModel.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
Future<void> initializeNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: IOSInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      ));
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // Request permission for local notifications on Android
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.requestPermission();

  // Request permission for local notifications on iOS
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
}

class TaskController extends GetxController {
  final tasks = <Task>[].obs;
  @override
  void onInit() async {
    super.onInit();
    final box = await Hive.openBox('TODO');
    tasks.assignAll(box.values.map((e) => e as Task).toList());
    initializeNotifications();
    // Schedule notifications for all tasks when the app starts
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

  void scheduleNotifications() {
    for (final task in tasks) {
      scheduleNotification(task);
    }
  }

  void scheduleNotification(Task task) {
    final now = DateTime.now();
    final dueDate = DateTime.parse(task.date.toString());
    ;

    if (dueDate == null || dueDate.isBefore(now)) {
      // Task is overdue or has no due date, don't schedule a notification
      return;
    }

    final androidDetails = AndroidNotificationDetails(
      'channel_id',
      'channel_name',
    );

    final platformDetails = NotificationDetails(
      android: androidDetails,
    );
    final scheduledDate = tz.TZDateTime.from(dueDate, tz.local);

    flutterLocalNotificationsPlugin.zonedSchedule(
      task.id.hashCode,
      'Task Reminder',
      'You have a task to do: ${task.title}',
      scheduledDate,
      platformDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
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
