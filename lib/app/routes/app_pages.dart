import 'package:alsat/app/modules/parent/view/splash_view.dart';
import 'package:get/get.dart';

import '../modules/filter/bindings/filter_binding.dart';
part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.INITIAL;

  static final routes = [
    GetPage(
      name: _Paths.INITIAL,
      page: () => const SplashView(),
      binding: FilterBinding(),
    ),
  ];
}
