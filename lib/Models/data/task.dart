import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 1)
class Task extends HiveObject{

  @HiveField(0)
  late String title;

  @HiveField(1)
  late String? description;

  @HiveField(2)
  late bool isCompleted;

  @HiveField(3)
  late DateTime deadline;

  @HiveField(4)
  late int priority;

  @HiveField(5)
  late List<String>? tags;

  @HiveField(6)
  List<String?>? filePath;

  Task({
    required this.title,
    required this.description,
    this.isCompleted = true,
    required this.deadline,
    this.priority = 3,
    required this.tags,
    required this.filePath
  });

  Task copyWith({
    required String title,
    String? description,
    required bool isCompleted,
    required DateTime deadline,
    required int priority,
    List<String>? tags,
    List<String?>? filePath
  }) {
    return Task(
        title: title,
        description: description,
        isCompleted: isCompleted,
        deadline: deadline,
        priority: priority,
        tags: tags,
        filePath: filePath
    );
  }
}