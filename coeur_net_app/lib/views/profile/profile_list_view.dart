import 'package:coeur_net_app/models/profile.dart';
import 'package:coeur_net_app/views/profile/profile_view.dart';
import 'package:flutter/material.dart';

class ProfileListView extends StatelessWidget {
  final List<Profile> profiles;
  const ProfileListView({super.key, required this.profiles});

  @override
  Widget build(BuildContext context) {
    //final profiles = Profile.mockProfileList();
    return ListView.separated(
      padding: const EdgeInsets.all(24),
      itemCount: profiles.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) => ProfileView(profile: profiles[index]),
    );
  }
}
