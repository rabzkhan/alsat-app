import 'package:alsat/app/modules/parent/controller/splash_controller.dart';
import 'package:get/get.dart';

import '../../modules/app_home/controller/home_controller.dart';
import '../../modules/authentication/controller/auth_controller.dart';
import '../../modules/filter/controllers/filter_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(() => SplashController());
    Get.lazyPut<AuthController>(() => AuthController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<FilterController>(() => FilterController());
  }
}
