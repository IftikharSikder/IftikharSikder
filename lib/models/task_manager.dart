import 'package:hive_ce/hive.dart';

part 'task_manager.g.dart';

@HiveType(typeId: 0)
class TaskManager extends HiveObject {
  @HiveField(0)
  final String title;
  @HiveField(1)
  final String description;
  TaskManager({required this.title, required this.description});
}
