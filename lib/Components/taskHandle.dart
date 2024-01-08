import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter/material.dart';

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
    _tabController = TabController(length: 3,vsync: this);
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
