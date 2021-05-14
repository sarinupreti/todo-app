import 'package:flutter/material.dart';
import 'package:withu_todo/non_ui/jsonclasses/task.dart';

class TaskProvider extends ChangeNotifier {
  List<Task> _tasks = [];

//getter method for all tasks
  List<Task> get tasks =>
      _tasks.where((element) => element.isCompleted == false).toList();

  //getter method for completed tasks
  List<Task> get completedTasks =>
      _tasks.where((element) => element.isCompleted == true).toList();

  //add a task
  void addATask(Task task) {
    _tasks.add(task);

    notifyListeners();
  }

  //delete a task

  void deleteATask(Task task) {
    _tasks.remove(task);

    notifyListeners();
  }

  void isCompleted(Task task) {
    task.toggleComplete();

    notifyListeners();
  }

  //update task

  void updateTask(Task task, String title, String description) {
    task.title = title;
    task.description = description;
    notifyListeners();
  }
}
