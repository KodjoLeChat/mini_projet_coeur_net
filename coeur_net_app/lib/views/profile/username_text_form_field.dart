import 'package:coeur_net_app/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UsernameTextFormField extends ConsumerWidget {
  const UsernameTextFormField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final username = ref.watch(
      createProfileViewModel.select((data) => data.username),
    );
    return TextFormField(
      initialValue: username,
      decoration: const InputDecoration(
        labelText: "Nom d'utilisateur",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(),
      ),

      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Veuillez entrer un nom d'utilisateur";
        }
        if (value.trim().length < 3) {
          return 'Minimum 3 caractères requis';
        }
        return null;
      },
      onChanged: (value) {
        final provider = ref.read(createProfileViewModel.notifier);
        final state = provider.state;
        provider.state = state.copyWith(username: value);
      },
    );
  }
}
