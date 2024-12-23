import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

void showLoading() {
  Get.dialog(
    Center(
      child: loadingWidget(),
    ),
    barrierDismissible: true,
  );
}

Widget loadingWidget({double? size}) {
  return CupertinoActivityIndicator(
    color: Get.theme.scaffoldBackgroundColor,
  );
}
