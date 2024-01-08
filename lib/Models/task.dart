import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject{

  @HiveField(0)
  late String title;

  @HiveField(1)
  late String description;

  @HiveField(2)
  late bool isCompleted;

  @HiveField(3)
  late DateTime deadline;

  @HiveField(4)
  late int priority;

  @HiveField(5)
  late List<String> tags;

  @HiveField(6)
  List<String?> filePath;

  Task({
    required this.title,
    required this.description,
    this.isCompleted = false,
    required this.deadline,
    required this.priority,
    required this.tags,
    required this.filePath
  });
}