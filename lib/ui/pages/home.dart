import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:withu_todo/non_ui/provider/tasks.dart';
import 'package:withu_todo/ui/pages/task_screen.dart';

class HomeTabsPage extends StatefulWidget {
  @override
  _HomeTabsPageState createState() => _HomeTabsPageState();
}

class _HomeTabsPageState extends State<HomeTabsPage> {
  int _currentIndex = 0;

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskProvider>(context);

    final data = provider.tasks;
    final completedData = provider.completedTasks;

    List<Widget> children = [
      TaskScreen(
          title: 'All Tasks',
          // tasks: FirebaseManager.shared.tasks
          tasks: data),
      TaskScreen(
        title: 'Completed Tasks',
        // tasks:
        // FirebaseManager.shared.tasks.where((t) => t.isCompleted).toList(),
        tasks: completedData,
      )
    ];

    return Scaffold(
      body: children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'All Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check),
            label: 'Completed Tasks',
          ),
        ],
      ),
    );
  }
}
