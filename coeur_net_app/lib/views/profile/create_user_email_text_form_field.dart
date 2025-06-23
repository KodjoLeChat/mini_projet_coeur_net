import 'package:coeur_net_app/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateUserEmailTextFormField extends ConsumerWidget {
  const CreateUserEmailTextFormField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final email = ref.watch(
      createProfileViewModel.select((data) => data.email),
    );
    return TextFormField(
      initialValue: email,
      decoration: const InputDecoration(
        labelText: "Email",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(),
      ),
      onChanged: (value) {
        final provider = ref.read(createProfileViewModel.notifier);
        final state = provider.state;
        provider.state = state.copyWith(email: value);
      },
      validator:
          (value) =>
              value != null && value.contains('@') ? null : "Email invalide",
    );
  }
}
