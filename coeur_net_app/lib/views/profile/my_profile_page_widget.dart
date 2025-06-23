import 'package:coeur_net_app/models/profile.dart';
import 'package:coeur_net_app/providers/user_provider.dart';
import 'package:coeur_net_app/views/profile/profile_view.dart';
import 'package:coeur_net_app/views/widget/error_presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MyProfilePageWidget extends StatelessWidget {
  const MyProfilePageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: Text('Mon profile')),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: size / 3),
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
    final provider = ref.watch(currentUserProvider);

    return provider.when(
      data: (profile) {
        if (profile == null) return const SizedBox();
        return ProfileView(
          profile: profile,
          canDelete: false,
          isCurrentUserProfile: true,
        );
      },
      error:
          (error, stackTrace) => ErrorPresentation(
            error: error,
            stackTrace: stackTrace,
            onRetry: () => ref.invalidate(currentUserProvider),
          ),
      loading:
          () => Skeletonizer(child: ProfileView(profile: Profile.mockProfile)),
    );
  }
}
