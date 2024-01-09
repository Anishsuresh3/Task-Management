import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:taskm/widgets/completedTaskTile.dart';
import 'package:taskm/widgets/taskTile.dart';

import '../Models/task.dart';

class TaskHandler extends StatefulWidget {
  const TaskHandler({Key? key}) : super(key: key);

  @override
  State<TaskHandler> createState() => _TaskHandlerState();
}

class _TaskHandlerState extends State<TaskHandler> with TickerProviderStateMixin{

  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    // initialize();
    _tabController = TabController(length: 2,vsync: this);
  }

  void initialize() async {
    await Hive.openBox<Task>('tasksBox');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: TabBar(
          controller: _tabController,
          overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
          tabs: const <Widget>[
            Tab(
              text: 'Task',
            ),
            Tab(
              text: 'Completed',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          _buildTasksList(),
          _buildCompletedTasksList()
        ],
      ),
    );
  }
  Widget _buildTasksList() {
    return TaskTile();
  }

  Widget _buildCompletedTasksList() {
    return CompletedTaskTile();
  }
}
