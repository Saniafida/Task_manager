// lib/screens/home/home_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/providers/task_provider.dart';
import 'package:task_manager/providers/project_provider.dart';
import 'package:task_manager/widgets/bottom_nav_bar.dart';
import 'package:task_manager/core/routes/app_routes.dart';
import 'package:task_manager/core/theme/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<TaskProvider>(context, listen: false).fetchTasks();
    Provider.of<ProjectProvider>(context, listen: false).fetchProjects();
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final projectProvider = Provider.of<ProjectProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final completedTasks = taskProvider.tasks.where((t) => t.isCompleted).length;
    final totalTasks = taskProvider.tasks.length;
    final progress = totalTasks > 0 ? completedTasks / totalTasks : 0.0;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : const Color(0xFFF5F5F5),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primary,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome Back',
              style: TextStyle(
                color: AppColors.white.withOpacity(0.9),
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
            const Text(
              'Task Manager',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          Consumer<TaskProvider>(
            builder: (context, taskProvider, child) {
              final int notificationCount = taskProvider.tasks
                  .where((t) => !t.isCompleted)
                  .where((t) => t.dueDate.isBefore(DateTime.now().add(const Duration(days: 1))))
                  .length;

              return IconButton(
                icon: Stack(
                  children: [
                    const Icon(Icons.notifications_outlined, color: AppColors.white, size: 28),
                    if (notificationCount > 0)
                      Positioned(
                        right: 6,
                        top: 6,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                          child: Text(
                            notificationCount > 99 ? '99+' : notificationCount.toString(),
                            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.notifications);
                },
                tooltip: 'Notifications',
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await taskProvider.fetchTasks();
          await projectProvider.fetchProjects();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress Card
              _buildProgressCard(context, completedTasks, totalTasks, progress, isDark),
              const SizedBox(height: 24),

              // Quick Actions
              Text(
                'Quick Actions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.white : AppColors.black,
                ),
              ),
              const SizedBox(height: 12),
              _buildQuickActions(context, isDark),
              const SizedBox(height: 24),

              // Statistics
              Text(
                'Overview',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.white : AppColors.black,
                ),
              ),
              const SizedBox(height: 12),
              _buildStatistics(context, taskProvider, projectProvider, isDark),
              const SizedBox(height: 24),

              // Recent Tasks
              _buildRecentTasksSection(context, taskProvider, isDark),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.addTask),
        icon: const Icon(Icons.add),
        label: const Text('New Task'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) Navigator.pushNamed(context, AppRoutes.todayTasks);
          if (index == 2) Navigator.pushNamed(context, AppRoutes.projectList);
          if (index == 3) Navigator.pushNamed(context, AppRoutes.profile);
        },
      ),
    );
  }

  Widget _buildProgressCard(BuildContext context, int completed, int total, double progress, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.primary.withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Today\'s Progress',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${(progress * 100).toInt()}%',
                  style: const TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: AppColors.white.withOpacity(0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.white),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '$completed of $total tasks completed',
            style: TextStyle(
              color: AppColors.white.withOpacity(0.9),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, bool isDark) {
    return Row(
      children: [
        Expanded(
          child: _buildActionCard(
            context,
            icon: Icons.today_outlined,
            title: 'Today',
            color: AppColors.primary,
            onTap: () => Navigator.pushNamed(context, AppRoutes.todayTasks),
            isDark: isDark,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildActionCard(
            context,
            icon: Icons.folder_outlined,
            title: 'Projects',
            color: AppColors.secondary,
            onTap: () => Navigator.pushNamed(context, AppRoutes.projectList),
            isDark: isDark,
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard(
      BuildContext context, {
        required IconData icon,
        required String title,
        required Color color,
        required VoidCallback onTap,
        required bool isDark,
      }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : AppColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.white : AppColors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatistics(BuildContext context, TaskProvider taskProvider, ProjectProvider projectProvider, bool isDark) {
    final pendingTasks = taskProvider.tasks.where((t) => !t.isCompleted).length;
    final activeProjects = projectProvider.projects.length;

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Pending',
            pendingTasks.toString(),
            Icons.pending_actions,
            Colors.orange,
            isDark,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Completed',
            taskProvider.tasks.where((t) => t.isCompleted).length.toString(),
            Icons.check_circle_outline,
            AppColors.success,
            isDark,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Projects',
            activeProjects.toString(),
            Icons.folder_open,
            AppColors.primary,
            isDark,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.white : AppColors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? AppColors.white.withOpacity(0.7) : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTasksSection(BuildContext context, TaskProvider taskProvider, bool isDark) {
    final recentTasks = taskProvider.tasks.take(5).toList();

    if (recentTasks.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : AppColors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.inbox_outlined,
                size: 48,
                color: isDark ? AppColors.white.withOpacity(0.3) : Colors.grey[400],
              ),
              const SizedBox(height: 12),
              Text(
                'No tasks yet',
                style: TextStyle(
                  color: isDark ? AppColors.white.withOpacity(0.7) : Colors.grey[600],
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Tasks',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.white : AppColors.black,
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.todayTasks),
              child: Text(
                'See All',
                style: TextStyle(color: AppColors.primary),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E1E) : AppColors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: recentTasks.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              color: isDark ? AppColors.white.withOpacity(0.1) : Colors.grey[200],
            ),
            itemBuilder: (context, index) {
              final task = recentTasks[index];
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: Checkbox(
                  value: task.isCompleted,
                  onChanged: (value) {
                    if (value != null) {
                      taskProvider.toggleTaskCompletion(task.id);
                    }
                  },
                  activeColor: AppColors.success,
                  checkColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  side: BorderSide(
                    color: isDark ? AppColors.white.withOpacity(0.5) : Colors.grey,
                    width: 2,
                  ),
                ),
                title: Text(
                  task.title,
                  style: TextStyle(
                    decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                    color: task.isCompleted
                        ? (isDark ? AppColors.white.withOpacity(0.5) : Colors.grey)
                        : (isDark ? AppColors.white : AppColors.black),
                  ),
                ),
                subtitle: task.description != null
                    ? Text(
                  task.description!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? AppColors.white.withOpacity(0.6) : Colors.grey[600],
                  ),
                )
                    : null,
                trailing: Icon(
                  Icons.chevron_right,
                  color: isDark ? AppColors.white.withOpacity(0.5) : Colors.grey,
                ),
                onTap: () {
                  // Navigate to task details
                },
              );
            },
          ),
        ),
      ],
    );
  }
}