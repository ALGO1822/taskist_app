import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskist_app/constants/app_theme.dart';
import 'package:taskist_app/model/project.dart';
import 'package:taskist_app/providers/project_provider.dart';
import 'package:taskist_app/view/project_details_page.dart';
import 'package:taskist_app/widgets/custom_button.dart';
import 'package:taskist_app/widgets/custom_textfield.dart';

class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({super.key});

  Future<void> _showAddProjectDialog(BuildContext context) async {
    final controller = TextEditingController();
    final theme = Theme.of(context);
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: theme.scaffoldBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text('Create Project', style: theme.textTheme.titleLarge),
          content: CustomTextField(
            hintText: 'Enter project name',
            prefixIcon: Icons.folder,
            controller: controller,
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: theme.unselectedWidgetColor),
              ),
            ),
            CustomButton(
              text: 'Add',
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  Provider.of<ProjectProvider>(
                    context,
                    listen: false,
                  ).addProject(controller.text);
                  Navigator.pop(context);
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showRenameProjectDialog(BuildContext context, Project project) async {
  final controller = TextEditingController(text: project.title);
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Rename Project'),
        content: TextField(
          controller: controller,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                Provider.of<ProjectProvider>(context, listen: false)
                    .renameProject(project.id, controller.text);
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
    return Scaffold(
      backgroundColor: AppColors.offWhite,
      appBar: AppBar(
        title: Text('My Projects', style: theme.textTheme.titleLarge),
        centerTitle: true,
      ),
      body: Consumer<ProjectProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.projects.isEmpty) {
            return Center(
              child: Text(
                'No projects yet.\nTap + to create one.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.unselectedWidgetColor,
                  height: 1.5,
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: provider.projects.length,
            itemBuilder: (context, index) {
              final project = provider.projects[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 14),
                decoration: BoxDecoration(
                  color: AppColors.backgroundColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withAlpha(20),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  title: Text(
                    project.title,
                    style: theme.textTheme.titleMedium,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProjectDetailScreen(project: project),
                      ),
                    );
                  },
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'rename') {
                        _showRenameProjectDialog(context, project);
                      } else if (value == 'delete') {
                        Provider.of<ProjectProvider>(
                          context,
                          listen: false,
                        ).deleteProject(project.id);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'rename',
                        child: Row(
                          children: [
                            Icon(Icons.edit, color: AppColors.primaryBlue),
                            SizedBox(width: 8),
                            Text('Rename'),
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
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: theme.primaryColor,
        onPressed: () => _showAddProjectDialog(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: const Icon(Icons.add, size: 28, color: Colors.white),
      ),
    );
  }
}
