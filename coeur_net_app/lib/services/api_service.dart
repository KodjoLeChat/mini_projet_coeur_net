import 'package:coeur_net_app/providers/user_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ApiService {
  static final String baseUrl = "http://localhost:8000/";
  final Dio client;
  ApiService._(this.client);

  static Future<ApiService> init(Ref ref) async {
    final token = await getToken(ref);
    final headers = <String, String>{'Content-Type': 'application/json'};
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    final dio = Dio(BaseOptions(baseUrl: baseUrl, headers: headers));
    return ApiService._(dio);
  }

  static Future<String?> getToken(Ref ref) async {
    final session = await ref.watch(authSessionStream.future);
    return session?.accessToken;
  }
}
