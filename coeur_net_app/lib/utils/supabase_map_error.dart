import 'package:supabase_flutter/supabase_flutter.dart';

String mapSupabaseError(AuthApiException e) {
  switch (e.code) {
    case 'invalid_credentials':
      return "Email ou mot de passe incorrect.";
    case 'user_not_found':
      return "Aucun compte ne correspond à cet email.";
    case 'user_already_registered':
      return "Ce compte existe déjà.";
    default:
      return "Erreur : ${e.message}";
  }
}
