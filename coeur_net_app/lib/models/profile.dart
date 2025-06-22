import 'package:flutter/foundation.dart';

@immutable
class Profile {
  final String? id;
  final String? email;
  final String? username;
  final String? bio;

  const Profile({this.id, this.username, this.bio, this.email});

  factory Profile.fromMap(Map<String, dynamic> map) =>
      Profile(id: map['id'], username: map['username'], bio: map['bio']);

  Map<String, dynamic> toMap() => {
    'email': email,
    'username': username,
    'bio': bio,
  };

  Profile copyWith({
    String? id,
    String? email,
    String? username,
    String? bio,
  }) => Profile(
    email: email ?? this.email,
    username: username ?? this.username,
    bio: bio ?? this.bio,
  );

  @override
  String toString() =>
      'Profile(id: $id, email : $email, username: $username, bio: $bio)';

  static Profile get mockProfile => Profile(
    id: '1',
    username: "username",
    bio: "bio" * 30,
    email: "email@exemple.com",
  );

  static List<Profile> mockProfileList([int number = 10]) =>
      List.generate(number, (index) => mockProfile);
}
