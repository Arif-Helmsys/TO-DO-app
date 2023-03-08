import 'package:hive/hive.dart';
import 'package:to_do_app/models/task_model.dart';

abstract class LocalStorage {
  Future<void> addTask({required Task task});
  Future<Task?> getTask({required String id});
  Future<List<Task>> getAllTask();
  Future<bool> deleteTask({required Task task});
  Future<Task> updateTask({required Task task});
}

class HiveLocalStorage implements LocalStorage {
  late Box<Task> taskBox;

  HiveLocalStorage() {
    taskBox = Hive.box<Task>('tasks');
  }

  @override
  Future<void> addTask({required Task task}) async {
    await taskBox.put(task.id, task);
  }

  @override
  Future<bool> deleteTask({required Task task}) async {
    await task.delete();
    return true;
  }

  @override
  Future<List<Task>> getAllTask() async {
    List<Task> allTask = <Task>[];
    allTask = taskBox.values.toList();
    if (allTask.isNotEmpty) {
      allTask.sort((Task a, Task b) => a.createdAt.compareTo(a.createdAt));
    }
    return allTask;
  }

  @override
  Future<Task?> getTask({required String id}) async {
    if (taskBox.containsKey(id)) {
      return taskBox.get(id);
    } else {
      return null;
    }
  }

  @override
  Future<Task> updateTask({required Task task}) async {
    await task.save();
    return task;
  }
}
