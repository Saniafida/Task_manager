// lib/widgets/project_card.dart

import 'package:flutter/material.dart';
import 'package:task_manager/models/project_model.dart';
import 'package:task_manager/core/theme/app_colors.dart';

class ProjectCard extends StatelessWidget {
  final ProjectModel project;
  final VoidCallback onDelete;

  const ProjectCard({
    super.key,
    required this.project,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(project.name),
        subtitle: Text(project.description),
        trailing: IconButton(icon: const Icon(Icons.delete, color: AppColors.error), onPressed: onDelete),
      ),
    );
  }
}