import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:hive/hive.dart';
import 'TaskModel.dart';

class TaskController extends GetxController {
  late Box<Task> _taskBox;

  final RxList<Task> tasks = <Task>[].obs;

  @override
  void onInit() {
    super.onInit();
      Hive.openBox<Task>('TODO');
    _taskBox = Hive.box<Task>('TODO');
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

  void removeTask(Task task) {
    tasks.remove(task);
  }

  @override
  void onClose() {
    _taskBox.close();
    super.onClose();
  }
}
