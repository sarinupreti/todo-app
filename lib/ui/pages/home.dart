import 'package:flutter/material.dart';
import 'package:withu_todo/non_ui/firebase_manager.dart';
import 'package:withu_todo/ui/pages/tasks.dart';

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
    List<Widget> children = [
      TasksPage(
        title: 'All Tasks',
        tasks: FirebaseManager.shared.tasks,
      ),
      TasksPage(
        title: 'Completed Tasks',
        tasks:
            FirebaseManager.shared.tasks.where((t) => t.isCompleted).toList(),
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
