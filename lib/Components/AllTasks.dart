import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:taskm/Models/FilertsAndSort.dart';

import '../Models/provider/tasks_provider.dart';
import '../widgets/AllTasksTile.dart';

class AllTasks extends StatefulHookConsumerWidget {
  const AllTasks({Key? key}) : super(key: key);

  @override
  ConsumerState<AllTasks> createState() => _AllTasksState();
}


class _AllTasksState extends ConsumerState<AllTasks> {
  TextEditingController _controllerSearch = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Filters? selectedfilter;
    return Scaffold(
      appBar: AppBar(
        actions: [
        Expanded(
          child: Card(
          margin: const EdgeInsets.symmetric(
              horizontal: 10, vertical: 5),
          child: TextFormField(
            controller: _controllerSearch,
            keyboardType: TextInputType.text,
            onChanged: (e) {
              ref.read(searchProvider.notifier).state = e;
            },
            decoration: InputDecoration(
              prefixIcon: const Icon(
                Iconsax.search_normal_1,
                size: 20,
              ),
              suffixIcon:_controllerSearch.text.isNotEmpty
                  ? IconButton(
                onPressed: () {
                  _controllerSearch.clear();
                  setState(() {
                    _controllerSearch.text = '';
                  });
                  },
                icon: const Icon(
                    Iconsax.close_circle,
                    color: Colors.grey,
                    size: 20,
                  ),
                  )
                  : null,
                  labelText: "Search Task",
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                ),
              ),
            ),
          ),
          MenuAnchor(
            builder:
                (BuildContext context, MenuController controller, Widget? child) {
              return IconButton(
                onPressed: () {
                  if (controller.isOpen) {
                    controller.close();
                  } else {
                    controller.open();
                  }
                },
                icon: const Icon(Icons.filter_alt_outlined),
                tooltip: 'Show menu',
              );
            },
            menuChildren: List<MenuItemButton>.generate(
              7,
                  (int index) => MenuItemButton(
                onPressed: () {
                  ref.read(filterProvider.notifier).state = Filters.values[index];
                },
                child: Text(Filters.values[index].name),
              ),
            ),
          ),
          MenuAnchor(
            builder:
                (BuildContext context, MenuController controller, Widget? child) {
              return IconButton(
                onPressed: () {
                  if (controller.isOpen) {
                    controller.close();
                  } else {
                    controller.open();
                  }
                },
                icon: const Icon(Icons.sort_rounded),
                tooltip: 'Show menu',
              );
            },
            menuChildren: List<MenuItemButton>.generate(
              7,
                  (int index) => MenuItemButton(
                onPressed: () {
                  ref.read(sortProvider.notifier).state = Sort.values[index];
                },
                child: Text(Sort.values[index].name),
              ),
            ),
          ),
        ],
      ),
      body: AllTaskTile()
    );
  }
}
