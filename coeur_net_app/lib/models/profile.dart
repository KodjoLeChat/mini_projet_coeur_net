import 'package:coeur_net_app/models/task.dart';
import 'package:flutter/foundation.dart';

enum Role {
  admin(title: 'Administrateur'),
  user(title: 'Utilisateur');

  final String title;

  const Role({required this.title});
}

@immutable
class Profile {
  final String? id;
  final String? email;
  final String? username;
  final String? bio;
  final Role? role;
  final List<Task> tasks;

  const Profile({
    this.id,
    this.username,
    this.bio,
    this.email,
    this.role,
    this.tasks = const [],
  });

  factory Profile.fromMap(Map<String, dynamic> map) => Profile(
    id: map['id'],
    username: map['username'],
    bio: map['bio'],
    email: map['email'],
    role: Role.values.firstWhere(
      (value) => value.name == map['role'],
      orElse: () => Role.user,
    ),
  );

  Map<String, dynamic> toMap() =>
      {'email': email, 'username': username, 'bio': bio, 'role': role?.name}
        ..removeWhere((key, value) => value == null);

  Profile copyWith({
    String? id,
    String? email,
    String? username,
    String? bio,
    Role? role,
    List<Task>? tasks,
  }) => Profile(
    id: id ?? this.id,
    email: email ?? this.email,
    username: username ?? this.username,
    bio: bio ?? this.bio,
    role: role ?? this.role,
    tasks: tasks ?? this.tasks,
  );

  @override
  String toString() =>
      'Profile(id: $id, email : $email, username: $username, bio: $bio, role : $role, task : $tasks)';

  static Profile get mockProfile => Profile(
    id: '1',
    username: "username",
    bio: "bio" * 30,
    email: "email@exemple.com",
    role: Role.user,
  );

  static List<Profile> mockProfileList([int number = 10]) =>
      List.generate(number, (index) => mockProfile);
}
