import 'package:coeur_net_app/views/task/task_page_widget.dart';
import 'package:go_router/go_router.dart';

final taskRouter = GoRoute(
  path: '/task',
  name: 'task',
  builder: (context, state) => TaskPageWidget(),
);
