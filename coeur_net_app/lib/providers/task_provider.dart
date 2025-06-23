import 'package:coeur_net_app/models/task.dart';
import 'package:coeur_net_app/notifiers/task_notifier.dart';
import 'package:coeur_net_app/providers/api_service_provider.dart';
import 'package:coeur_net_app/repository/task_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final taskRepositoryProvider = FutureProvider<TaskRepository>((ref) async {
  final apiService = await ref.watch(apiServiceProvider.future);
  return TaskRepository(client: apiService.client);
});

final taskListProvider = FutureProvider((ref) async {
  final taskRepo = await ref.watch(taskRepositoryProvider.future);
  return taskRepo.taskList();
});

final taskNotifierProvider =
    AutoDisposeStateNotifierProviderFamily<TaskNotifier, bool, String>(
      (ref, key) => TaskNotifier(ref),
    );

final createTaskViewModel = AutoDisposeStateProvider<Task>(
  (_) => throw UnimplementedError('provider for create task unimplemented'),
);
