import 'package:coeur_net_app/models/profile.dart';
import 'package:coeur_net_app/models/task.dart';
import 'package:dio/dio.dart';

class TaskRepository {
  final Dio client;

  const TaskRepository({required this.client});

  Future<void> createTask(Task task) async {
    await client.post('tasks/create', data: task.toMap());
  }

  Future<void> update(Task task) async {
    await client.put('tasks/${task.id}', data: task.toMap());
  }

  Future<void> adminUpdate(Task task) async {
    await client.put('tasks/admin/${task.id}', data: task.toMap());
  }

  Future<List<Task>> taskList() async {
    final response = await client.get("tasks");

    final data = List.of(response.data);

    return data.map((map) => Task.fromMap(map)).toList();
  }

  Future<List<Task>> allTaskList() async {
    final response = await client.get("tasks/all");

    final data = List.of(response.data);

    return data.map((map) => Task.fromMap(map)).toList();
  }

  Future<Profile> task(String id) async {
    final response = await client.get("tasks/$id");
    return Profile.fromMap(response.data);
  }

  Future<void> delete(String id) async {
    await client.delete("tasks/$id");
  }
}
