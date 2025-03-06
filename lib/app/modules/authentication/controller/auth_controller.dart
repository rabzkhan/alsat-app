// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';
import 'package:alsat/app/components/custom_snackbar.dart';
import 'package:alsat/app/modules/app_home/models/category_model.dart';
import 'package:alsat/app/modules/authentication/model/otp_model.dart';
import 'package:alsat/app/modules/authentication/model/user_data_model.dart';
import 'package:alsat/app/modules/authentication/model/varified_model.dart';
import 'package:alsat/app/modules/authentication/view/login_view.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restart_app/restart_app.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../config/theme/app_text_theme.dart';
import '../../../../utils/constants.dart';
import '../../../data/local/my_shared_pref.dart';
import '../../../services/base_client.dart';
import '../../app_home/view/app_home_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
  RxBool canResendOtp = false.obs; // Flag to control whether user can resend OTP
  RxBool hasStartedOtpProcess = false.obs; // Flag to check if OTP process has started

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
        await smsConfirmation(phoneNumber: otpData.value.phone!, message: otpData.value.sms!);
        isLoading.value = false;
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
        Logger().d("Verification successful! and the token is ${varifiedModel.value.token!}");
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
        if (addressController.text.isEmpty) {
          addressController.text =
              "${userDataModel.value.location?.province ?? ''}, ${userDataModel.value.location?.city ?? ""}";
        }
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
  RxBool isUpdateLoading = false.obs;

  updateUserInformation({required Map<String, dynamic> data}) async {
    final localLanguage = AppLocalizations.of(Get.context!)!;

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
        CustomSnackBar.showCustomToast(message: localLanguage.updated_successfully);
      },
      onError: (error) {
        isUpdateLoading.value = false;
        CustomSnackBar.showCustomErrorToast(message: localLanguage.something_went_wrong);
        log('profile $error <- error');
        Logger().d("$error <- error");
      },
    );
  }

  RxBool isDeletingAccount = false.obs;

  Future<void> deleteUserAccount() async {
    final localLanguage = AppLocalizations.of(Get.context!)!;
    Get.dialog(
      Center(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.h),
            margin: EdgeInsets.symmetric(horizontal: Get.width * 0.06),
            width: Get.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20).r,
              color: Colors.white,
            ),
            child: Material(
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  10.verticalSpace,
                  Text(
                    "Delete Account?",
                    style: Get.theme.textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  8.verticalSpace,
                  Text(
                    "Are you sure you want to delete your account ?",
                    textAlign: TextAlign.center,
                    style: Theme.of(Get.context!).textTheme.bodyMedium!.copyWith(),
                  ),
                  20.verticalSpace,
                  SizedBox(
                    height: 40.h,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Get.theme.primaryColor.withOpacity(.1),
                              side: BorderSide(
                                color: Get.theme.primaryColor,
                                width: 1,
                              ),
                              fixedSize: const Size.fromHeight(48),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                            ),
                            child: Text(
                              localLanguage.cancel,
                              style: regular.copyWith(
                                color: Get.theme.primaryColor,
                              ),
                            ),
                            onPressed: () {
                              Get.back();
                            },
                          ),
                        ),
                        10.horizontalSpace,
                        Expanded(
                          flex: 3,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              fixedSize: const Size.fromHeight(48),
                              backgroundColor: Get.theme.primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                            ),
                            onPressed: () async {
                              Get.back();
                              isDeletingAccount.value = true;
                              await BaseClient.safeApiCall(
                                "${Constants.baseUrl}/users",
                                DioRequestType.delete,
                                headers: {
                                  'Authorization': Constants.token,
                                },
                                onSuccess: (response) async {
                                  await userLogOut();
                                  Restart.restartApp(
                                    notificationTitle: 'Restarting App',
                                    notificationBody: 'Please tap here to open the app again.',
                                  );
                                  isDeletingAccount.value = false;
                                },
                                onError: (error) {
                                  log('Failed to delete account: $error');
                                  isDeletingAccount.value = false;
                                },
                              );
                            },
                            child: Text(
                              localLanguage.delete,
                              style: regular.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> userLogOut({bool isShowDialog = false}) async {
    await MySharedPref.setIsLoggedIn(false);
    await MySharedPref.clear();
    await logoutDevices(isShowDialog: isShowDialog);
  }

  RxBool isLoggingOutDevices = false.obs;

  Future<void> logoutDevices({bool isShowDialog = true}) async {
    final localLanguage = AppLocalizations.of(Get.context!)!;
    if (isShowDialog) {
      Get.dialog(
        Center(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.h),
              margin: EdgeInsets.symmetric(horizontal: Get.width * 0.06),
              width: Get.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20).r,
                color: Colors.white,
              ),
              child: Material(
                color: Colors.white,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    10.verticalSpace,
                    Text(
                      "Logout",
                      style: Get.theme.textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    8.verticalSpace,
                    Text(
                      "Are you sure you want to logout from all devices ?",
                      textAlign: TextAlign.center,
                      style: Theme.of(Get.context!).textTheme.bodyMedium!.copyWith(),
                    ),
                    20.verticalSpace,
                    SizedBox(
                      height: 40.h,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                backgroundColor: Get.theme.primaryColor.withOpacity(.1),
                                side: BorderSide(
                                  color: Get.theme.primaryColor,
                                  width: 1,
                                ),
                                fixedSize: const Size.fromHeight(48),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                              ),
                              child: Text(
                                localLanguage.cancel,
                                style: regular.copyWith(
                                  color: Get.theme.primaryColor,
                                ),
                              ),
                              onPressed: () {
                                Get.back();
                              },
                            ),
                          ),
                          10.horizontalSpace,
                          Expanded(
                            flex: 3,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                fixedSize: const Size.fromHeight(48),
                                backgroundColor: Get.theme.primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                              ),
                              onPressed: () async {
                                Get.back();
                                await _performLogoutDevices();
                              },
                              child: Text(
                                "Logout",
                                style: regular.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      await _performLogoutDevices();
    }
  }

  Future<void> _performLogoutDevices() async {
    isLoggingOutDevices.value = true;
    await BaseClient.safeApiCall(
      "${Constants.baseUrl}/logout-devices",
      DioRequestType.post,
      headers: {
        'Authorization': Constants.token,
      },
      onSuccess: (response) {
        log('Logged out from all devices successfully');
        Get.offAll(() => LoginView());
        isLoggingOutDevices.value = false;
        return;
      },
      onError: (error) {
        log('Failed to logout from devices: $error');
        isLoggingOutDevices.value = false;
        return;
      },
    );
  }
}
