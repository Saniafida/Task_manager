// lib/screens/tasks/edit_task_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/models/task_model.dart';
import 'package:task_manager/providers/task_provider.dart';
import 'package:task_manager/providers/project_provider.dart';
import 'package:task_manager/widgets/custom_textfield.dart';
import 'package:task_manager/widgets/custom_button.dart';

class EditTaskScreen extends StatefulWidget {
  final String taskId;
  const EditTaskScreen({super.key, required this.taskId});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late TaskModel _task;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _dueDate = DateTime.now();
  String? _projectId; // <-- Ab String? (nullable) kiya

  @override
  void initState() {
    super.initState();
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    _task = taskProvider.tasks.firstWhere((t) => t.id == widget.taskId);

    // Safely assign values
    _titleController.text = _task.title;
    _descriptionController.text = _task.description ?? '';
    _dueDate = _task.dueDate;
    _projectId = _task.projectId; // <-- String? ko String? mein assign → safe
  }

  @override
  Widget build(BuildContext context) {
    final projectProvider = Provider.of<ProjectProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomTextField(controller: _titleController, hintText: 'Title *'),
              const SizedBox(height: 16),
              CustomTextField(controller: _descriptionController, hintText: 'Description (Optional)'),
              const SizedBox(height: 16),

              // Updated Dropdown with "No Project" option
              DropdownButtonFormField<String?>(
                value: _projectId,
                decoration: const InputDecoration(
                  labelText: 'Project',
                  border: OutlineInputBorder(),
                  hintText: 'Select a project (optional)',
                ),
                isExpanded: true,
                items: [
                  const DropdownMenuItem<String?>(
                    value: null,
                    child: Text('No Project'),
                  ),
                  ...projectProvider.projects.map((project) {
                    return DropdownMenuItem<String?>(
                      value: project.id,
                      child: Text(project.name),
                    );
                  }).toList(),
                ],
                onChanged: (value) {
                  setState(() {
                    _projectId = value;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Due Date Picker
              ElevatedButton.icon(
                onPressed: () async {
                  final dueDate = await showDatePicker(
                    context: context,
                    initialDate: _dueDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (dueDate != null) {
                    setState(() => _dueDate = dueDate);
                  }
                },
                icon: const Icon(Icons.calendar_today),
                label: Text('Due Date: ${_dueDate.toLocal().toString().split(' ')[0]}'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
              const SizedBox(height: 24),

              // Update Button
              CustomButton(
                text: 'Update Task',
                onPressed: () {
                  if (_titleController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter a title')),
                    );
                    return;
                  }

                  final updatedTask = TaskModel(
                    id: _task.id,
                    title: _titleController.text.trim(),
                    description: _descriptionController.text.trim(),
                    dueDate: _dueDate,
                    isCompleted: _task.isCompleted,
                    projectId: _projectId, // <-- null bhi ja sakta hai → safe
                  );

                  Provider.of<TaskProvider>(context, listen: false).updateTask(updatedTask);
                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Task updated successfully!')),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}