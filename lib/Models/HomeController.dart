import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'TaskModel.dart';

class TaskController extends GetxController {
  late Box<Task> _taskBox;

  final RxList<Task> tasks = <Task>[].obs;

  @override
  void onInit() async {
    super.onInit();
    await Hive.openBox<Task>('TODO');
    _taskBox = await Hive.box<Task>('TODO');
    tasks.assignAll(_taskBox.values.toList());
    ever(tasks, (_) {
      _taskBox.putAll(Map.fromIterable(
        tasks,
        key: (task) => task.hashCode,
        value: (task) => task,
      ));
    });
  }

  void addTask(Task task) {
    tasks.add(task);
  }

  void deleteTask(int index) async {
    tasks.removeAt(index);
    await _taskBox.delete(index); 
    update();
  }

  @override
  void onClose() {
    _taskBox.close();
    super.onClose();
  }

  void logOut() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('token');

    // Navigate to the login page
    Get.offNamed('/login');
  }
}
