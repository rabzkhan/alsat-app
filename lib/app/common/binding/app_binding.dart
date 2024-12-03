import 'package:alsat/app/modules/conversation/controller/conversation_controller.dart';
import 'package:alsat/app/modules/parent/controller/splash_controller.dart';
import 'package:get/get.dart';

import '../../modules/app_home/controller/home_controller.dart';
import '../../modules/auth_user/controller/user_controller.dart';
import '../../modules/authentication/controller/auth_controller.dart';
import '../../modules/filter/controllers/filter_controller.dart';
import '../../modules/product/controller/product_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController());
    Get.put(ProductController());
    Get.put(FilterController());
    Get.lazyPut<SplashController>(() => SplashController());
    //Get.lazyPut<AuthController>(() => AuthController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<UserController>(() => UserController());
    Get.lazyPut<ProductController>(() => ProductController());
    Get.lazyPut<ConversationController>(() => ConversationController());
  }
}
