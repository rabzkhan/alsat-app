import 'dart:async';
import 'dart:developer';
// import 'dart:developer';
import 'dart:io';
import 'package:alsat/app/services/data_cache_servise.dart';
import 'package:alsat/app/services/dio_interceptor.dart';
import 'package:alsat/utils/constants.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import 'package:logger/logger.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../components/custom_snackbar.dart';
import 'api_exceptions.dart';

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
    Function(int total, int progress)? onSendProgress, // while sending (uploading) progress
    Function? onLoading,
    dynamic data,
  }) async {
    try {
      if (isDataCache) {
        dynamic cacheData = await DataCacheService(apiEndPoint: url).getData();
        onCacheData?.call(cacheData);
      }
      await onLoading?.call();
      late Response response;
      if (requestType == DioRequestType.get) {
        response = await _dio.get(
          url,
          onReceiveProgress: onReceiveProgress,
          queryParameters: queryParameters,
          data: data,
          options: Options(
            headers: headers,
          ),
        );
        if (isDataCache) {
          DataCacheService(apiEndPoint: url).setData(response.data, expiryTimeMinute: cacheAgeInMinute);
        }
      } else if (requestType == DioRequestType.post) {
        Logger().d(data.toString());
        response = await _dio.post(
          url,
          data: data,
          onReceiveProgress: onReceiveProgress,
          onSendProgress: onSendProgress,
          queryParameters: queryParameters,
          options: Options(headers: headers),
        );
      } else if (requestType == DioRequestType.put) {
        response = await _dio.put(
          url,
          data: data,
          onReceiveProgress: onReceiveProgress,
          onSendProgress: onSendProgress,
          queryParameters: queryParameters,
          options: Options(headers: headers),
        );
      } else if (requestType == DioRequestType.patch) {
        response = await _dio.patch(
          url,
          data: data,
          onReceiveProgress: onReceiveProgress,
          onSendProgress: onSendProgress,
          queryParameters: queryParameters,
          options: Options(headers: headers),
        );
      } else if (requestType == DioRequestType.delete) {
        response = await _dio.delete(
          url,
          data: data,
          queryParameters: queryParameters,
          options: Options(headers: headers),
        );
      } else {
        throw Exception("Invalid request type");
      }
      await onSuccess(response);
    } on DioException catch (error) {
      log('error: $error');
      log('error: ${"${error.response?.data['message'] ?? error.message}"}');
      onError!(
        ConnectionException(
          url: error.requestOptions.path,
          message: "${error.response?.data['message'] ?? error.message}",
        ),
      );
    } on TimeoutException {
      onError!(ConnectionException(url: '', message: "Connection Timeout"));
    } catch (error, stackTrace) {
      onError!(ConnectionException(url: stackTrace.toString(), message: error.toString()));
    }
  }
}

class ConnectionException implements Exception {
  final String url;
  final String message;
  final int? statusCode;
  final Response? response;
  ConnectionException({required this.url, required this.message, this.response, this.statusCode});
  @override
  toString() {
    String result = '';
    result += response?.data?['error'] ??
        response?.data?['message'] ??
        response?.data?['result'] ??
        response?.data?['msg'] ??
        '';
    if (result.isEmpty) {
      result += message;
    }
    return result;
  }
}
