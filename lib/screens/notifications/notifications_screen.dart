// lib/screens/notifications/notifications_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/providers/task_provider.dart';
import 'package:task_manager/core/theme/app_colors.dart';
import 'package:task_manager/utils/date_utils.dart'; // Agar nahi hai to bana lena (isToday, isOverdue etc.)

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Upcoming + Overdue tasks filter karo (example logic)
    final notifications = taskProvider.tasks.where((task) {
      return !task.isCompleted && (isToday(task.dueDate) || task.dueDate.isBefore(DateTime.now()));
    }).toList();

    // Sort by due date (nearest first)
    notifications.sort((a, b) => a.dueDate.compareTo(b.dueDate));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        elevation: 0,
      ),
      body: notifications.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_off_outlined,
              size: 80,
              color: isDark ? Colors.grey[600] : Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No notifications',
              style: TextStyle(
                fontSize: 18,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You\'re all caught up!',
              style: TextStyle(
                color: isDark ? Colors.grey[500] : Colors.grey,
              ),
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final task = notifications[index];
          final isOverdue = task.dueDate.isBefore(DateTime.now());

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: CircleAvatar(
                backgroundColor: isOverdue ? Colors.red[100] : AppColors.primary.withOpacity(0.1),
                child: Icon(
                  isOverdue ? Icons.warning_amber_rounded : Icons.notifications_active,
                  color: isOverdue ? Colors.red : AppColors.primary,
                ),
              ),
              title: Text(
                task.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (task.description.isNotEmpty)
                    Text(
                      task.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const SizedBox(height: 8),
                  Text(
                    isOverdue
                        ? 'Overdue: ${task.dueDate.toLocal().toString().split(' ')[0]}'
                        : 'Due today: ${task.dueDate.toLocal().toString().split(' ')[0]}',
                    style: TextStyle(
                      color: isOverdue ? Colors.red : AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // Optional: Task details ya edit screen pe le jao
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Tapped on: ${task.title}')),
                );
              },
            ),
          );
        },
      ),
    );
  }
}