import 'package:alsat/app/components/app_drawer.dart';
import 'package:alsat/app/components/bottom_navigation_bar.dart';
import 'package:alsat/app/components/custom_appbar.dart';
import 'package:alsat/app/modules/app_home/component/add_post_content.dart';
import 'package:alsat/app/modules/app_home/component/category_content.dart';
import 'package:alsat/app/modules/app_home/component/chat_content.dart';
import 'package:alsat/app/modules/app_home/component/home_content.dart';
import 'package:alsat/app/modules/filter/controllers/filter_controller.dart';
import 'package:alsat/app/modules/filter/views/filter_results_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../config/theme/app_text_theme.dart';
import '../../auth_user/controller/user_controller.dart';
import '../component/profile_content.dart';
import '../controller/home_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  Future<bool> _onWillPop(AppLocalizations localLanguage) async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(localLanguage.confirmExit),
            content: Text(localLanguage.doYouWantToGoBack),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false), // Stay
                child: Text(localLanguage.no),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true), // Exit
                child: Text(localLanguage.yes),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final localLanguage = AppLocalizations.of(Get.context!)!;
    return WillPopScope(
      onWillPop: () => _onWillPop(localLanguage),
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
              // Custom appBar
              Obx(() {
                return CustomAppBar(
                  title: homeController.homeBottomIndex.value == 3
                      ? Padding(
                          padding: const EdgeInsets.only(right: 30),
                          child: Text(
                            'Chat History',
                            style: bold.copyWith(
                              fontSize: 20.sp,
                              fontFamily: 'Exo',
                            ),
                          ),
                        )
                      : null,
                  isShowLogo: homeController.homeBottomIndex.value == 0 || homeController.homeBottomIndex.value == 3,
                  scaffoldKey: _scaffoldKey,
                  action: homeController.homeBottomIndex.value == 1
                      ? Container(
                          width: Get.width * 0.8,
                          padding: EdgeInsets.only(right: 16.w),
                          child: Row(
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.r),
                                  child: TextFormField(
                                    controller: filterController.searchController,
                                    onFieldSubmitted: (value) {
                                      filterController.category.value = null;
                                      filterController.isFilterLoading.value = true;
                                      filterController.filterMapPassed = {
                                        "title": filterController.searchText.value,
                                      };
                                      filterController.clearAddress();
                                      filterController.applyFilter();
                                      Get.to(
                                        const FilterResultsView(),
                                        transition: Transition.rightToLeft,
                                      );
                                    },
                                    onChanged: (value) {
                                      filterController.searchText.value = value;
                                    },
                                    decoration: InputDecoration(
                                      suffixIcon: Obx(() {
                                        return filterController.searchText.value.isEmpty
                                            ? const Text('')
                                            : InkWell(
                                                onTap: () {
                                                  filterController.searchText.value = '';
                                                  filterController.searchController.clear();
                                                },
                                                child: Icon(
                                                  CupertinoIcons.xmark,
                                                  color: Get.theme.disabledColor,
                                                ),
                                              );
                                      }),
                                      prefixIcon: Icon(
                                        CupertinoIcons.search,
                                        color: Get.theme.disabledColor,
                                      ),
                                      hintStyle: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Get.theme.disabledColor.withOpacity(.5),
                                      ),
                                      hintText: 'Search Here',
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8.r),
                                        borderSide: BorderSide(
                                          width: .6,
                                          color: Get.theme.primaryColor.withOpacity(.4),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Obx(() {
                                return filterController.searchText.value.isEmpty
                                    ? const Center()
                                    : InkWell(
                                        onTap: () {
                                          filterController.category.value = null;
                                          filterController.isFilterLoading.value = true;
                                          filterController.filterMapPassed = {
                                            "title": filterController.searchText.value,
                                          };
                                          filterController.applyFilter();
                                          filterController.clearAddress();
                                          Get.to(
                                            const FilterResultsView(),
                                            transition: Transition.rightToLeft,
                                          );
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 15.w),
                                          child: const Icon(Icons.search),
                                        ),
                                      );
                              }),
                            ],
                          ),
                        )
                      : const Center(),
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
                        child: Obx(() {
                          return PageView(
                            physics: const NeverScrollableScrollPhysics(),
                            controller: homeController.homePageController,
                            onPageChanged: (value) {
                              homeController.homeBottomIndex.value = value;
                            },
                            children: [
                              const HomeContent(),
                              if (!homeController.isCategoryLoading.value) const CategoryContent(),
                              if (!homeController.isCategoryLoading.value) const AddPostContent(),
                              if (!homeController.isCategoryLoading.value) const ChatContent(),
                              if (!homeController.isCategoryLoading.value) const ProfileContent(),
                            ],
                          );
                        }),
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
