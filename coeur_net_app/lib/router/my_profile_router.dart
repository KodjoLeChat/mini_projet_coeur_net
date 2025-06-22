import 'package:coeur_net_app/views/profile/my_profile_page_widget.dart';
import 'package:go_router/go_router.dart';

final myProfileRouter = GoRoute(
  path: '/my_profile',
  name: 'my_profile',
  builder: (context, state) => MyProfilePageWidget(),
);
