import 'package:coeur_net_app/models/profile.dart';
import 'package:dio/dio.dart';

class UserRepository {
  final Dio client;

  const UserRepository({required this.client});

  Future<void> createUser(Profile user) async {
    await client.post('users/create', data: user.toMap());
  }

  Future<void> createAdmin(Profile user) async {
    await client.post('admins/create', data: user.toMap());
  }

  Future<void> update(Profile user) async {
    await client.put('users/${user.id}', data: user.toMap());
  }

  Future<List<Profile>> userList() async {
    final response = await client.get("users");

    final data = List.of(response.data);

    return data.map((map) => Profile.fromMap(map)).toList();
  }

  Future<Profile> user(String id) async {
    final response = await client.get("users/$id");
    return Profile.fromMap(response.data);
  }

  Future<void> delete(String id) async {
    await client.delete("users/$id");
  }
}
