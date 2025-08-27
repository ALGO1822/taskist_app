import 'package:flutter/material.dart';
import 'package:taskist_app/model/project.dart';
import 'package:taskist_app/services/hive_service.dart';
import 'package:taskist_app/services/auth_service.dart';

class ProjectProvider extends ChangeNotifier {
  HiveService? _hiveService;
  List<Project> _projects = [];
  bool _isLoading = true;

  List<Project> get projects => _projects;
  bool get isLoading => _isLoading;

  ProjectProvider() {
    _init();
  }

  Future<void> _init() async {
    final authService = AuthService();
    final email = await authService.getLoggedInUser();
    if (email != null) {
      _hiveService = HiveService(email);
      await _hiveService!.init(); // ✅ Await init
      _loadProjects();
    }
  }

  Future<void> _loadProjects() async {
    if (_hiveService == null) return;

    _isLoading = true;
    notifyListeners();

    _projects = _hiveService!.getAllProjects();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addProject(String title) async {
    if (title.isEmpty || _hiveService == null) return;

    final newProject = Project(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
    );

    await _hiveService!.addProject(newProject);
    _loadProjects();
  }

  Future<void> deleteProject(String id) async {
    if (_hiveService == null) return;
    await _hiveService!.deleteProject(id);
    _loadProjects();
  }

  Future<void> renameProject(String id, String newTitle) async {
    if (_hiveService == null || newTitle.isEmpty) return;
    final project = _hiveService!.getProject(id);
    if (project != null) {
      final updated = Project(id: project.id, title: newTitle);
      await _hiveService!.updateProject(updated);
      _loadProjects();
    }
  }
}