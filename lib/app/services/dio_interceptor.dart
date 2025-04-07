import 'package:alsat/app/data/local/my_shared_pref.dart';
import 'package:alsat/app/modules/authentication/controller/auth_controller.dart';
import 'package:alsat/app/modules/authentication/model/varified_model.dart';
import 'package:alsat/utils/constants.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class DioInterceptor extends Interceptor {
  final Dio dio;

  DioInterceptor(this.dio);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      try {
        String? accessToken = await _refreshToken();
        if (accessToken != null) {
          err.requestOptions.headers["Authorization"] = "Bearer $accessToken";
          final options = Options(
              method: err.requestOptions.method,
              headers: err.requestOptions.headers);
          final retryResponse = await dio.request(
            err.requestOptions.path,
            options: options,
            data: err.requestOptions.data,
            queryParameters: err.requestOptions.queryParameters,
          );
          return handler.resolve(retryResponse);
        } else {
          AuthController authController = Get.find();
          authController.userLogOut();
          return handler.reject(err);
        }
      } catch (e) {
        return handler.reject(err);
      }
    }
    super.onError(err, handler);
  }

  Future<String?> _refreshToken() async {
    try {
      final token = MySharedPref.getAuthRefreshToken();
      final response = await Dio().post(
        Constants.baseUrl + Constants.refreshToken,
        data: {
          "refresh-token": token,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
      if (response.statusCode == 200) {
        AuthController authController = Get.find();
        authController.verifiedModel.value =
            VerifiedModel.fromJson(response.data);
        await MySharedPref.setAuthToken(
            authController.verifiedModel.value.token!);
        await MySharedPref.setAuthRefreshToken(
            authController.verifiedModel.value.refreshToken!);
        authController.token.value = authController.verifiedModel.value.token;
        ;
        return authController.verifiedModel.value.token;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final token = MySharedPref.getAuthToken();
    if (token != null && token.isNotEmpty) {
      options.headers["Authorization"] = "Bearer $token";
    }
    options.headers['Content-Type'] = 'application/json';
    options.headers['Accept'] = 'application/json';
    super.onRequest(options, handler);
  }
}
