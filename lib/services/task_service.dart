// lib/services/task_service.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:task_manager/core/constants/app_constants.dart';
import 'package:task_manager/models/task_model.dart';

class TaskService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<TaskModel>> getTasks() async {
    final response = await _client.from(AppConstants.supabaseTableTasks).select();
    return response.map((json) => TaskModel.fromJson(json)).toList();
  }

  Future<TaskModel> addTask(TaskModel task) async {
    final response = await _client.from(AppConstants.supabaseTableTasks).insert(task.toJson()).select().single();
    return TaskModel.fromJson(response);
  }

  Future<TaskModel> updateTask(TaskModel task) async {
    final response = await _client
        .from(AppConstants.supabaseTableTasks)
        .update(task.toJson())
        .eq('id', task.id)
        .select()
        .single();
    return TaskModel.fromJson(response);
  }

  Future<void> deleteTask(String id) async {
    await _client.from(AppConstants.supabaseTableTasks).delete().eq('id', id);
  }
}