import 'package:coeur_net_app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://buakkevuyyltjigamytu.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJ1YWtrZXZ1eXlsdGppZ2FteXR1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTAxNzUyODksImV4cCI6MjA2NTc1MTI4OX0.eW-iCjrvi-psaC8kG15wQPQfKoo6dW-K8-971PWRQwE',
  );
  runApp(const ProviderScope(child: App()));
}
