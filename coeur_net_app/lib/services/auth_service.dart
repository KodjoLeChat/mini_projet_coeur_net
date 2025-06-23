import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final _client = Supabase.instance.client;

  User? get currentUser => _client.auth.currentUser;

  Stream<User?> get userStream =>
      userSessionStream.map((session) => session?.user);

  Stream<Session?> get userSessionStream =>
      _client.auth.onAuthStateChange.map((data) => data.session);

  Stream<Session?> get authStateChanges =>
      _client.auth.onAuthStateChange.map((event) {
        return event.session;
      });

  Future<void> signOut() async => _client.auth.signOut();

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    await _client.auth.signInWithPassword(email: email, password: password);
  }
}
