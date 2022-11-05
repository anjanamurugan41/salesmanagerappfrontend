import 'package:dio/dio.dart';
import 'ServiceManagerInterceptors.dart';

class ApiProvider {
  Dio _dio;

  ApiProvider() {
    BaseOptions options;
    options = new BaseOptions(
      baseUrl: "",
      receiveTimeout: 50000, //50s
      connectTimeout: 50000,
    );

    _dio = Dio(options);
    _dio.interceptors.add(ServiceMangerInterceptors());
  }

  Dio getInstance() {
    _dio.options.headers.addAll({"Content-Type": "application/json"});
    return _dio;
  }

  Dio getMultipartInstance() {
    _dio.options.headers.addAll({"Content-Type": "multipart/form-data"});
    return _dio;
  }
}
