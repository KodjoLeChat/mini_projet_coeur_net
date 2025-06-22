import 'package:coeur_net_app/home_page.dart';
import 'package:coeur_net_app/views/profile/create_profile_widget.dart';
import 'package:coeur_net_app/loading_page.dart';
import 'package:coeur_net_app/views/login/login_widget.dart';
import 'package:coeur_net_app/providers/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  final hasProfileStream = ref.watch(hasProfileProvider);

  return GoRouter(
    initialLocation: '/',

    redirect: (context, state) {
      if (authState.value == null) return '/login';

      if (authState.isLoading) return '/loading';

      if (hasProfileStream.isLoading) return '/loading';

      if (hasProfileStream.value != true) return '/create-profile';

      return null;
    },

    routes: [
      GoRoute(path: '/', builder: (context, state) => const HomePage()),
      GoRoute(path: '/login', builder: (context, state) => const LoginWidget()),
      GoRoute(
        path: '/loading',
        builder: (context, state) => const LoadingPage(),
      ),
      GoRoute(
        path: '/create-profile',
        builder: (context, state) => const CreateProfileWidget(),
      ),
    ],
  );
});
