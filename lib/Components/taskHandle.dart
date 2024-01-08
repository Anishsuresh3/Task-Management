import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter/material.dart';

class TaskHandler extends StatefulWidget {
  const TaskHandler({Key? key}) : super(key: key);

  @override
  State<TaskHandler> createState() => _TaskHandlerState();
}

class _TaskHandlerState extends State<TaskHandler> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ContainedTabBarView(
        initialIndex: 0,
        tabBarProperties: const TabBarProperties(
          indicatorColor: Colors.purple,
          indicatorWeight: 3.5,
          indicatorSize: TabBarIndicatorSize.label,
        ),
        tabs: const [
          Text('Task',
            style: TextStyle(
              fontSize: 18),
          ),
          Text('Completed',
              style: TextStyle(
              fontSize: 18),
          ),
        ],
        views: [
          _buildTasksList(),
          _buildCompletedTasksList()
        ],
        // onChange: (index) => print(index),
      ),
    );
  }
  Widget _buildTasksList() {
    return ListView.builder(
      itemCount: 20,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('Task $index'),
        );
      },
    );
  }

  Widget _buildCompletedTasksList() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('Completed Task $index'),
        );
      },
    );
  }
}
