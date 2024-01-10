
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskm/Models/TaskHive.dart';
import 'package:taskm/Models/data/task.dart';

final hiveData = StateNotifierProvider<TaskHive, List<Task?>?>((ref) => TaskHive(ref));