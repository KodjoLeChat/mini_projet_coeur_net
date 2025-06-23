import 'package:coeur_net_app/providers/user_provider.dart';
import 'package:coeur_net_app/views/widget/signout_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeView extends ConsumerWidget {
  const HomeView({
    super.key,
    required this.body,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });
  final Widget body;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAdminProvider = ref.watch(currentUserIsAdmin);

    final whiteColor = Colors.white;
    final theme = Theme.of(context);

    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            useIndicator: true,
            minWidth: 150,
            selectedIndex: selectedIndex,
            backgroundColor: theme.primaryColor,
            onDestinationSelected: onDestinationSelected,
            labelType: NavigationRailLabelType.all,
            leading: Padding(
              padding: EdgeInsets.only(top: 64.0, bottom: 64.0),
              child: _UserName(),
            ),
            trailing: Expanded(
              child: Column(
                children: [
                  Spacer(),
                  SignoutWidget(iconColor: Colors.white),
                  SizedBox(height: 50),
                ],
              ),
            ),
            destinations: [
              NavigationRailDestination(
                icon: Icon(Icons.bar_chart_outlined, color: whiteColor),
                selectedIcon: Icon(Icons.bar_chart_outlined),
                label: Text("Tensor", style: TextStyle(color: whiteColor)),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.task_outlined, color: whiteColor),
                selectedIcon: Icon(Icons.task_outlined),
                label: Text("Mes tâches", style: TextStyle(color: whiteColor)),
              ),
              if (isAdminProvider.valueOrNull == true)
                NavigationRailDestination(
                  icon: Icon(Icons.task_outlined, color: whiteColor),
                  selectedIcon: Icon(Icons.task_outlined),
                  label: Text(
                    "Toutes les tâches",
                    style: TextStyle(color: whiteColor),
                  ),
                ),
              if (isAdminProvider.valueOrNull == true)
                NavigationRailDestination(
                  icon: Icon(Icons.group_outlined, color: whiteColor),
                  selectedIcon: Icon(Icons.group_outlined),
                  label: Text(
                    "Utilisateurs",
                    style: TextStyle(color: whiteColor),
                  ),
                ),
              NavigationRailDestination(
                icon: Icon(Icons.person_outlined, color: whiteColor),
                selectedIcon: Icon(Icons.person_outlined),
                label: Text("Mon profile", style: TextStyle(color: whiteColor)),
              ),
            ],
          ),
          Expanded(child: body),
        ],
      ),
    );
  }
}

class _UserName extends ConsumerWidget {
  const _UserName();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(currentUserProvider);

    return provider.when(
      data: (profile) {
        final username = profile?.username;
        if (username == null) return const SizedBox();
        return Text(
          "Bonjour $username !",
          style: TextStyle(color: Colors.white),
        );
      },
      error: (error, stackTrace) => const SizedBox(),
      loading: () => Skeletonizer(enabled: true, child: Text('Username')),
    );
  }
}
