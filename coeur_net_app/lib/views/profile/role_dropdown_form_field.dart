import 'package:coeur_net_app/models/profile.dart';
import 'package:coeur_net_app/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RoleDropdownFormField extends ConsumerWidget {
  const RoleDropdownFormField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final role = ref.watch(
      createProfileViewModel.select((profile) => profile.role),
    );

    return DropdownButtonFormField<Role>(
      value: role,
      decoration: const InputDecoration(
        labelText: "Rôle",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(),
      ),
      items:
          Role.values
              .map(
                (role) =>
                    DropdownMenuItem(value: role, child: Text(role.title)),
              )
              .toList(),
      onChanged: (value) {
        if (value != null) {
          final provider = ref.read(createProfileViewModel.notifier);
          final state = provider.state;
          provider.state = state.copyWith(role: value);
        }
      },
      validator:
          (value) => value == null ? 'Veuillez sélectionner un rôle' : null,
    );
  }
}
