
import 'package:flutter/material.dart';
import 'package:flutter_apps/data/models/task_model.dart';

class TaskProvider extends ChangeNotifier {
  /// PRIVATE TASK LIST
  final List<TaskModel> _tasks = [];

  /// GETTER
  List<TaskModel> get tasks => _tasks;

  /// ADD TASK
  void addTask(TaskModel task) {
    _tasks.add(task);

    notifyListeners();
  }

  /// DELETE TASK
  void deleteTask(String id) {
    _tasks.removeWhere((task) => task.id == id);

    notifyListeners();
  }

  /// TOGGLE COMPLETE
  void toggleTask(String id) {
    final index = _tasks.indexWhere((task) => task.id == id);

    if (index == -1) return;

    _tasks[index].isDone = !_tasks[index].isDone;

    notifyListeners();
  }

  /// UPDATE TASK
  void updateTask({required String id, required String title}) {
    final index = _tasks.indexWhere((task) => task.id == id);

    if (index == -1) return;

    _tasks[index] = _tasks[index].copyWith(title: title);

    notifyListeners();
  }

  /// CLEAR ALL
  void clearTasks() {
    _tasks.clear();

    notifyListeners();
  }

  /// COMPLETED TASKS COUNT
  int get completedCount => _tasks.where((t) => t.isDone).length;

  /// PENDING TASKS COUNT
  int get pendingCount => _tasks.where((t) => !t.isDone).length;
}
