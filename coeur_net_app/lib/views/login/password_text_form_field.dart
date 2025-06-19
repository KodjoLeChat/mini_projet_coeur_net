import 'package:coeur_net_app/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PasswordTextFormField extends ConsumerStatefulWidget {
  const PasswordTextFormField({super.key});

  @override
  ConsumerState<PasswordTextFormField> createState() =>
      _PasswordTextFormField();
}

class _PasswordTextFormField extends ConsumerState<PasswordTextFormField> {
  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    final password = ref.watch(loginViewModel.select((data) => data.password));
    return TextFormField(
      initialValue: password,
      obscureText: isObscure,
      decoration: InputDecoration(
        labelText: "Mot de passe",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              isObscure = !isObscure;
            });
          },
          icon: Icon(isObscure ? Icons.visibility_off : Icons.visibility),
        ),
      ),
      onChanged: (value) {
        final provider = ref.read(loginViewModel.notifier);
        final state = provider.state;
        provider.state = (email: state.email, password: value);
      },
      validator:
          (value) =>
              value != null && value.length >= 6
                  ? null
                  : "Mot de passe trop court",
    );
  }
}
