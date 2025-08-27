import 'package:hive/hive.dart';
import 'package:taskist_app/model/project.dart';
import 'package:taskist_app/model/task.dart';


class HiveService {
  late Box<Project> _projectsBox;
  late Box<Task> _tasksBox;
  final String userId;

  HiveService(this.userId);

  Future<void> init() async {
    _projectsBox = await Hive.openBox<Project>('projects_$userId');
    _tasksBox = await Hive.openBox<Task>('tasks_$userId');
  }

  // === PROJECT CRUD ===
  Future<void> addProject(Project project) async {
    await _projectsBox.put(project.id, project);
  }

  List<Project> getAllProjects() {
    return _projectsBox.values.toList();
  }

  Project? getProject(String id) {
    return _projectsBox.get(id);
  }

  Future<void> updateProject(Project project) async {
    await _projectsBox.put(project.id, project);
  }

  Future<void> deleteProject(String id) async {
    final project = _projectsBox.get(id);
    if (project != null) {
      await _projectsBox.delete(id);
      final tasksToDelete = _tasksBox.values
          .where((task) => task.projectId == id)
          .toList();
      for (var task in tasksToDelete) {
        await _tasksBox.delete(task.id);
      }
    }
  }

  // === TASK CRUD ===
  Future<void> addTask(Task task) async {
    await _tasksBox.put(task.id, task);
  }

  List<Task> getTasksByProject(String projectId) {
    return _tasksBox.values
        .where((task) => task.projectId == projectId)
        .toList();
  }

  Task? getTask(String id) {
    return _tasksBox.get(id);
  }

  Future<void> updateTask(Task task) async {
    await _tasksBox.put(task.id, task);
  }

  Future<void> deleteTask(String id) async {
    await _tasksBox.delete(id);
  }

  Future<void> toggleTaskCompletion(String taskId) async {
    final task = _tasksBox.get(taskId);
    if (task != null) {
      final updated = Task(
        id: task.id,
        projectId: task.projectId,
        title: task.title,
        description: task.description,
        isCompleted: !task.isCompleted,
        priority: task.priority,
        dueDate: task.dueDate,
      );
      await _tasksBox.put(taskId, updated);
    }
  }
}