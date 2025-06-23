import 'package:coeur_net_app/models/profile.dart';
import 'package:coeur_net_app/models/task.dart';
import 'package:coeur_net_app/views/task/task_view.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TaskListView extends StatelessWidget {
  final List<Task> tasks;
  final List<Profile>? users;
  const TaskListView({super.key, required this.tasks, this.users});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: tasks.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final task = tasks[index];
        return TaskView(
          task: task,
          user: users?.firstWhereOrNull((user) => user.id == task.userId),
        );
      },
    );
  }
}
