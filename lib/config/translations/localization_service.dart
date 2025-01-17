import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/data/local/my_shared_pref.dart';

class LocalizationService extends GetxController {
  Rx<Locale> locale = Rx(MySharedPref.getCurrentLocal());

  void changeLocale(Locale locale) {
    this.locale.value = locale;
    Get.updateLocale(locale);
    MySharedPref.setCurrentLanguage(locale.languageCode);
    update();
  }
}
