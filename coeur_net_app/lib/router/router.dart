import 'package:coeur_net_app/router/loading_router.dart';
import 'package:coeur_net_app/router/login_router.dart';
import 'package:coeur_net_app/router/my_profile_router.dart';
import 'package:coeur_net_app/router/tensor_router.dart';
import 'package:coeur_net_app/router/user_list_router.dart';
import 'package:coeur_net_app/views/home/home_page.dart';
import 'package:coeur_net_app/views/profile/create_profile_widget.dart';
import 'package:coeur_net_app/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorTensorKey = GlobalKey<NavigatorState>(
  debugLabel: 'shell_tensor',
);
final _shellNavigatorUserListKey = GlobalKey<NavigatorState>(
  debugLabel: 'shell_user_list',
);
final _shellNavigatorMyProfileKey = GlobalKey<NavigatorState>(
  debugLabel: 'shell_my_profile',
);

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  final hasProfileStream = ref.watch(hasProfileProvider);
  final isAdminProvider = ref.watch(currentUserIsAdmin);

  return GoRouter(
    initialLocation: '/tensor',
    debugLogDiagnostics: true,
    navigatorKey: rootNavigatorKey,
    redirect: (context, state) {
      if (authState.value == null) return '/login';

      if (authState.isLoading) return '/loading';

      if (hasProfileStream.isLoading) return '/loading';

      if (hasProfileStream.value != true) return '/create-profile';

      return null;
    },

    routes: [
      loadingRouter,
      loginRouter,
      GoRoute(
        path: '/create-profile',
        builder: (context, state) => const CreateProfileWidget(),
      ),
      StatefulShellRoute.indexedStack(
        builder:
            (context, state, navigationShell) =>
                HomePageWidget(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            navigatorKey: _shellNavigatorTensorKey,
            routes: [tensorRouter],
          ),
          if (isAdminProvider.valueOrNull == true)
            StatefulShellBranch(
              navigatorKey: _shellNavigatorUserListKey,
              routes: [userListRouter],
            ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorMyProfileKey,
            routes: [myProfileRouter],
          ),
        ],
      ),
    ],
  );
});
