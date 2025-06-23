import 'package:coeur_net_app/models/task.dart';
import 'package:coeur_net_app/providers/user_provider.dart';
import 'package:coeur_net_app/views/task/task_list_view.dart';
import 'package:coeur_net_app/views/widget/empty_state_widget.dart';
import 'package:coeur_net_app/views/widget/error_presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AllTaskPageWidget extends StatelessWidget {
  const AllTaskPageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Toutes les tâches')),
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
                    ref.invalidate(userListProvider);
                  },
                  tooltip: 'Rafraîchir la page',
                  child: const Icon(Icons.refresh),
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
    final provider = ref.watch(userListProvider);

    return provider.when(
      data: (users) {
        final tasks = users.expand((user) => user.tasks).toList();
        if (tasks.isEmpty) {
          return EmptyStateWidget(
            title: 'Aucune tâche de vos collègues pour le moment',
            subtitle:
                'Revenez prochainement quand vos collègues auront ajouté des tâches.',
            icon: Icons.task_outlined,
          );
        }
        return TaskListView(tasks: tasks, users: users);
      },
      error:
          (error, stackTrace) =>
              ErrorPresentation(error: error, stackTrace: stackTrace),
      loading:
          () => Skeletonizer(child: TaskListView(tasks: Task.mockTaskList())),
    );
  }
}
