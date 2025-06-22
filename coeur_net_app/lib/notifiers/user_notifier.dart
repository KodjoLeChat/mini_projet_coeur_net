import 'package:coeur_net_app/providers/user_provider.dart';
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
      Future.delayed(const Duration(seconds: 5));
      await action();
    } catch (error) {
      debugPrint('error in execution action :  $error');
      rethrow;
    } finally {
      state = false;
    }
  }

  Future<void> createProfile(({String username, String bio}) param) async {
    await _executeAction(() async {
      await _authService.createProfile(
        username: param.username,
        bio: param.bio,
      );
    });
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
}
