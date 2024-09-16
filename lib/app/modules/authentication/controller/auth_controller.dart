import 'dart:async';
import 'package:alsat/app/modules/authentication/model/otp_model.dart';
import 'package:alsat/app/modules/authentication/model/varified_model.dart';
import 'package:background_sms/background_sms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';

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
  RxBool canResendOtp = false.obs; // Flag to control whether user can resend OTP
  RxBool hasStartedOtpProcess = false.obs; // Flag to check if OTP process has started

  // Method to request SMS permission
  Future<void> requestSmsPermission() async {
    var status = await Permission.sms.status;
    if (!status.isGranted) {
      // Request permission
      var result = await Permission.sms.request();
      if (result.isGranted) {
        // Permission granted
        getOtp();
      } else {
        // Permission denied
        // Ask for manual permission
        Get.snackbar("SMS Permission", "Please enable sms permission");
      }
    } else {
      // Permission already granted
      getOtp();
    }
  }

  getOtp() async {
    isLoading.value = true;
    hasStartedOtpProcess.value = true;
    await BaseClient.safeApiCall(
      Constants.baseUrl + Constants.getOtp,
      RequestType.get,
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
    await sendSms(phoneNumberController.value.text, otpData.value.sms!);
    startOtpCountdown(); // Start the 4-minute countdown timer
    startVerifyingNumber();
  }

  // Method to send an SMS using flutter_sms
  Future<void> sendSms(String phoneNumber, String message) async {
    SmsStatus result = await BackgroundSms.sendMessage(
      phoneNumber: "65555109",
      message: message,
    );

    if (result == SmsStatus.sent) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(content: Text('SMS sent successfully')),
      );
    } else if (result == SmsStatus.failed) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(content: Text('Failed to send SMS')),
      );
    } else {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(content: Text('Unknown status')),
      );
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
      RequestType.post,
      data: {
        "phone": phoneNumberController.value.text,
        "code": otpData.value.otp,
      },
      onLoading: () {},
      onSuccess: (response) async {
        isLoading.value = false;
        varifiedModel.value = VarifiedModel.fromJson(response.data);
        // If verification is successful, stop further API calls
        verificationTimer?.cancel(); // Stop periodic verification
        await MySharedPref.setIsLoggedIn(true); // Set user as logged in
        await MySharedPref.setAuthToken(varifiedModel.value.token!);
        Logger().d("Verification successful!");
        Get.to(() => const AppHomeView());
      },
      onError: (error) {
        Logger().d("$error <- error");
      },
    );
  }

  @override
  void onClose() {
    verificationTimer?.cancel(); // Clean up the verification timer
    resendOtpTimer?.cancel(); // Clean up the resend OTP timer
    super.onClose();
  }
}
