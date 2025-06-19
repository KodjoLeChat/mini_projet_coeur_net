import 'package:coeur_net_app/notifiers/user_notifier.dart';
import 'package:coeur_net_app/services/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final authStateProvider = AutoDisposeStreamProvider<Session?>((ref) {
  final service = ref.watch(authServiceProvider);
  return service.authStateChanges;
});

final hasProfileProvider = AutoDisposeStreamProvider<bool>((ref) {
  final profileService = ref.watch(authServiceProvider);
  return profileService.hasProfile();
});

final userNotifierProvider =
    AutoDisposeStateNotifierProviderFamily<UserNotifier, bool, String>(
      (ref, key) => UserNotifier(ref),
    );

final loginViewModel =
    AutoDisposeStateProvider<({String email, String password})>(
      (_) => throw UnimplementedError('provider for login unimplemented'),
    );

final createProfileViewModel = AutoDisposeStateProvider<
  ({String username, String bio})
>((_) => throw UnimplementedError('provider for create profile unimplemented'));
