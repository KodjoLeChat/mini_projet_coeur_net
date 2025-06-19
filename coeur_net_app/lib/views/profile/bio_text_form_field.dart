import 'package:coeur_net_app/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BioTextFormField extends ConsumerWidget {
  const BioTextFormField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bio = ref.watch(createProfileViewModel.select((data) => data.bio));
    return TextFormField(
      initialValue: bio,
      maxLines: 3,
      decoration: const InputDecoration(
        labelText: 'Bio',
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Veuillez entrer une bio';
        }
        return null;
      },
      onChanged: (value) {
        final provider = ref.read(createProfileViewModel.notifier);
        final state = provider.state;
        provider.state = (bio: value, username: state.username);
      },
    );
  }
}
