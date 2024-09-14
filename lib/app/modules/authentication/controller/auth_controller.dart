import 'dart:async';
import 'package:alsat/app/modules/authentication/model/otp_model.dart';
import 'package:alsat/app/modules/authentication/model/varified_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../../../utils/constants.dart';
import '../../../services/base_client.dart';

class AuthController extends GetxController {
  final signUpFormKey = GlobalKey<FormBuilderState>();
  final loginFormKey = GlobalKey<FormBuilderState>();

  RxString countryCode = "880".obs;
  final phoneNumberController = TextEditingController().obs;

  Rx<OtpModel> otpData = OtpModel().obs;
  Rx<VarifiedModel> varifiedModel = VarifiedModel().obs;
  Timer? verificationTimer; // Timer for periodic verification API calls
  Timer? resendOtpTimer; // Timer for 4-minute countdown for resending OTP
  RxInt countdown = 240.obs; // Countdown in seconds (4 minutes = 240 seconds)
  RxBool canResendOtp = false.obs; // Flag to control whether user can resend OTP
  RxBool hasStartedOtpProcess = false.obs; // Flag to check if OTP process has started

  getOtp() async {
    hasStartedOtpProcess.value = true; // Mark the OTP process as started

    await BaseClient.safeApiCall(
      Constants.baseUrl + Constants.getOtp,
      RequestType.get,
      onLoading: () {},
      onSuccess: (response) async {
        otpData.value = OtpModel.fromJson(response.data);
        startOtpCountdown(); // Start the 4-minute countdown timer
        await triggerSendSms();
      },
      onError: (error) {
        Logger().d("$error <- error");
      },
    );
  }

  // Start the 4-minute countdown timer
  void startOtpCountdown() {
    canResendOtp.value = false; // Disable the resend OTP button
    countdown.value = 240; // Reset the countdown to 4 minutes

    resendOtpTimer?.cancel(); // Cancel any existing timer before starting a new one
    resendOtpTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (countdown.value > 0) {
        countdown.value--; // Decrease countdown by 1 second
      } else {
        canResendOtp.value = true; // Enable resend OTP button after 4 minutes
        resendOtpTimer?.cancel(); // Stop the timer
      }
    });
  }

  // Method to trigger phone number verification
  triggerSendSms() async {
    startVerifyingNumber(); // Start verifying the phone number periodically
  }

  // Start the process to verify the number every 10 seconds
  startVerifyingNumber() {
    verificationTimer = Timer.periodic(Duration(seconds: 10), (timer) {
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
        varifiedModel.value = VarifiedModel.fromJson(response.data);

        // If verification is successful, stop further API calls
        verificationTimer?.cancel(); // Stop periodic verification
        Logger().d("Verification successful!");
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
