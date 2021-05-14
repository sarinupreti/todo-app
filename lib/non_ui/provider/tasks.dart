import 'package:flutter/material.dart';
import 'package:withu_todo/non_ui/jsonclasses/task.dart';
import 'package:withu_todo/non_ui/repository/firebase_manager.dart';

class TaskProvider extends ChangeNotifier {
  List<Task> _tasks = [];

//getter method for all tasks
  List<Task> get tasks => _tasks != null
      ? _tasks.where((element) => !element.isCompleted).toList()
      : [];

  //getter method for completed tasks
  List<Task> get completedTasks => _tasks != null
      ? _tasks.where((element) => element.isCompleted).toList()
      : [];

  void setTasks(List<Task> tasks) {
    if (tasks != null)
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _tasks = tasks;
        notifyListeners();
      });
  }

  //add a task
  void addATask(Task task) {
    FirebaseManager.shared.createTask(task);
  }

  //delete a task

  void deleteATask(Task task) {
    FirebaseManager.shared.deleteTask(task);
  }

  bool isCompleted(Task task) {
    task.toggleComplete();
    FirebaseManager.shared.updateTask(task);

    return task.isCompleted;
  }

  //update task
  void updateTask(Task task, String title, String description) {
    task.title = title;
    task.description = description;

    FirebaseManager.shared.updateTask(task);
  }
}
