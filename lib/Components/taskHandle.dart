import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:taskm/widgets/Statistics.dart';
import 'package:taskm/widgets/completedTaskTile.dart';
import 'package:taskm/widgets/taskTile.dart';
import '../Models/provider/tasks_provider.dart';

class TaskHandler extends StatefulHookConsumerWidget {
  const TaskHandler({Key? key}) : super(key: key);

  @override
  ConsumerState<TaskHandler> createState() => _TaskHandlerState();
}

class _TaskHandlerState extends ConsumerState<TaskHandler> with TickerProviderStateMixin{

  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2,vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final noTasks = ref.watch(getNumberOfTasks);
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: Size(330,120),
          child: Column(
            children: [
              Statistics(
                  createdTasks: noTasks[0],
                  completedTasks: noTasks[1],
                  precent: noTasks[2]
              ),
              TabBar(
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
            ],
          ),
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
