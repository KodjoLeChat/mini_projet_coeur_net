import 'package:coeur_net_app/models/task.dart';
import 'package:coeur_net_app/providers/task_provider.dart';
import 'package:coeur_net_app/views/task/create_task_widget.dart';
import 'package:coeur_net_app/views/task/task_list_view.dart';
import 'package:coeur_net_app/views/widget/empty_state_widget.dart';
import 'package:coeur_net_app/views/widget/error_presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

class TaskPageWidget extends StatelessWidget {
  const TaskPageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mes tâches')),
      body: _Content(),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16.0, right: 16.0),
        child: Consumer(
          builder: (context, ref, _) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 16.0,
              children: [
                FloatingActionButton(
                  heroTag: 'refreshFab',
                  onPressed: () {
                    ref.invalidate(taskListProvider);
                  },
                  tooltip: 'Rafraîchir la page',
                  child: const Icon(Icons.refresh),
                ),
                FloatingActionButton(
                  heroTag: 'addFab',
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder:
                          (context) =>
                              const CreateTaskModalWrapper(isAdmin: false),
                    );
                  },
                  tooltip: 'Ajouter une tâche',
                  child: const Icon(Icons.add),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Content extends ConsumerWidget {
  const _Content();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(taskListProvider);

    return provider.when(
      data: (tasks) {
        if (tasks.isEmpty) {
          return EmptyStateWidget(
            title: "Vous n'avez ajouté aucune tâche pour le moment",
            subtitle:
                'Vous pouvez ajouter des tâche en cliquant sur le bouton + ',
            icon: Icons.task_outlined,
          );
        }
        return TaskListView(tasks: tasks);
      },
      error:
          (error, stackTrace) =>
              ErrorPresentation(error: error, stackTrace: stackTrace),
      loading:
          () => Skeletonizer(child: TaskListView(tasks: Task.mockTaskList())),
    );
  }
}
