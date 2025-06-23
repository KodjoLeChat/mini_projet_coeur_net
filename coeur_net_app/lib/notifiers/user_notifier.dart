import 'package:coeur_net_app/models/profile.dart';
import 'package:coeur_net_app/providers/user_provider.dart';
import 'package:coeur_net_app/repository/user_repository.dart';
import 'package:coeur_net_app/services/auth_service.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserNotifier extends StateNotifier<bool> {
  final Ref ref;
  late final AuthService _authService;

  UserNotifier(this.ref) : super(false) {
    _authService = ref.read(authServiceProvider);
  }

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

  Future<void> login(({String email, String password}) param) async {
    await _executeAction(() async {
      await _authService.signInWithEmail(
        email: param.email,
        password: param.password,
      );
    });
  }

  Future<void> signout() async {
    await _executeAction(() async {
      await _authService.signOut();
    });
  }

  Future<UserRepository> get userRepository =>
      ref.read(userRepositoryProvider.future);

  Future<void> delete(String? id) async {
    if (id == null) return;

    await _executeAction(() async {
      final provider = await userRepository;
      await provider.delete(id);
      ref.invalidate(userListProvider);
    });
  }

  Future<void> create(Profile profile) async {
    await _executeAction(() async {
      final provider = await userRepository;
      if (profile.role == Role.user) await provider.createUser(profile);
      if (profile.role == Role.admin) await provider.createAdmin(profile);
      ref.invalidate(userListProvider);
    });
  }

  Future<void> update(Profile profile) async {
    await _executeAction(() async {
      final provider = await userRepository;
      await provider.update(profile);
      ref.invalidate(userListProvider);
    });
  }
}
