import 'package:dio/dio.dart';

class ApiClient {
  static final dio = Dio(BaseOptions(baseUrl: 'http://10.0.2.2:3000'));
}
