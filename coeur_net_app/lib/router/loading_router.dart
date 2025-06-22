import 'package:coeur_net_app/loading_page.dart';
import 'package:go_router/go_router.dart';

final loadingRouter = GoRoute(
  path: '/loading',
  name: 'loading',
  builder: (context, state) => const LoadingPage(),
);
