import 'package:coeur_net_app/providers/task_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DescriptionTextFormField extends ConsumerWidget {
  const DescriptionTextFormField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final description = ref.watch(
      createTaskViewModel.select((data) => data.description),
    );
    return TextFormField(
      initialValue: description,
      maxLines: 3,
      decoration: const InputDecoration(
        labelText: 'Description',
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Veuillez entrer une description';
        }
        return null;
      },
      onChanged: (value) {
        final provider = ref.read(createTaskViewModel.notifier);
        final state = provider.state;
        provider.state = state.copyWith(description: value);
      },
    );
  }
}
