import 'package:coeur_net_app/views/profile/profile_page_widget.dart';
import 'package:go_router/go_router.dart';

final userListRouter = GoRoute(
  path: '/user_list',
  name: 'user_list',
  builder: (context, state) => ProfilePageWidget(),
);
