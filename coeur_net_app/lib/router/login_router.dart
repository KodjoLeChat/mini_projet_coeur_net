import 'package:coeur_net_app/views/login/login_widget.dart';
import 'package:go_router/go_router.dart';

final loginRouter = GoRoute(
  path: '/login',
  name: 'login',
  builder: (context, state) => const LoginWidget(),
);
