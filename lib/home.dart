import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:taskm/Components/AllTasks.dart';
import 'package:taskm/Components/TaskView.dart';
import 'package:taskm/Components/calendar.dart';
import 'package:taskm/Components/taskHandle.dart';

class HomePage extends StatefulHookConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {

  final pages = const [
    TaskHandler(),
    AllTasks(),
    Calendar()
  ];

  int tapIndex=0;

  void changeTabIndex(int index) {
    setState(() {
      tapIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
              "Tasks",
            style: TextStyle(
              fontFamily: 'UbuntuB',
              fontSize: 30
            ),
          ),
        ),
      ),
      body: IndexedStack(
        index: tapIndex,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) => changeTabIndex(index),
        selectedIndex: tapIndex,
        destinations: const [
          NavigationDestination(
            icon: Icon(Iconsax.folder_2),
            selectedIcon: Icon(Iconsax.folder_25),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Iconsax.task_square),
            selectedIcon: Icon(Iconsax.task_square5),
            label: 'All Tasks',
          ),
          NavigationDestination(
            icon: Icon(Iconsax.calendar_1),
            selectedIcon: Icon(Iconsax.calendar5),
            label: 'calendar',
          ),
        ],
      ),
      floatingActionButton: tapIndex > 0 ? null
          : FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NewTask()),
          );
        },
        child: const Icon(Iconsax.add),
      ),
    );
  }
}
