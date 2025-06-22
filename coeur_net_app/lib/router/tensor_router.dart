import 'package:coeur_net_app/views/tensor/tensor_widget.dart';
import 'package:go_router/go_router.dart';

final tensorRouter = GoRoute(
  path: '/tensor',
  name: 'tensor',
  builder: (context, state) => TensorWidget(),
);
