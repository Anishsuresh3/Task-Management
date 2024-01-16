import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:taskm/Models/provider/tasks_provider.dart';

import '../widgets/calendarTasks.dart';

class Calendar extends StatefulHookConsumerWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  ConsumerState<Calendar> createState() => _CalendarState();
}

class _CalendarState extends ConsumerState<Calendar> {

  DateTime selectedDay = DateTime.now();
  DateTime firstDay = DateTime.now().add(const Duration(days: -1000));
  DateTime lastDay = DateTime.now().add(const Duration(days: 1000));
  CalendarFormat calendarFormat = CalendarFormat.week;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TableCalendar(
            focusedDay: selectedDay,
            firstDay: firstDay,
            lastDay: lastDay,
            startingDayOfWeek: StartingDayOfWeek.monday,
            availableCalendarFormats: const {
              CalendarFormat.month: 'Month',
              CalendarFormat.twoWeeks: '2 Week',
              CalendarFormat.week: 'Week'
            },
            selectedDayPredicate: (day) {
              return isSameDay(selectedDay, day);
            },
            onDaySelected: (selected, focused) {
              ref.read(calendarProvider.notifier).state = selected;
              setState(() {
                selectedDay = selected;
              });
            },
            onPageChanged: (focused) {
              setState(() {
                selectedDay = focused;
              });
            },
            calendarFormat: calendarFormat,
            onFormatChanged: (format) {
              setState(
                    () {
                  calendarFormat = format;
                },
              );
            },
          ),
          Expanded(
              child: CalendarTasks()
          )
        ],
      ),
    );
  }
}
