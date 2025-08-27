import 'package:hive/hive.dart';

part 'project.g.dart';

@HiveType(typeId: 0)
class Project {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  Project({required this.id, required this.title});
}