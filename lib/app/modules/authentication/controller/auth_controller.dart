// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';
import 'package:alsat/app/components/custom_snackbar.dart';
import 'package:alsat/app/modules/app_home/controller/home_controller.dart';
import 'package:alsat/app/modules/app_home/models/category_model.dart';
import 'package:alsat/app/modules/authentication/model/otp_model.dart';
import 'package:alsat/app/modules/authentication/model/user_data_model.dart';
import 'package:alsat/app/modules/authentication/model/varified_model.dart';
import 'package:alsat/app/modules/authentication/view/login_view.dart';
import 'package:alsat/app/modules/conversation/controller/conversation_controller.dart';
import 'package:alsat/app/modules/parent/view/onboarding_view.dart';
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
  Rx<VerifiedModel> verifiedModel = VerifiedModel().obs;
  Timer? verificationTimer; // Timer for periodic verification API calls
  Timer? resendOtpTimer; // Timer for 4-minute countdown for resending OTP
  RxInt countdown = 120.obs; // Countdown in seconds (4 minutes = 240 seconds)
  RxBool canResendOtp = false.obs; // Flag to control whether user can resend OTP
  RxBool hasStartedOtpProcess = false.obs; // Flag to check if OTP process has started

  //
  Rx<UserDataModel> userDataModel = UserDataModel().obs;
  RxBool isLoggedIn = false.obs;
  RxnString token = RxnString();

  @override
  void onInit() {
    checkLogin();
    super.onInit();
  }

  checkLogin() async {
    isLoggedIn.value = MySharedPref.isLoggedIn();
    token.value = MySharedPref.getAuthToken();
    if (isLoggedIn.value && (token.value ?? '').isNotEmpty) {
      await getProfile();
    }
    Future.delayed(
      const Duration(seconds: 1),
      () {
        // MySharedPref.clear();
        bool onboardingCompleted = MySharedPref.isOnboardingComplete();
        Logger().d(onboardingCompleted);
        bool isLoggedIn = MySharedPref.isLoggedIn();
        // Navigate based on onboarding and login status
        if (!onboardingCompleted && !isLoggedIn) {
          // If onboarding is not complete, navigate to OnboardingPage
          Get.offAll(() => const OnboardingPage());
        } else if (!isLoggedIn) {
          // If user is not logged in, navigate to FilterView (or login view)
          Get.offAll(() => const LoginView());
        } else {
          // If onboarding is completed and user is logged in, navigate to HomePage
          Get.offAll(() => const AppHomeView());
        }
      },
    );
  }

  getOtp({bool isFromHome = false}) async {
    isLoading.value = true;
    await BaseClient().safeApiCall(
      Constants.baseUrl + Constants.getOtp,
      DioRequestType.get,
      onLoading: () {},
      onSuccess: (response) async {
        otpData.value = OtpModel.fromJson(response.data);
        await smsConfirmation(phoneNumber: otpData.value.phone!, message: otpData.value.sms!, isFromHome: isFromHome);
        isLoading.value = false;
      },
      onError: (error) {
        Logger().d("$error <- error");
      },
    );
  }

  Future<void> sendSms(String phoneNumber, String message, {bool isFromHome = false}) async {
    final Uri smsUri = Uri(
      scheme: 'sms',

      //path: "+99365555109",
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
      startVerifyingNumber(isFromHome: isFromHome);
    } else {
      throw 'Could not send SMS';
    }
  }

  // Start the process to verify the number every 5 seconds
  startVerifyingNumber({bool isFromHome = false}) {
    verificationTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      verifyNumber(isFromHome: isFromHome);
    });
  }

  // Call the verify API periodically
  verifyNumber({bool isFromHome = false}) async {
    await BaseClient().safeApiCall(
      Constants.baseUrl + Constants.varifyOtp,
      DioRequestType.post,
      data: {
        "phone": phoneNumberController.value.text,
        "code": otpData.value.otp,
      },
      onLoading: () {},
      onSuccess: (response) async {
        verifiedModel.value = VerifiedModel.fromJson(response.data);
        verificationTimer?.cancel();
        await MySharedPref.setIsLoggedIn(true);
        await MySharedPref.setAuthToken(verifiedModel.value.token!);
        await MySharedPref.setAuthRefreshToken(verifiedModel.value.refreshToken!);
        token.value = verifiedModel.value.token;
        await getProfile();
        isLoading.value = false;
        isLoggedIn.value = true;

        Get.find<ConversationController>().authUserConversation();
        Get.find<HomeController>().authUserFeatureValue();

        if (isFromHome) {
          Get.back();
          Get.back();
        } else {
          Get.to(() => const AppHomeView());
        }
      },
      onError: (error) {
        Logger().d("$error <- error");
      },
    );
  }

  getProfile() async {
    await BaseClient().safeApiCall(
      Constants.baseUrl + Constants.userProfile,
      DioRequestType.get,
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
    await BaseClient().safeApiCall(
      Constants.baseUrl + Constants.fcmStore,
      DioRequestType.patch,
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
    await BaseClient().safeApiCall(
      Constants.baseUrl + Constants.updateProfilePicture,
      DioRequestType.put,
      headers: {
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

    await BaseClient().safeApiCall(
      Constants.baseUrl + Constants.user,
      DioRequestType.put,
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
                    localLanguage.delete_account,
                    style: Get.theme.textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  8.verticalSpace,
                  Text(
                    localLanguage.delete_account_confirmation,
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
                              await BaseClient().safeApiCall(
                                "${Constants.baseUrl}/users",
                                DioRequestType.delete,
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
    userDataModel.value = UserDataModel();
    MySharedPref.setAuthToken(null);
    MySharedPref.setIsLoggedIn(false);
    MySharedPref.setAuthRefreshToken(null);
    MySharedPref.setIsLoggedIn(false);

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
                      localLanguage.logout,
                      style: Get.theme.textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    8.verticalSpace,
                    Text(
                      localLanguage.logout_confirmation,
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
                                localLanguage.logout,
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
    await BaseClient().safeApiCall(
      "${Constants.baseUrl}/logout-devices",
      DioRequestType.post,
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
