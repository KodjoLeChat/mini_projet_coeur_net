import 'package:coeur_net_app/views/task/all_task_page_widget.dart';
import 'package:go_router/go_router.dart';

final allTaskRouter = GoRoute(
  path: '/all_task',
  name: 'all_task',
  builder: (context, state) => AllTaskPageWidget(),
);
