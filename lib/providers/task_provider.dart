// lib/providers/task_provider.dart

import 'package:flutter/material.dart';
import 'package:task_manager/models/task_model.dart';
import 'package:task_manager/services/task_service.dart';

class TaskProvider extends ChangeNotifier {
  final TaskService _taskService = TaskService();
  List<TaskModel> _tasks = [];

  List<TaskModel> get tasks => _tasks;

  Future<void> fetchTasks() async {
    _tasks = await _taskService.getTasks();
    notifyListeners();
  }

  Future<void> addTask(TaskModel task) async {
    final newTask = await _taskService.addTask(task);
    _tasks.add(newTask);
    notifyListeners();
  }

  Future<void> updateTask(TaskModel task) async {
    final updatedTask = await _taskService.updateTask(task);
    final index = _tasks.indexWhere((t) => t.id == updatedTask.id);
    if (index != -1) {
      _tasks[index] = updatedTask;
      notifyListeners();
    }
  }

  Future<void> deleteTask(String id) async {
    await _taskService.deleteTask(id);
    _tasks.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  // Toggle task completion status
  Future<void> toggleTaskCompletion(String taskId) async {
    try {
      // Find the task index
      final taskIndex = _tasks.indexWhere((task) => task.id == taskId);
      if (taskIndex == -1) return;

      // Get the task and toggle its completion status
      final task = _tasks[taskIndex];
      final updatedTask = TaskModel(
        id: task.id,
        title: task.title,
        description: task.description,
        dueDate: task.dueDate,
        isCompleted: !task.isCompleted, // Toggle completion
        projectId: task.projectId,
      );

      // Update in the service/database
      await _taskService.updateTask(updatedTask);

      // Update in local list
      _tasks[taskIndex] = updatedTask;
      notifyListeners();
    } catch (e) {
      print('Error toggling task completion: $e');
      // Optionally show error to user
      rethrow;
    }
  }
}