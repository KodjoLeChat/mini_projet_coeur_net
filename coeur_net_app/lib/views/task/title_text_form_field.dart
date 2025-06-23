import 'package:coeur_net_app/providers/task_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TitleTextFormField extends ConsumerWidget {
  const TitleTextFormField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final title = ref.watch(createTaskViewModel.select((data) => data.title));
    return TextFormField(
      initialValue: title,
      decoration: const InputDecoration(
        labelText: "Titre",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(),
      ),

      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Veuillez entrer un titre";
        }
        if (value.trim().length < 3) {
          return 'Minimum 3 caractères requis';
        }
        return null;
      },
      onChanged: (value) {
        final provider = ref.read(createTaskViewModel.notifier);
        final state = provider.state;
        provider.state = state.copyWith(title: value);
      },
    );
  }
}
