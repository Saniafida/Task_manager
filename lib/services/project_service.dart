// lib/services/project_service.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:task_manager/core/constants/app_constants.dart';
import 'package:task_manager/models/project_model.dart';

class ProjectService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<ProjectModel>> getProjects() async {
    final response = await _client.from(AppConstants.supabaseTableProjects).select();
    return response.map((json) => ProjectModel.fromJson(json)).toList();
  }

  Future<ProjectModel> addProject(ProjectModel project) async {
    final response = await _client.from(AppConstants.supabaseTableProjects).insert(project.toJson()).select().single();
    return ProjectModel.fromJson(response);
  }

  Future<ProjectModel> updateProject(ProjectModel project) async {
    final response = await _client
        .from(AppConstants.supabaseTableProjects)
        .update(project.toJson())
        .eq('id', project.id)
        .select()
        .single();
    return ProjectModel.fromJson(response);
  }

  Future<void> deleteProject(String id) async {
    await _client.from(AppConstants.supabaseTableProjects).delete().eq('id', id);
  }
}