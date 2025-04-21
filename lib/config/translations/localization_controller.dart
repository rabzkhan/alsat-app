import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../app/data/local/my_shared_pref.dart';
import '../../app/modules/app_home/controller/home_controller.dart';
import '../../utils/translations.dart';

class LocalizationController extends GetxController {
  Rx<Locale> locale = Rx(MySharedPref.getCurrentLocal());

  void changeLocale(Locale locale) {
    this.locale.value = locale;
    Get.updateLocale(locale);
    MySharedPref.setCurrentLanguage(locale.languageCode);
    Get.find<HomeController>().getCategories();
    update();
  }

  late AppLocalizations localLanguage;

  String translateName(String name, Map<String, Map<String, String>> translations) {
    update();
    return translations[name]?[locale.value.languageCode] ?? name;
  }
}
