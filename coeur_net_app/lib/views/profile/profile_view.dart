import 'package:coeur_net_app/models/profile.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatelessWidget {
  final Profile profile;
  const ProfileView({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final username = profile.username;
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 12,
        ),
        leading: CircleAvatar(
          backgroundColor: theme.primaryColor,
          child: Text(
            username?[0].toUpperCase() ?? '?',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(
          username ?? 'Non précisé',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(profile.bio ?? 'Non précisé'),
        trailing: _DeleteButton(username: username),
      ),
    );
  }
}

class _DeleteButton extends StatelessWidget {
  final String? username;
  const _DeleteButton({required this.username});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.delete, color: Colors.red),
      onPressed: () {
        showDialog(
          context: context,
          builder:
              (ctx) => AlertDialog(
                title: const Text("Confirmer la suppresion"),
                content: Text(
                  'Confirmez-vous la suppression du profile "$username" ?',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text("Annuler"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                    },
                    child: const Text(
                      "Supprimer",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
        );
      },
    );
  }
}
