import 'package:dio/dio.dart';
import '../../utils/app_constant.dart';

class ApiClient {
  final Dio _dio;

  ApiClient._internal()
    : _dio = Dio(
        BaseOptions(
          baseUrl: AppConstant.baseUrl,
          connectTimeout: const Duration(seconds: 60),
          receiveTimeout: const Duration(seconds: 60),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;

  // Global GET
  Future<Response> get(String path, {Map<String, dynamic>? query}) async {
    try {
      final response = await _dio.get(path, queryParameters: query);
      return response;
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    }
  }

  // Global POST
  Future<Response> post(String path, {Map<String, dynamic>? data}) async {
    try {
      final response = await _dio.post(path, data: data);
      return response;
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    }
  }

  // Global PUT
  Future<Response> put(String path, {Map<String, dynamic>? data}) async {
    try {
      final response = await _dio.put(path, data: data);
      return response;
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    }
  }

  // Global DELETE
  Future<Response> delete(String path) async {
    try {
      final response = await _dio.delete(path);
      return response;
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    }
  }

  // Error Handler
  String _handleError(DioException error) {
    if (error.response != null) {
      return error.response?.data['message'] ?? 'Unknown Error';
    } else if (error.type == DioExceptionType.connectionTimeout) {
      return 'Connection timeout';
    } else if (error.type == DioExceptionType.receiveTimeout) {
      return 'Receive timeout';
    } else {
      return 'Unexpected error occurred';
    }
  }
}
