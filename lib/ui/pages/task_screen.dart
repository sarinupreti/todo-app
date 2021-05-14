import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:withu_todo/non_ui/jsonclasses/task.dart';
import 'package:withu_todo/non_ui/provider/tasks.dart';
import 'package:withu_todo/non_ui/utils.dart';
import 'package:withu_todo/ui/pages/task.dart';

class TaskScreen extends StatelessWidget {
  TaskScreen({@required this.title, @required this.tasks});

  final String title;
  final List<Task> tasks;

  void addTask(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TaskPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => addTask(context),
          )
        ],
      ),
      body: tasks.isEmpty
          ? Center(
              child: Text('Add your first task'),
            )
          : ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return _Task(
                  tasks[index],
                );
              },
            ),
    );
  }
}

class _Task extends StatelessWidget {
  _Task(this.task);

  final Task task;

  void _delete(BuildContext context) {
    final provider = Provider.of<TaskProvider>(context, listen: false);
    provider.deleteATask(task);
  }

  _toggleComplete(BuildContext context) {
    final provider = Provider.of<TaskProvider>(context, listen: false);
    provider.isCompleted(task);
    // Utlis.showSnackbar(context, "Updated task successful");
  }

  void _view(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TaskPage(task: task)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: IconButton(
        icon: Icon(
          task.isCompleted ? Icons.check_box : Icons.check_box_outline_blank,
        ),
        onPressed: () => _toggleComplete(context),
      ),
      title: Text(
        task.title,
        style: Theme.of(context).textTheme.headline6,
      ),
      subtitle: Text(
        task.description,
        style: Theme.of(context).textTheme.bodyText1,
      ),
      trailing: IconButton(
        icon: Icon(
          Icons.delete,
        ),
        onPressed: () => _delete(context),
      ),
      onTap: () => _view(context),
    );
  }
}
