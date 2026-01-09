// lib/providers/project_provider.dart

import 'package:flutter/material.dart';
import 'package:task_manager/models/project_model.dart';
import 'package:task_manager/services/project_service.dart';

class ProjectProvider extends ChangeNotifier {
  final ProjectService _projectService = ProjectService();
  List<ProjectModel> _projects = [];

  List<ProjectModel> get projects => _projects;

  Future<void> fetchProjects() async {
    _projects = await _projectService.getProjects();
    notifyListeners();
  }

  Future<void> addProject(ProjectModel project) async {
    final newProject = await _projectService.addProject(project);
    _projects.add(newProject);
    notifyListeners();
  }

  Future<void> updateProject(ProjectModel project) async {
    final updatedProject = await _projectService.updateProject(project);
    final index = _projects.indexWhere((p) => p.id == updatedProject.id);
    if (index != -1) {
      _projects[index] = updatedProject;
      notifyListeners();
    }
  }

  Future<void> deleteProject(String id) async {
    await _projectService.deleteProject(id);
    _projects.removeWhere((p) => p.id == id);
    notifyListeners();
  }
}