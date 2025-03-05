import 'package:alsat/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:toastification/toastification.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomSnackBar {
  static showCustomSnackBar(
      {required String title, required String message, Duration? duration}) {
    Get.snackbar(
      title,
      message,
      duration: duration ?? const Duration(seconds: 3),
      margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
      colorText: Colors.white,
      backgroundColor: Colors.green,
      icon: const Icon(
        Icons.check_circle,
        color: Colors.white,
      ),
    );
  }

  static showCustomErrorSnackBar(
      {required String title,
      required String message,
      Color? color,
      Duration? duration}) {
    Get.snackbar(
      title,
      message,
      duration: duration ?? const Duration(seconds: 3),
      margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
      colorText: Colors.white,
      backgroundColor: color ?? Colors.redAccent,
      icon: const Icon(
        Icons.error,
        color: Colors.white,
      ),
    );
  }

  static showCustomToast(
      {String? title,
      required String message,
      Color? color,
      Duration? duration}) {
    final localLanguage = AppLocalizations.of(Get.context!)!;

    toastification.show(
      backgroundColor: color ?? AppColors.primary,
      primaryColor: Colors.white,
      context: Get.context!,
      type: ToastificationType.success,
      style: ToastificationStyle.flat,
      progressBarTheme: const ProgressIndicatorThemeData(
        color: Colors.white,
      ),
      title: Text(
        title ?? localLanguage.alert_information,
        style: TextStyle(
          color: Colors.white,
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
      description: Text(
        message,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w400,
          fontSize: 15.sp,
        ),
      ),
      alignment: Alignment.bottomCenter,
      autoCloseDuration: duration ?? const Duration(seconds: 3),
      icon: const Icon(Icons.check_circle),
      borderRadius: BorderRadius.circular(12.0),
      boxShadow: highModeShadow,
      showProgressBar: false,
      dragToClose: true,
    );
  }

  static showCustomErrorToast(
      {String? title,
      required String message,
      Color? color,
      Duration? duration}) {
    Get.rawSnackbar(
      title: title,
      duration: duration ?? const Duration(seconds: 3),
      snackStyle: SnackStyle.GROUNDED,
      backgroundColor: color ?? Colors.redAccent,
      onTap: (snack) {
        Get.closeAllSnackbars();
      },
      //overlayBlur: 0.8,
      message: message,
    );
  }
}
