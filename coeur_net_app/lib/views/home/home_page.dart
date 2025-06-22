import 'package:coeur_net_app/views/home/home_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePageWidget extends StatelessWidget {
  const HomePageWidget({Key? key, required this.navigationShell})
    : super(key: key ?? const ValueKey<String>('HomeWidget'));
  final StatefulNavigationShell navigationShell;

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) => HomeView(
    body: navigationShell,
    selectedIndex: navigationShell.currentIndex,
    onDestinationSelected: _goBranch,
  );
}
