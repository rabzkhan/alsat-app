import 'dart:developer';

import 'package:alsat/app/common/binding/app_binding.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:toastification/toastification.dart';
import 'app/data/local/my_shared_pref.dart';
import 'app/routes/app_pages.dart';
import 'app/services/firebase_messaging_services.dart';
import 'config/theme/app_theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'config/translations/localization_service.dart';
import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  log("Handling a background message: ${message.notification!.toMap()}");
  log("Handling a background message: ${message.data}");
}

Future<void> main() async {
  // wait for bindings
  WidgetsFlutterBinding.ensureInitialized();
  //-- firebase init --//
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
    name: "alsat",
  );
  // init shared preference
  await MySharedPref.init();
  FirebaseMessagingService();
  runApp(
    ScreenUtilInit(
      designSize: const Size(392, 835),
      minTextAdapt: true,
      splitScreenMode: true,
      useInheritedMediaQuery: true,
      rebuildFactor: (old, data) => true,
      builder: (context, widget) {
        LocalizationService localizationService = Get.put(LocalizationService());

        return ToastificationWrapper(
          child: Obx(() {
            return GetMaterialApp(
              title: "ALSAT",
              useInheritedMediaQuery: true,
              debugShowCheckedModeBanner: false,
              builder: (context, widget) {
                return Theme(
                  data: appTheme(),
                  child: MediaQuery(
                    data: MediaQuery.of(context).copyWith(
                      textScaler: const TextScaler.linear(1.0),
                    ),
                    child: widget!,
                  ),
                );
              },
              initialRoute: AppPages.INITIAL,
              getPages: AppPages.routes,
              themeMode: ThemeMode.light,
              // home: const OnboardingPage(),

              initialBinding: AppBinding(),
              theme: appTheme(),
              locale: Locale(localizationService.locale.value.languageCode),
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate
              ],
              supportedLocales: const [
                Locale('en'),
                Locale('tr'),
                Locale('ru'),
              ],
            );
          }),
        );
      },
    ),
  );
}
