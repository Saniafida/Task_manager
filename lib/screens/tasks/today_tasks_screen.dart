// lib/screens/tasks/today_tasks_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/providers/task_provider.dart';
import 'package:task_manager/widgets/task_card.dart';
import 'package:task_manager/core/routes/app_routes.dart';
import 'package:task_manager/utils/date_utils.dart';

class TodayTasksScreen extends StatelessWidget {
  const TodayTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final todayTasks = taskProvider.tasks.where((task) => isToday(task.dueDate)).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Today\'s Tasks')),
      body: ListView.builder(
        itemCount: todayTasks.length,
        itemBuilder: (context, index) {
          return TaskCard(
            task: todayTasks[index],
            onEdit: () => Navigator.pushNamed(context, AppRoutes.editTask, arguments: {'taskId': todayTasks[index].id}),
            onDelete: () => taskProvider.deleteTask(todayTasks[index].id),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.addTask),
        child: const Icon(Icons.add),
      ),
    );
  }
}