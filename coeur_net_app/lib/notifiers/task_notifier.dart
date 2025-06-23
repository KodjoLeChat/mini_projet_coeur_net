import 'package:coeur_net_app/models/task.dart';
import 'package:coeur_net_app/providers/task_provider.dart';
import 'package:coeur_net_app/providers/user_provider.dart';
import 'package:coeur_net_app/repository/task_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskNotifier extends StateNotifier<bool> {
  final Ref ref;

  TaskNotifier(this.ref) : super(false);

  Future<void> _executeAction(Future<void> Function() action) async {
    try {
      state = true;
      await Future.delayed(const Duration(seconds: 1));
      await action();
    } catch (error) {
      debugPrint('error in execution action :  $error');
      rethrow;
    } finally {
      state = false;
    }
  }

  Future<TaskRepository> get taskRepository =>
      ref.read(taskRepositoryProvider.future);

  Future<void> delete(String? id) async {
    if (id == null) return;
    await _executeAction(() async {
      final provider = await taskRepository;
      await provider.delete(id);
      ref.invalidate(taskListProvider);
    });
  }

  Future<void> create(Task task) async {
    await _executeAction(() async {
      final provider = await taskRepository;
      await provider.createTask(task);
      ref.invalidate(taskListProvider);
    });
  }

  Future<void> update(Task task) async {
    await _executeAction(() async {
      final provider = await taskRepository;
      await provider.update(task);
      ref.invalidate(taskListProvider);
      ref.invalidate(userListProvider);
    });
  }

  Future<void> adminUpdate(Task task) async {
    await _executeAction(() async {
      final provider = await taskRepository;
      await provider.adminUpdate(task);
      ref.invalidate(taskListProvider);
      ref.invalidate(userListProvider);
    });
  }
}
