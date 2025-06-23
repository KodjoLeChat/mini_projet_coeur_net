import 'package:coeur_net_app/providers/user_provider.dart';
import 'package:coeur_net_app/utils/supabase_map_error.dart';
import 'package:coeur_net_app/views/login/email_text_form_field.dart';
import 'package:coeur_net_app/views/login/password_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  String? _cachedEmail;

  @override
  void initState() {
    super.initState();
    _loadEmail();
  }

  Future<void> _loadEmail() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _cachedEmail = prefs.getString('cached_email') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              loginViewModel.overrideWith(
                (ref) => (email: _cachedEmail ?? '', password: ''),
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
  State<_Form> createState() => _FormState();
}

class _FormState extends State<_Form> {
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
          Text("Connexion", style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 24),
          if (_error != null)
            Text(_error!, style: const TextStyle(color: Colors.red)),
          const SizedBox(height: 16),
          EmailTextFormField(),
          const SizedBox(height: 16),
          PasswordTextFormField(),
          const SizedBox(height: 24),
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
    final isLoading = ref.watch(userNotifierProvider('login'));
    return SizedBox(
      width: double.infinity,
      child: Skeletonizer(
        enabled: isLoading,
        child: ElevatedButton(
          onPressed: () async {
            onError(null);
            final isValidForm = formKey.currentState?.validate();

            if (isValidForm != true) return;

            final state = ref.read(loginViewModel);

            try {
              await ref
                  .read(userNotifierProvider('login').notifier)
                  .login(state);
              ref.invalidate(authServiceProvider);
            } catch (e) {
              onError(mapSupabaseError(e as AuthApiException));
            }
          },
          child: const Text("Se connecter"),
        ),
      ),
    );
  }
}
