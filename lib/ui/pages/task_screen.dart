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
    Utlis.showSnackbar(context, "Deleted task successful");
    //TODO implement delete to firestore
  }

  _toggleComplete(BuildContext context) {
    final provider = Provider.of<TaskProvider>(context, listen: false);
    provider.isCompleted(task);
    Utlis.showSnackbar(context, "Updated task successful");
    //TODO implement toggle complete to firestore
  }

  void _view(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TaskPage(task: task)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: DismissDirection.endToStart,
      confirmDismiss: (DismissDirection direction) async {
        if (direction == DismissDirection.endToStart) {
          _delete(context);
          return true;
        } else {
          return null;
        }
      },
      background: Container(
        color: Colors.red,
        child: Align(
          alignment: Alignment.centerRight,
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "REMOVE".toUpperCase(),
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.right,
              )),
        ),
      ),
      key: UniqueKey(),
      child: ListTile(
        leading: IconButton(
          icon: Icon(
            task.isCompleted ? Icons.check_box : Icons.check_box_outline_blank,
          ),
          onPressed: () => _toggleComplete(context),
        ),
        title: Text(task.title),
        subtitle: Text(task.description),
        // trailing: IconButton(
        //   icon: Icon(
        //     Icons.delete,
        //   ),
        //   onPressed: _delete,
        // ),
        onTap: () => _view(context),
      ),
    );
  }
}
