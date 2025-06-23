import 'package:coeur_net_app/models/profile.dart';
import 'package:coeur_net_app/providers/user_provider.dart';
import 'package:coeur_net_app/views/profile/create_profile_widget.dart';
import 'package:coeur_net_app/views/profile/profile_list_view.dart';
import 'package:coeur_net_app/views/widget/empty_state_widget.dart';
import 'package:coeur_net_app/views/widget/error_presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProfilePageWidget extends StatelessWidget {
  const ProfilePageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profiles')),

      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16.0, right: 16.0),
        child: Consumer(
          builder: (context, ref, _) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 16.0,
              children: [
                FloatingActionButton(
                  heroTag: 'refreshFab',
                  onPressed: () {
                    ref.invalidate(userListProvider);
                  },
                  tooltip: 'Refresh',
                  child: const Icon(Icons.refresh),
                ),
                FloatingActionButton(
                  heroTag: 'addFab',
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => const CreateProfileModalWrapper(),
                    );
                  },
                  tooltip: 'Ajouter',
                  child: const Icon(Icons.add),
                ),
              ],
            );
          },
        ),
      ),

      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: _Content(),
        ),
      ),
    );
  }
}

class _Content extends ConsumerWidget {
  const _Content();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(userListProvider);

    return provider.when(
      loading:
          () => Skeletonizer(
            enabled: true,
            child: ProfileListView(profiles: Profile.mockProfileList()),
          ),
      error:
          (error, stackTrace) => ErrorPresentation(
            error: error,
            stackTrace: stackTrace,
            onRetry: () => ref.invalidate(userListProvider),
          ),
      data: (profiles) {
        if (profiles.isEmpty) {
          return const EmptyStateWidget(
            title: 'Aucun profil trouvé',
            subtitle: 'Ajoutez des utilisateurs pour commencer.',
          );
        }

        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: ProfileListView(profiles: profiles),
          ),
        );
      },
    );
  }
}
