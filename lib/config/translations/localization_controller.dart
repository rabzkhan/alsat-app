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

  List<String> getTranslatedBodyTypes(List<String> originalList) {
    final langCode = locale.value.languageCode;
    return originalList.map((type) {
      return bodyTypeTranslations[type]?[langCode] ?? type;
    }).toList();
  }

  List<String> getTranslatedTransmissionTypes(List<String> originalList) {
    final langCode = locale.value.languageCode;
    return originalList.map((type) {
      return transmissionTranslations[type]?[langCode] ?? type;
    }).toList();
  }

  String getTranslatedTransmission(String inputValue) {
    final langCode = locale.value.languageCode;
    for (final entry in transmissionTranslations.entries) {
      final translations = entry.value;
      // If the input matches any of the translations
      if (translations.containsValue(inputValue)) {
        // Return the translation in the desired language
        return translations[langCode] ?? entry.key;
      }
    }

    // If not found, return the input as is
    return inputValue;
  }

  String getColorNameTranslated(String colorName) {
    final langCode = locale.value.languageCode;
    if (colorTranslations.containsKey(colorName)) {
      return colorTranslations[colorName]?[langCode] ?? colorName;
    }
    return colorName; // fallback to English if translation not found
  }
}
