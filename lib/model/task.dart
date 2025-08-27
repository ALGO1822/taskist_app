import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 1)
class Task {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String projectId;

  @HiveField(2)
  final String title;

  @HiveField(3)
  final String description;

  @HiveField(4)
  final bool isCompleted;

  @HiveField(5)
  final String priority;

  @HiveField(6)
  final String dueDate;

  Task({
    required this.id,
    required this.projectId,
    required this.title,
    this.description = '',
    this.isCompleted = false,
    this.priority = 'Medium',
    this.dueDate = 'Today',
  });
}