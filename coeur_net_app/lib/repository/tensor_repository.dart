import 'package:dio/dio.dart';

class TensorRepository {
  final Dio client;

  const TensorRepository({required this.client});

  Future<List<double>> getTensor() async {
    final response = await client.get("tensor");

    final jsonList = List.of(response.data);

    return jsonList.map((e) => (e as num).toDouble()).toList();
  }
}
