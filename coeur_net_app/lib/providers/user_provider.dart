import 'dart:convert';

import 'package:coeur_net_app/models/profile.dart';
import 'package:coeur_net_app/notifiers/user_notifier.dart';
import 'package:coeur_net_app/providers/api_service_provider.dart';
import 'package:coeur_net_app/repository/user_repository.dart';
import 'package:coeur_net_app/services/api_service.dart';
import 'package:coeur_net_app/services/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final authServiceProvider = Provider((ref) => AuthService());

final userRepositoryProvider = FutureProvider<UserRepository>((ref) async {
  final apiService = await ref.watch(apiServiceProvider.future);
  return UserRepository(client: apiService.client);
});

final userListProvider = FutureProvider((ref) async {
  final userRepo = await ref.watch(userRepositoryProvider.future);
  return userRepo.userList();
});

final authStateProvider = AutoDisposeStreamProvider<Session?>((ref) {
  final service = ref.watch(authServiceProvider);
  return service.authStateChanges;
});

final authSessionStream = StreamProvider<Session?>((ref) async* {
  final service = ref.watch(authServiceProvider);
  yield* service.userSessionStream;
});

final currentUserProvider = AutoDisposeFutureProvider((ref) async {
  final session = await ref.watch(authSessionStream.future);
  if (session == null) return null;
  final user = session.user;
  final profile = await (await ref.watch(
    userRepositoryProvider.future,
  )).user(user.id);
  return profile;
});

final currentUserRoleProvider = AutoDisposeFutureProvider((ref) async {
  final token = await ApiService.getToken(ref);
  if (token == null) return null;
  final payload = token.split('.')[1];
  final normalized = base64Url.normalize(payload);
  final decodedBytes = base64Url.decode(normalized);
  final jsonString = utf8.decode(decodedBytes);
  final payloadMap = json.decode(jsonString) as Map<String, dynamic>;
  return List.of(payloadMap['app_metadata']['roles']).first as String;
});

final currentUserIsAdmin = AutoDisposeFutureProvider((ref) async {
  final role = await ref.watch(currentUserRoleProvider.future);
  return role == 'admin';
});

final userNotifierProvider =
    AutoDisposeStateNotifierProviderFamily<UserNotifier, bool, String>(
      (ref, key) => UserNotifier(ref),
    );

final loginViewModel =
    AutoDisposeStateProvider<({String email, String password})>(
      (_) => throw UnimplementedError('provider for login unimplemented'),
    );

final createProfileViewModel = AutoDisposeStateProvider<Profile>(
  (_) => throw UnimplementedError('provider for create profile unimplemented'),
);
