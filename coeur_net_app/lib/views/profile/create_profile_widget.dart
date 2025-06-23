import 'package:coeur_net_app/models/profile.dart';
import 'package:coeur_net_app/providers/user_provider.dart';
import 'package:coeur_net_app/views/profile/bio_text_form_field.dart';
import 'package:coeur_net_app/views/profile/create_user_email_text_form_field.dart';
import 'package:coeur_net_app/views/profile/role_dropdown_form_field.dart';
import 'package:coeur_net_app/views/profile/username_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CreateProfileWidget extends StatelessWidget {
  final Profile? profile;
  const CreateProfileWidget({this.profile, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
        child: ProviderScope(
          overrides: [
            createProfileViewModel.overrideWith(
              (ref) =>
                  profile ??
                  Profile(email: '', bio: '', username: '', role: Role.user),
            ),
          ],
          child: _Form(isEdit: profile != null),
        ),
      ),
    );
  }
}

class _Form extends StatefulWidget {
  final bool isEdit;
  const _Form({required this.isEdit});

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
          CreateUserEmailTextFormField(),
          const SizedBox(height: 16),
          UsernameTextFormField(),
          const SizedBox(height: 16),
          const RoleDropdownFormField(),
          const SizedBox(height: 16),
          BioTextFormField(),
          const SizedBox(height: 32),
          _SubmitButton(
            formKey: _formKey,
            onError: _setError,
            isEdit: widget.isEdit,
          ),
        ],
      ),
    );
  }
}

class _SubmitButton extends ConsumerWidget {
  final GlobalKey<FormState> formKey;
  final void Function(String? message) onError;
  final bool isEdit;
  const _SubmitButton({
    required this.formKey,
    required this.onError,
    required this.isEdit,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(userNotifierProvider('createProfile'));
    final text = isEdit ? 'Modifier' : 'Ajouter';
    final nav = Navigator.of(context);
    return Skeletonizer(
      enabled: isLoading,
      child: ElevatedButton(
        onPressed: () async {
          onError(null);
          final isValidForm = formKey.currentState?.validate();

          if (isValidForm != true) return;

          final state = ref.read(createProfileViewModel);

          try {
            if (isEdit) {
              await ref
                  .read(userNotifierProvider('createProfile').notifier)
                  .update(state);
            } else {
              await ref
                  .read(userNotifierProvider('createProfile').notifier)
                  .create(state);
            }
            nav.pop();
          } catch (e) {
            onError('Erreur $e');
          }
        },
        child: Text(text),
      ),
    );
  }
}

class CreateProfileModalWrapper extends StatelessWidget {
  final Profile? profile;
  const CreateProfileModalWrapper({super.key, this.profile});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: SingleChildScrollView(
            controller: scrollController,
            child: CreateProfileWidget(profile: profile),
          ),
        );
      },
    );
  }
}
