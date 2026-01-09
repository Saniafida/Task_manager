// lib/core/routes/app_routes.dart

import 'package:flutter/material.dart';
import 'package:task_manager/screens/onboarding/onboarding_screen.dart';
import 'package:task_manager/screens/home/home_screen.dart';
import 'package:task_manager/screens/tasks/today_tasks_screen.dart';
import 'package:task_manager/screens/tasks/add_task_screen.dart';
import 'package:task_manager/screens/tasks/edit_task_screen.dart';
import 'package:task_manager/screens/projects/project_list_screen.dart';
import 'package:task_manager/screens/projects/add_project_screen.dart';
import 'package:task_manager/screens/profile/profile_screen.dart';
import 'package:task_manager/screens/notifications/notifications_screen.dart'; // <-- Yeh import add kiya

class AppRoutes {
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String todayTasks = '/today_tasks';
  static const String addTask = '/add_task';
  static const String editTask = '/edit_task';
  static const String projectList = '/project_list';
  static const String addProject = '/add_project';
  static const String profile = '/profile';
  static const String notifications = '/notifications'; // <-- Already tha, sahi hai

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case todayTasks:
        return MaterialPageRoute(builder: (_) => const TodayTasksScreen());
      case addTask:
        return MaterialPageRoute(builder: (_) => const AddTaskScreen());
      case editTask:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => EditTaskScreen(taskId: args?['taskId'] ?? ''),
        );
      case projectList:
        return MaterialPageRoute(builder: (_) => const ProjectListScreen());
      case addProject:
        return MaterialPageRoute(builder: (_) => const AddProjectScreen());
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case notifications:
        return MaterialPageRoute(builder: (_) => const NotificationsScreen()); // <-- Fix kiya: notificationsreens → NotificationsScreen
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(body: Center(child: Text('Route not found'))),
        );
    }
  }
}