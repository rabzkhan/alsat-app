import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:alsat/app/modules/app_home/models/category_model.dart';
import 'package:alsat/app/modules/authentication/model/otp_model.dart';
import 'package:alsat/app/modules/authentication/model/user_data_model.dart';
import 'package:alsat/app/modules/authentication/model/varified_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../utils/constants.dart';
import '../../../data/local/my_shared_pref.dart';
import '../../../services/base_client.dart';
import '../../app_home/view/app_home_view.dart';
import '../widgets/sms_confirmation.dart';

class AuthController extends GetxController {
  final signUpFormKey = GlobalKey<FormBuilderState>();
  final loginFormKey = GlobalKey<FormBuilderState>();

  RxString countryCode = "+88".obs;
  final phoneNumberController = TextEditingController().obs;

  RxBool isLoading = false.obs;

  Rx<OtpModel> otpData = OtpModel().obs;
  Rx<VarifiedModel> varifiedModel = VarifiedModel().obs;
  Timer? verificationTimer; // Timer for periodic verification API calls
  Timer? resendOtpTimer; // Timer for 4-minute countdown for resending OTP
  RxInt countdown = 120.obs; // Countdown in seconds (4 minutes = 240 seconds)
  RxBool canResendOtp =
      false.obs; // Flag to control whether user can resend OTP
  RxBool hasStartedOtpProcess =
      false.obs; // Flag to check if OTP process has started

  //
  Rx<UserDataModel> userDataModel = UserDataModel().obs;

  @override
  void onInit() {
    log('onInit AuthController ${MySharedPref.isLoggedIn()}');
    // if (MySharedPref.isLoggedIn()) {
    getProfile();
    // }
    super.onInit();
  }

  getOtp() async {
    isLoading.value = true;
    await BaseClient.safeApiCall(
      Constants.baseUrl + Constants.getOtp,
      DioRequestType.get,
      onLoading: () {},
      onSuccess: (response) async {
        otpData.value = OtpModel.fromJson(response.data);
        await smsConfirmation(
            phoneNumber: otpData.value.phone!, message: otpData.value.sms!);
      },
      onError: (error) {
        Logger().d("$error <- error");
      },
    );
  }

  Future<void> sendSms(String phoneNumber, String message) async {
    final Uri smsUri = Uri(
      scheme: 'sms',
      //path: "365555109",
      path: "01701034287",
      queryParameters: <String, String>{
        'body': message,
      },
    );
    if (await canLaunchUrl(smsUri)) {
      await launchUrl(
        smsUri,
        mode: LaunchMode.externalApplication,
      );
      startVerifyingNumber();
    } else {
      throw 'Could not send SMS';
    }
  }

  // Start the process to verify the number every 5 seconds
  startVerifyingNumber() {
    verificationTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      varifyNumber();
    });
  }

  // Call the verify API periodically
  varifyNumber() async {
    await BaseClient.safeApiCall(
      Constants.baseUrl + Constants.varifyOtp,
      DioRequestType.post,
      data: {
        "phone": phoneNumberController.value.text,
        "code": otpData.value.otp,
      },
      onLoading: () {},
      onSuccess: (response) async {
        isLoading.value = false;
        varifiedModel.value = VarifiedModel.fromJson(response.data);
        log("message:${response.data}");
        // If verification is successful, stop further API calls
        verificationTimer?.cancel(); // Stop periodic verification
        await MySharedPref.setIsLoggedIn(true); // Set user as logged in
        await MySharedPref.setAuthToken(varifiedModel.value.token!);
        Logger().d(
            "Verification successful! and the token is ${varifiedModel.value.token!}");
        getProfile();
        Get.to(() => const AppHomeView());
      },
      onError: (error) {
        Logger().d("$error <- error");
      },
    );
  }

  getProfile() async {
    await BaseClient.safeApiCall(
      Constants.baseUrl + Constants.userProfile,
      DioRequestType.get,
      headers: {
        // 'Authorization': 'Bearer ${MySharedPref.getAuthToken().toString()}',
        'Authorization': Constants.token,
      },
      onLoading: () {},
      onSuccess: (response) async {
        UserDataModel? user = UserDataModel.fromJson(response.data);
        userDataModel.value = user;
        log('login User Info --- :${userDataModel.value.id}');
        if (user.active == true) {
          saveFcmToken();
        }
      },
      onError: (error) {
        log('profile $error <- error');
        Logger().d("$error <- error");
      },
    );
  }

  //-- save fcm token to server --//
  saveFcmToken() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    log('fcmTokenStore: $fcmToken');
    await BaseClient.safeApiCall(
      Constants.baseUrl + Constants.fcmStore,
      DioRequestType.patch,
      headers: {
        // 'Authorization': 'Bearer ${MySharedPref.getAuthToken().toString()}',
        'Authorization': Constants.token,
      },
      data: {
        "device": fcmToken,
      },
      onLoading: () {},
      onSuccess: (response) async {},
      onError: (error) {
        Logger().d("$error <- error");
      },
    );
  }

  RxBool isProfilePictureLoading = RxBool(false);

  updateProfilePicture(File pickedFile) async {
    // Prepare the URL with query parameter
    List<int> fileBytes = await pickedFile.readAsBytes();
    await BaseClient.safeApiCall(
      Constants.baseUrl + Constants.updateProfilePicture,
      DioRequestType.put,
      headers: {
        // 'Authorization': 'Bearer ${MySharedPref.getAuthToken().toString()}',
        'Authorization': Constants.token,
        'Content-Type': 'application/octet-stream',
      },
      data: fileBytes,
      onLoading: () {
        isProfilePictureLoading.value = true;
      },
      onSuccess: (response) async {
        getProfile();
        isProfilePictureLoading.value = false;
      },
      onError: (error) {
        isProfilePictureLoading.value = false;
        log('profile $error <- error');
        Logger().d("$error <- error");
      },
    );
  }

  //-- upgrate user info --//
  RxList<CategoriesModel> selectUserCategoriesList = <CategoriesModel>[].obs;
  TextEditingController addressController = TextEditingController();
  // RxString for selected province
  RxString selectedProvince = "".obs;
  // RxString for selected city
  RxString selectedCity = "".obs;
  RxBool isUpdateLoading = false.obs;

  updateUserInformation({required Map<String, dynamic> data}) async {
    await BaseClient.safeApiCall(
      Constants.baseUrl + Constants.user,
      DioRequestType.put,
      headers: {
        // 'Authorization': 'Bearer ${MySharedPref.getAuthToken().toString()}',
        'Authorization': Constants.token,
      },
      data: data,
      onLoading: () {
        isUpdateLoading.value = true;
      },
      onSuccess: (response) async {
        getProfile();
        isUpdateLoading.value = false;
      },
      onError: (error) {
        isUpdateLoading.value = false;
        log('profile $error <- error');
        Logger().d("$error <- error");
      },
    );
  }
}
