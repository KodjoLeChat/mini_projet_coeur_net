import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final _client = Supabase.instance.client;

  User? get currentUser => _client.auth.currentUser;

  Stream<User?> get userStream {
    return _client.auth.onAuthStateChange.map((data) {
      final Session? session = data.session;
      return session?.user;
    });
  }

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

  Stream<bool> hasProfile() async* {
    final userId = _client.auth.currentUser?.id;
    /*yield true;
    return;*/
    if (userId == null) {
      yield false;
      return;
    }
    final initial =
        await _client
            .from('profiles')
            .select('id')
            .eq('id', userId)
            .maybeSingle();
    yield initial != null;
  }

  Future<void> createProfile({
    required String username,
    required String bio,
  }) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('Utilisateur non connecté');
    }

    final response =
        await _client.from('profiles').insert({
          'id': userId,
          'username': username,
          'bio': bio,
          'is_admin': false,
        }).select();

    if (response.isEmpty) {
      throw Exception('Création du profil échouée (réponse vide)');
    }
  }
}
