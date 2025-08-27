// /providers/task_provider.dart

import 'package:flutter/material.dart';
import 'package:taskist_app/model/task.dart';
import 'package:taskist_app/services/hive_service.dart';
import 'package:taskist_app/services/auth_service.dart';

class TaskProvider extends ChangeNotifier {
  HiveService? _hiveService;
  List<Task> _tasks = [];
  bool _isLoading = true;

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;

  TaskProvider(String projectId) {
    _init(projectId);
  }

  Future<void> _init(String projectId) async {
    try {
      // ✅ Get user FIRST
      final email = await AuthService().getLoggedInUser();
      if (email == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }

      // ✅ Now create HiveService with userId
      _hiveService = HiveService(email);
      await _hiveService!.init();

      _loadTasks(projectId);
    } catch (e) {
      print('Error in TaskProvider init: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadTasks(String projectId) async {
    if (_hiveService == null) return;

    _isLoading = true;
    notifyListeners();

    _tasks = _hiveService!.getTasksByProject(projectId);

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addTask({
    required String projectId,
    required String title,
    String description = '',
    String priority = 'Medium',
    String dueDate = 'Today',
  }) async {
    if (_hiveService == null) return;

    final newTask = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      projectId: projectId,
      title: title,
      description: description,
      priority: priority,
      dueDate: dueDate,
    );

    await _hiveService!.addTask(newTask);
    _loadTasks(projectId);
  }

  Future<void> toggleCompletion(String taskId, String projectId) async {
    if (_hiveService == null) return;
    await _hiveService!.toggleTaskCompletion(taskId);
    _loadTasks(projectId);
  }

  Future<void> deleteTask(String taskId, String projectId) async {
    if (_hiveService == null) return;
    await _hiveService!.deleteTask(taskId);
    _loadTasks(projectId);
  }

  Future<void> editTask({
    required String taskId,
    required String newTitle,
    required String newDescription,
    required String projectId,
  }) async {
    if (_hiveService == null || newTitle.isEmpty) return;
    final task = _hiveService!.getTask(taskId);
    if (task != null) {
      final updated = Task(
        id: task.id,
        projectId: task.projectId,
        title: newTitle,
        description: newDescription,
        isCompleted: task.isCompleted,
        priority: task.priority,
        dueDate: task.dueDate,
      );
      await _hiveService!.updateTask(updated);
      _loadTasks(projectId);
    }
  }
}