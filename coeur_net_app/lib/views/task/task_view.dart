import 'package:coeur_net_app/models/profile.dart';
import 'package:coeur_net_app/models/task.dart';
import 'package:coeur_net_app/providers/task_provider.dart';
import 'package:coeur_net_app/views/task/create_task_widget.dart';
import 'package:coeur_net_app/views/widget/alert_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

class TaskView extends ConsumerWidget {
  final Task task;
  final Profile? user;

  const TaskView({super.key, required this.task, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDone = task.status == TaskStatus.done;
    final isAdmin = user != null;
    final loading = ref.watch(taskNotifierProvider('${task.id}'));

    return Skeletonizer(
      enabled: loading,
      child: InkWell(
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder:
                (context) =>
                    CreateTaskModalWrapper(task: task, isAdmin: isAdmin),
          );
        },
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${task.title} ${isAdmin ? '(${user?.username})' : ''}',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    Chip(
                      label: Text(isDone ? 'Terminé' : 'À faire'),
                      backgroundColor:
                          isDone ? Colors.green[100] : Colors.orange[100],
                      labelStyle: TextStyle(
                        color: isDone ? Colors.green[800] : Colors.orange[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(task.description ?? 'Non précisé'),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      final status =
                          task.status == TaskStatus.done
                              ? TaskStatus.pending
                              : TaskStatus.done;
                      if (isAdmin) {
                        ref
                            .read(taskNotifierProvider('${task.id}').notifier)
                            .adminUpdate(task.copyWith(status: status));
                      } else {
                        {
                          ref
                              .read(taskNotifierProvider('${task.id}').notifier)
                              .update(task.copyWith(status: status));
                        }
                      }
                    },
                    icon: Icon(isDone ? Icons.undo : Icons.check_circle),
                    label: Text(task.status?.description ?? 'Non précisé'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isDone ? Colors.grey[300] : Colors.green[400],
                      foregroundColor: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: _DeleteButton(task: task),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DeleteButton extends ConsumerWidget {
  final Task task;
  const _DeleteButton({required this.task});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      tooltip: 'Supprimer la tâche',
      icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
      onPressed: () async {
        final confirmed = await showDialog<bool>(
          context: context,
          builder:
              (ctx) => AlertDialogWidget(
                title: "Confirmer la suppresion",
                content:
                    'Confirmez-vous la suppression de la tâche "${task.title}" ?',
                actionColor: Colors.red,
              ),
        );

        if (confirmed == true) {
          await ref
              .read(taskNotifierProvider('${task.id}').notifier)
              .delete(task.id);
        }
      },
    );
  }
}
