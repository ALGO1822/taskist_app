// /screens/project_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskist_app/constants/app_theme.dart';
import 'package:taskist_app/model/project.dart';
import 'package:taskist_app/model/task.dart';
import 'package:taskist_app/providers/task_provider.dart';
import 'package:taskist_app/widgets/custom_button.dart';
import 'package:taskist_app/widgets/custom_textfield.dart';

class ProjectDetailScreen extends StatelessWidget {
  final Project project;

  const ProjectDetailScreen({super.key, required this.project});

  // ✅ Remove taskProvider from args
  Future<void> _showTaskDetails(BuildContext context, Task task) async {
    return showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(task.title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Description: ${task.description.isNotEmpty ? task.description : "No description"}',
                style: TextStyle(
                  fontStyle: task.description.isNotEmpty ? FontStyle.normal : FontStyle.italic,
                  fontSize: 15,
                ),
              ),
              if (task.priority == 'High')
                Text.rich(
                  TextSpan(
                    text: 'Priority: ',
                    style: TextStyle(fontSize: 15, color: AppColors.textBlue),
                    children: [
                      TextSpan(
                        text: task.priority,
                        style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.errorRed),
                      ),
                    ],
                  ),
                ),
              if (task.priority == 'Medium')
                Text.rich(
                  TextSpan(
                    text: 'Priority: ',
                    style: TextStyle(fontSize: 15, color: AppColors.textBlue),
                    children: [
                      TextSpan(
                        text: task.priority,
                        style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.warningYellow),
                      ),
                    ],
                  ),
                ),
              if (task.priority == 'Low')
                Text.rich(
                  TextSpan(
                    text: 'Priority: ',
                    style: TextStyle(fontSize: 15, color: AppColors.textBlue),
                    children: [
                      TextSpan(
                        text: task.priority,
                        style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.successGreen),
                      ),
                    ],
                  ),
                ),
              Text.rich(
                TextSpan(
                  text: 'Due Date: ',
                  style: TextStyle(fontSize: 15, color: AppColors.textBlue),
                  children: [
                    TextSpan(
                      text: task.dueDate,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            CustomButton(
              onPressed: () {
                Navigator.pop(dialogContext); // ✅ Use dialogContext
              },
              text: 'Close',
              textColor: Colors.black,
              color: Colors.transparent,
            ),
          ],
        );
      },
    );
  }

  Future<void> _showAddTaskDialog(BuildContext context, TaskProvider taskProvider) async {
    final controller = TextEditingController();
    final descController = TextEditingController();
    String priority = 'Medium';
    String dueDate = 'Today';

    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Text('Add Task', style: Theme.of(context).textTheme.titleLarge),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomTextField(
                    controller: controller,
                    hintText: 'Task title',
                    prefixIcon: Icons.task_alt,
                  ),
                  const SizedBox(height: 12),
                  CustomTextField(
                    controller: descController,
                    hintText: 'Description (optional)',
                    prefixIcon: Icons.description,
                    maxLines: null,
                    maxLength: 200,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: priority,
                    items: ['Low', 'Medium', 'High']
                        .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        priority = value!;
                      });
                    },
                    decoration: const InputDecoration(labelText: 'Priority'),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: dueDate,
                    items: ['Today', 'Tomorrow', 'This Week', 'Next Week']
                        .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        dueDate = value!;
                      });
                    },
                    decoration: const InputDecoration(labelText: 'Due Date'),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                CustomButton(
                  onPressed: () {
                    if (controller.text.isNotEmpty) {
                      taskProvider.addTask(
                        projectId: project.id,
                        title: controller.text,
                        description: descController.text,
                        priority: priority,
                        dueDate: dueDate,
                      );
                      Navigator.pop(context);
                    }
                  },
                  text: 'Add',
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _showEditTaskDialog(BuildContext context, TaskProvider taskProvider, Task task) async {
    final controller = TextEditingController(text: task.title);
    final descController = TextEditingController(text: task.description);

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                autofocus: true,
                decoration: const InputDecoration(labelText: 'Task Title'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descController,
                maxLines: 3,
                maxLength: 200,
                decoration: const InputDecoration(
                  labelText: 'Description (optional)',
                  alignLabelWithHint: true,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  // ✅ Fix: Use named parameters for clarity
                  taskProvider.editTask(
                    taskId: task.id,
                    newTitle: controller.text,
                    newDescription: descController.text,
                    projectId: task.projectId,
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ChangeNotifierProvider(
      create: (context) => TaskProvider(project.id),
      child: Scaffold(
        backgroundColor: AppColors.offWhite,
        appBar: AppBar(title: Text(project.title)),
        body: Consumer<TaskProvider>(
          builder: (context, taskProvider, child) {
            if (taskProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (taskProvider.tasks.isEmpty) {
              return Center(
                child: Text(
                  'No tasks yet.\nTap + to add one.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: AppColors.mutedColor,
                  ),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: taskProvider.tasks.length,
              itemBuilder: (context, index) {
                final task = taskProvider.tasks[index];
                return GestureDetector(
                  onTap: () {
                    _showTaskDetails(context, task); // ✅ Removed taskProvider
                  },
                  child: Card(
                    color: AppColors.backgroundColor,
                    elevation: 2,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: Checkbox(
                        value: task.isCompleted,
                        onChanged: (checked) {
                          taskProvider.toggleCompletion(task.id, project.id);
                        },
                        activeColor: AppColors.primaryBlue,
                      ),
                      title: Text(
                        task.title,
                        style: TextStyle(
                          decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      subtitle: Text('${task.priority} • ${task.dueDate}'),
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'edit') {
                            _showEditTaskDialog(context, taskProvider, task);
                          } else if (value == 'delete') {
                            taskProvider.deleteTask(task.id, task.projectId);
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(Icons.edit, color: AppColors.primaryBlue),
                                SizedBox(width: 8),
                                Text('Edit'),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete, color: AppColors.errorRed),
                                SizedBox(width: 8),
                                Text('Delete'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
        floatingActionButton: Consumer<TaskProvider>(
          builder: (context, taskProvider, child) {
            return FloatingActionButton(
              onPressed: () => _showAddTaskDialog(context, taskProvider),
              backgroundColor: AppColors.primaryBlue,
              child: const Icon(Icons.add, color: Colors.white),
            );
          },
        ),
      ),
    );
  }
}