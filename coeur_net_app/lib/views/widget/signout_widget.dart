import 'package:coeur_net_app/providers/user_provider.dart';
import 'package:coeur_net_app/views/widget/alert_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignoutWidget extends ConsumerWidget {
  final Color? iconColor;
  const SignoutWidget({super.key, this.iconColor});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const title = "Déconnexion";
    return IconButton(
      icon: Icon(Icons.logout, color: iconColor),
      tooltip: title,
      onPressed: () async {
        final confirmed = await showDialog<bool>(
          context: context,
          builder:
              (context) => const AlertDialogWidget(
                title: title,
                content: "Voulez-vous vraiment vous déconnecter ?",
              ),
        );
        if (confirmed == true) {
          await ref.read(authServiceProvider).signOut();
        }
      },
    );
  }
}
