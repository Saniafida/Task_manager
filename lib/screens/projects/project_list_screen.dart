// lib/screens/projects/project_list_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/providers/project_provider.dart';
import 'package:task_manager/widgets/project_card.dart';
import 'package:task_manager/core/routes/app_routes.dart';

class ProjectListScreen extends StatelessWidget {
  const ProjectListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final projectProvider = Provider.of<ProjectProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Projects')),
      body: ListView.builder(
        itemCount: projectProvider.projects.length,
        itemBuilder: (context, index) {
          return ProjectCard(
            project: projectProvider.projects[index],
            onDelete: () => projectProvider.deleteProject(projectProvider.projects[index].id),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.addProject),
        child: const Icon(Icons.add),
      ),
    );
  }
}