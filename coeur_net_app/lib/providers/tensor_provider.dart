import 'package:coeur_net_app/providers/api_service_provider.dart';
import 'package:coeur_net_app/repository/tensor_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final tensorRepositoryProvider = FutureProvider((ref) async {
  final apiService = await ref.watch(apiServiceProvider.future);
  return TensorRepository(client: apiService.client);
});

final tensorProvider = FutureProvider<List<double>>((ref) async {
  final tensorRepo = await ref.watch(tensorRepositoryProvider.future);
  return tensorRepo.getTensor();
});
