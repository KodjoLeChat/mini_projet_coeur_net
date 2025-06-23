import 'package:coeur_net_app/models/profile.dart';
import 'package:coeur_net_app/providers/user_provider.dart';
import 'package:coeur_net_app/views/profile/create_profile_widget.dart';
import 'package:coeur_net_app/views/widget/alert_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProfileView extends ConsumerWidget {
  final Profile profile;
  final bool canDelete;
  final bool isCurrentUserProfile;
  const ProfileView({
    super.key,
    required this.profile,
    this.canDelete = true,
    this.isCurrentUserProfile = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loading = ref.watch(userNotifierProvider('${profile.id}'));
    final theme = Theme.of(context);
    final username = profile.username ?? 'Non précisé';
    final bio = profile.bio ?? 'Non précisé';
    return Skeletonizer(
      enabled: loading,
      child: InkWell(
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => CreateProfileModalWrapper(profile: profile),
          );
        },
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListTile(
            isThreeLine: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 12,
            ),
            leading: CircleAvatar(
              backgroundColor: theme.primaryColor,
              child: Text(
                username[0].toUpperCase(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text(
              "$username | ${profile.email} (${isCurrentUserProfile ? 'vous' : profile.role?.title})",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: Text(bio),
            trailing: canDelete ? _DeleteButton(profile: profile) : null,
          ),
        ),
      ),
    );
  }
}

class _DeleteButton extends ConsumerWidget {
  final Profile profile;
  const _DeleteButton({required this.profile});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final username = profile.username ?? 'Non précisé';
    return IconButton(
      icon: const Icon(Icons.delete, color: Colors.red),
      onPressed: () async {
        final confirmed = await showDialog<bool>(
          context: context,
          builder:
              (ctx) => AlertDialogWidget(
                title: "Confirmer la suppresion",
                content:
                    'Confirmez-vous la suppression du profile "$username" ?',
                actionColor: Colors.red,
              ),
        );

        if (confirmed == true) {
          await ref
              .read(userNotifierProvider('${profile.id}').notifier)
              .delete(profile.id);
        }
      },
    );
  }
}
