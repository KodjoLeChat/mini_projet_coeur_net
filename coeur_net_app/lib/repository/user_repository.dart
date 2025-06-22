import 'package:coeur_net_app/models/profile.dart';
import 'package:dio/dio.dart';

class UserRepository {
  final Dio client;

  const UserRepository({required this.client});

  Future<void> createUser(Profile user) async {
    await client.post('users/create', data: user.toMap());
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
}
