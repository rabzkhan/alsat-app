import 'dart:async';
import 'dart:developer';
import 'package:alsat/app/services/data_cache_servise.dart';
import 'package:alsat/app/services/dio_interceptor.dart';
import 'package:alsat/utils/constants.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

enum DioRequestType {
  get,
  post,
  put,
  delete,
  patch,
}

class BaseClient {
  late Dio _dio;

  BaseClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: Constants.baseUrl,
        connectTimeout: const Duration(minutes: 2),
        receiveTimeout: const Duration(minutes: 2),
      ),
    );
    _dio.interceptors.add(DioInterceptor(_dio));
  }

  safeApiCall(
    String url,
    DioRequestType requestType, {
    Map<String, dynamic>? headers,
    bool isDataCache = false,
    int cacheAgeInMinute = 60,
    Map<String, dynamic>? queryParameters,
    required Function(Response response) onSuccess,
    Function(ConnectionException)? onError,
    Function(dynamic data)? onCacheData,
    Function(int value, int progress)? onReceiveProgress,
    Function(int total, int progress)? onSendProgress,
    Function? onLoading,
    dynamic data,
  }) async {
    Logger().d("url is: $url");

    try {
      if (isDataCache) {
        dynamic cacheData = await DataCacheService(apiEndPoint: url).getData();
        onCacheData?.call(cacheData);
      }

      await onLoading?.call();
      late Response response;

      switch (requestType) {
        case DioRequestType.get:
          response = await _dio.get(
            url,
            data: data,
            queryParameters: queryParameters,
            onReceiveProgress: onReceiveProgress,
            options: Options(headers: headers),
          );
          if (isDataCache) {
            DataCacheService(apiEndPoint: url)
                .setData(response.data, expiryTimeMinute: cacheAgeInMinute);
          }
          break;

        case DioRequestType.post:
          Logger().d(data.toString());
          response = await _dio.post(
            url,
            data: data,
            queryParameters: queryParameters,
            onReceiveProgress: onReceiveProgress,
            onSendProgress: onSendProgress,
            options: Options(headers: headers),
          );
          break;

        case DioRequestType.put:
          response = await _dio.put(
            url,
            data: data,
            queryParameters: queryParameters,
            onReceiveProgress: onReceiveProgress,
            onSendProgress: onSendProgress,
            options: Options(headers: headers),
          );
          break;

        case DioRequestType.patch:
          response = await _dio.patch(
            url,
            data: data,
            queryParameters: queryParameters,
            onReceiveProgress: onReceiveProgress,
            onSendProgress: onSendProgress,
            options: Options(headers: headers),
          );
          break;

        case DioRequestType.delete:
          response = await _dio.delete(
            url,
            data: data,
            queryParameters: queryParameters,
            options: Options(headers: headers),
          );
          break;

        default:
          throw Exception("Invalid request type");
      }

      onSuccess(response);
    } on DioException catch (error) {
      final res = error.response;

      log('🔗 URL: ${error.requestOptions.uri}');
      log('📡 Status Code: ${res?.statusCode}');
      log('📨 Response Data: ${res?.data}');
      // log('📄 Headers: ${res?.headers}');
      // log('📛 Error Type: ${error.type}');
      // log('📝 Error Message: ${error.message}');

      String errorMessage = '';
      if (res?.data is Map) {
        errorMessage = res?.data['message'] ??
            res?.data['error'] ??
            res?.data['msg'] ??
            'Unknown error occurred';
      } else if (res?.data is String) {
        errorMessage = res?.data;
      } else {
        errorMessage = error.message ?? 'Unexpected error';
      }

      onError?.call(
        ConnectionException(
          url: error.requestOptions.path,
          message: errorMessage,
          response: res,
          statusCode: res?.statusCode,
        ),
      );
    } on TimeoutException {
      onError
          ?.call(ConnectionException(url: url, message: "Connection Timeout"));
    } catch (error, stackTrace) {
      onError?.call(ConnectionException(
          url: stackTrace.toString(), message: error.toString()));
    }
  }
}

class ConnectionException implements Exception {
  final String url;
  final String message;
  final int? statusCode;
  final Response? response;

  ConnectionException({
    required this.url,
    required this.message,
    this.response,
    this.statusCode,
  });

  @override
  String toString() {
    try {
      if (response?.data != null) {
        if (response!.data is Map) {
          return response!.data['error'] ??
              response!.data['message'] ??
              response!.data['msg'] ??
              response!.data['result'] ?? // 👈 Add this line
              message;
        } else if (response!.data is String) {
          return response!.data;
        }
      }
    } catch (_) {
      // Fall back to message
    }
    return message;
  }
}
