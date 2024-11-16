import 'dart:async';
import 'dart:developer';
import 'package:alsat/app/modules/authentication/model/otp_model.dart';
import 'package:alsat/app/modules/authentication/model/user_data_model.dart';
import 'package:alsat/app/modules/authentication/model/varified_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../utils/constants.dart';
import '../../../data/local/my_shared_pref.dart';
import '../../../services/base_client.dart';
import '../../app_home/view/app_home_view.dart';

class AuthController extends GetxController {
  final signUpFormKey = GlobalKey<FormBuilderState>();
  final loginFormKey = GlobalKey<FormBuilderState>();

  RxString countryCode = "+993".obs;
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
        await triggerSendSms();
      },
      onError: (error) {
        Logger().d("$error <- error");
      },
    );
  }

  // Start the 4-minute countdown timer
  void startOtpCountdown() {
    canResendOtp.value = false;
    countdown.value = 120;
    resendOtpTimer?.cancel();
    resendOtpTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown.value > 0) {
        countdown.value--;
      } else {
        canResendOtp.value = true;
        resendOtpTimer?.cancel();
      }
    });
  }

  // Method to trigger phone number verification
  triggerSendSms() async {
    await sendSms(otpData.value.phone!, otpData.value.sms!);
    //startOtpCountdown(); // Start the 4-minute countdown timer
  }

  // Method to send an SMS using flutter_sms

  Future<void> sendSms(String phoneNumber, String message) async {
    // Show confirmation dialog
    bool? sendSmsConfirmation = await showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: Text(
              'We are going to send an SMS to $phoneNumber. Do you want to proceed?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Cancel sending SMS
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Confirm sending SMS
              },
              child: const Text('Proceed'),
            ),
          ],
        );
      },
    );

    // If the user confirmed, send the SMS
    if (sendSmsConfirmation == true) {
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
        userDataModel.value = UserDataModel.fromJson(response.data);
      },
      onError: (error) {
        Logger().d("$error <- error");
      },
    );
  }

  @override
  void onClose() {
    verificationTimer?.cancel(); // Clean up the verification timer
    resendOtpTimer?.cancel();
    // Clean up the resend OTP timer
    super.onClose();
  }
}
