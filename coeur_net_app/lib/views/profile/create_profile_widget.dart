import 'package:coeur_net_app/providers/user_provider.dart';
import 'package:coeur_net_app/views/profile/bio_text_form_field.dart';
import 'package:coeur_net_app/views/profile/username_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CreateProfileWidget extends StatelessWidget {
  const CreateProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Créer votre profil')),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [BoxShadow(blurRadius: 10, color: Colors.black12)],
          ),
          child: ProviderScope(
            overrides: [
              createProfileViewModel.overrideWith(
                (ref) => (bio: '', username: ''),
              ),
            ],
            child: _Form(),
          ),
        ),
      ),
    );
  }
}

class _Form extends StatefulWidget {
  const _Form();

  @override
  State<_Form> createState() => __FormState();
}

class __FormState extends State<_Form> {
  final _formKey = GlobalKey<FormState>();

  String? _error;

  void _setError(String? message) {
    setState(() => _error = message);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_error != null) ...[
            Text(_error!, style: TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
          ],
          UsernameTextFormField(),
          const SizedBox(height: 16),
          BioTextFormField(),
          const SizedBox(height: 32),
          _SubmitButton(formKey: _formKey, onError: _setError),
        ],
      ),
    );
  }
}

class _SubmitButton extends ConsumerWidget {
  final GlobalKey<FormState> formKey;
  final void Function(String? message) onError;
  const _SubmitButton({required this.formKey, required this.onError});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(userNotifierProvider('createProfile'));
    return Skeletonizer(
      enabled: isLoading,
      child: ElevatedButton(
        onPressed: () async {
          onError(null);
          final isValidForm = formKey.currentState?.validate();

          if (isValidForm != true) return;

          final state = ref.read(createProfileViewModel);

          try {
            await ref
                .read(userNotifierProvider('createProfile').notifier)
                .createProfile(state);

            ref.invalidate(hasProfileProvider);
          } catch (e) {
            onError('Erreur $e');
          }
        },
        child: const Text('Créer le profil'),
      ),
    );
  }
}
