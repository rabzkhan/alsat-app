import 'package:alsat/app/common/const/image_path.dart';
import 'package:alsat/app/components/app_drawer.dart';
import 'package:alsat/app/components/bottom_navigation_bar.dart';
import 'package:alsat/app/components/custom_appbar.dart';
import 'package:alsat/app/modules/app_home/component/add_post_content.dart';
import 'package:alsat/app/modules/app_home/component/category_content.dart';
import 'package:alsat/app/modules/app_home/component/chat_content.dart';
import 'package:alsat/app/modules/app_home/component/home_content.dart';
import 'package:alsat/app/modules/filter/controllers/filter_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../config/theme/app_text_theme.dart';
import '../../auth_user/controller/user_controller.dart';
import '../../filter/views/search_view.dart';
import '../../product/controller/product_controller.dart';
import '../component/profile_content.dart';
import '../controller/home_controller.dart';

class AppHomeView extends StatefulWidget {
  const AppHomeView({super.key});

  @override
  State<AppHomeView> createState() => _AppHomeViewState();
}

class _AppHomeViewState extends State<AppHomeView> {
  ProductController productController = Get.find();
  HomeController homeController = Get.find<HomeController>();
  FilterController filterController = Get.find<FilterController>();
  final UserController userController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.secondaryHeaderColor,
      body: SafeArea(
        child: Column(
          children: [
            //custom appbar
            const CustomAppBar(),
            //body
            Expanded(
              child: Stack(
                children: [
                  NotificationListener(
                    onNotification: (notification) {
                      if (notification is ScrollStartNotification) {
                        if (homeController.isShowDrawer.value) {
                          homeController.isShowDrawer.value = false;
                        }
                      }
                      return true;
                    },
                    child: Container(
                      color: Get.theme.secondaryHeaderColor,
                      child: Column(
                        children: [
                          //HOME TAB
                          Expanded(
                            child: PageView(
                              physics: const NeverScrollableScrollPhysics(),
                              controller: homeController.homePageController,
                              onPageChanged: (value) {
                                homeController.homeBottomIndex.value = value;
                              },
                              children: const [
                                HomeContent(),
                                ChatContent(),
                                CategoryContent(),
                                AddPostContent(),
                                ProfileContent(),
                              ],
                            ),
                          ),
                          const AppBottomNavigationBar(),
                        ],
                      ),
                    ),
                  ),
                  //app drawer
                  const AppDrawer(),
                  const SearchView(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
