import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'app/data/local/my_shared_pref.dart';
import 'app/routes/app_pages.dart';
import 'config/theme/app_theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<void> main() async {
  // wait for bindings
  WidgetsFlutterBinding.ensureInitialized();
  // init shared preference
  await MySharedPref.init();

  runApp(
    ScreenUtilInit(
      designSize: const Size(392, 835),
      minTextAdapt: true,
      splitScreenMode: true,
      useInheritedMediaQuery: true,
      rebuildFactor: (old, data) => true,
      builder: (context, widget) {
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
            theme: appTheme(),
            // locale: MySharedPref.getCurrentLocal(),
            // translations: LocalizationService.getInstance(),
            locale: Get.deviceLocale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'), // English
            ]);
      },
    ),
  );
}
