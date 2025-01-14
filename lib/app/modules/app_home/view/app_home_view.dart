import 'package:alsat/app/components/app_drawer.dart';
import 'package:alsat/app/components/bottom_navigation_bar.dart';
import 'package:alsat/app/components/custom_appbar.dart';
import 'package:alsat/app/modules/app_home/component/add_post_content.dart';
import 'package:alsat/app/modules/app_home/component/category_content.dart';
import 'package:alsat/app/modules/app_home/component/chat_content.dart';
import 'package:alsat/app/modules/app_home/component/home_content.dart';
import 'package:alsat/app/modules/filter/controllers/filter_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../auth_user/controller/user_controller.dart';
import '../../filter/views/search_view.dart';
import '../component/profile_content.dart';
import '../controller/home_controller.dart';

class AppHomeView extends StatefulWidget {
  const AppHomeView({super.key});

  @override
  State<AppHomeView> createState() => _AppHomeViewState();
}

class _AppHomeViewState extends State<AppHomeView> {
  HomeController homeController = Get.find<HomeController>();
  FilterController filterController = Get.find<FilterController>();
  final UserController userController = Get.find();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<bool> _onWillPop() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Confirm Exit'),
            content: const Text('Do you really want to go back?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false), // Stay
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true), // Exit
                child: const Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Get.theme.secondaryHeaderColor,
        drawerScrimColor: Colors.transparent,
        drawer: const Drawer(
          elevation: 0,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          child: AppDrawer(),
        ),
        body: SafeArea(
          child: Column(
            children: [
              // Custom appbar
              Obx(() {
                return CustomAppBar(
                  isShowLogo: homeController.homeBottomIndex.value == 0,
                  scaffoldKey: _scaffoldKey,
                );
              }),
              // Body
              Expanded(
                child: Container(
                  color: Get.theme.secondaryHeaderColor,
                  child: Column(
                    children: [
                      // HOME TAB
                      Expanded(
                        child: PageView(
                          physics: const NeverScrollableScrollPhysics(),
                          controller: homeController.homePageController,
                          onPageChanged: (value) {
                            homeController.homeBottomIndex.value = value;
                          },
                          children: const [
                            HomeContent(),
                            CategoryContent(),
                            AddPostContent(),
                            ChatContent(),
                            ProfileContent(),
                          ],
                        ),
                      ),
                      const AppBottomNavigationBar(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
//ne