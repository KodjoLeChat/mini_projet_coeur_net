import 'package:coeur_net_app/services/api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final apiServiceProvider = FutureProvider<ApiService>((ref) async {
  return await ApiService.init(ref);
});
