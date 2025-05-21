// ignore_for_file: deprecated_member_use

import 'dart:ui';
import 'package:alsat/app/components/app_drawer.dart';
import 'package:alsat/app/components/bottom_navigation_bar.dart';
import 'package:alsat/app/components/custom_appbar.dart';
import 'package:alsat/app/components/custom_snackbar.dart';
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
import 'package:alsat/l10n/app_localizations.dart';

import 'notification_view.dart';

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

  // Future<bool> _onWillPop(AppLocalizations localLanguage) async {
  //   return await Get.dialog(
  //     Center(
  //       child: BackdropFilter(
  //         filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
  //         child: Container(
  //           padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.h),
  //           margin: EdgeInsets.symmetric(horizontal: Get.width * 0.06),
  //           width: Get.width,
  //           decoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(20).r,
  //             color: Colors.white,
  //           ),
  //           child: Material(
  //             color: Colors.white,
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 10.verticalSpace,
  //                 Text(
  //                   localLanguage.confirmExit,
  //                   style: Get.theme.textTheme.titleMedium!.copyWith(
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //                 ),
  //                 8.verticalSpace,
  //                 Text(
  //                   localLanguage.doYouWantToGoBack,
  //                   textAlign: TextAlign.center,
  //                   style: Theme.of(Get.context!).textTheme.bodyMedium!.copyWith(),
  //                 ),
  //                 20.verticalSpace,
  //                 SizedBox(
  //                   height: 40.h,
  //                   child: Row(
  //                     children: [
  //                       Expanded(
  //                         flex: 2,
  //                         child: OutlinedButton(
  //                           style: OutlinedButton.styleFrom(
  //                             backgroundColor: Get.theme.primaryColor.withOpacity(.1),
  //                             side: BorderSide(
  //                               color: Get.theme.primaryColor,
  //                               width: 1,
  //                             ),
  //                             fixedSize: const Size.fromHeight(48),
  //                             shape: RoundedRectangleBorder(
  //                               borderRadius: BorderRadius.circular(10.r),
  //                             ),
  //                           ),
  //                           child: Text(
  //                             localLanguage.no,
  //                             style: regular.copyWith(
  //                               color: Get.theme.primaryColor,
  //                             ),
  //                           ),
  //                           onPressed: () {
  //                             Navigator.of(context).pop(false);
  //                           },
  //                         ),
  //                       ),
  //                       10.horizontalSpace,
  //                       Expanded(
  //                         flex: 3,
  //                         child: ElevatedButton(
  //                           style: ElevatedButton.styleFrom(
  //                             elevation: 0,
  //                             fixedSize: const Size.fromHeight(48),
  //                             backgroundColor: Get.theme.primaryColor,
  //                             shape: RoundedRectangleBorder(
  //                               borderRadius: BorderRadius.circular(10.r),
  //                             ),
  //                           ),
  //                           onPressed: () async {
  //                             Navigator.of(context).pop(true);
  //                           },
  //                           child: Text(
  //                             localLanguage.yes,
  //                             style: regular.copyWith(
  //                               color: Colors.white,
  //                             ),
  //                           ),
  //                         ),
  //                       )
  //                     ],
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
  DateTime? _lastPressedAt; // Declare this at the class level

  Future<bool> _onWillPop(AppLocalizations localLanguage) async {
    final now = DateTime.now();

    // Check if this is the first press or if too much time has passed
    if (_lastPressedAt == null ||
        now.difference(_lastPressedAt!) > const Duration(seconds: 2)) {
      _lastPressedAt = now;

      CustomSnackBar.showCustomToast(
        message: localLanguage.pressBackAgainToExit,
      );

      return false;
    }

    // Second press within 2 seconds → show confirmation dialog
    return await Get.dialog(
      Center(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.h),
            margin: EdgeInsets.symmetric(horizontal: Get.width * 0.06),
            width: Get.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20).r,
              color: Colors.white,
            ),
            child: Material(
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  10.verticalSpace,
                  Text(
                    localLanguage.confirmExit,
                    style: Get.theme.textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  8.verticalSpace,
                  Text(
                    localLanguage.doYouWantToGoBack,
                    textAlign: TextAlign.center,
                    style:
                        Theme.of(Get.context!).textTheme.bodyMedium!.copyWith(),
                  ),
                  20.verticalSpace,
                  SizedBox(
                    height: 40.h,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              backgroundColor:
                                  Get.theme.primaryColor.withOpacity(.1),
                              side: BorderSide(
                                color: Get.theme.primaryColor,
                                width: 1,
                              ),
                              fixedSize: const Size.fromHeight(48),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                            ),
                            child: Text(
                              localLanguage.no,
                              style: regular.copyWith(
                                color: Get.theme.primaryColor,
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                          ),
                        ),
                        10.horizontalSpace,
                        Expanded(
                          flex: 3,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              fixedSize: const Size.fromHeight(48),
                              backgroundColor: Get.theme.primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                            ),
                            onPressed: () async {
                              Navigator.of(context).pop(true);
                            },
                            child: Text(
                              localLanguage.yes,
                              style: regular.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
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
                            localLanguage.chat_history,
                            style: bold.copyWith(
                              fontSize: 20.sp,
                              fontFamily: 'Exo',
                            ),
                          ),
                        )
                      : null,
                  isShowLogo: homeController.homeBottomIndex.value == 0 ||
                      homeController.homeBottomIndex.value == 3,
                  scaffoldKey: _scaffoldKey,
                  action: homeController.homeBottomIndex.value == 0 ||
                          homeController.homeBottomIndex.value == 3 ||
                          homeController.homeBottomIndex.value == 4
                      ? Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            onPressed: () {
                              Get.to(() => NotificationView());
                            },
                            icon: Image.asset(
                              "assets/icons/notification.png",
                              height: 25.h,
                            ),
                          ),
                        )
                      : homeController.homeBottomIndex.value == 1
                          ? Container(
                              width: Get.width * 0.8,
                              padding: EdgeInsets.only(right: 16.w),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller:
                                          filterController.searchController,
                                      onFieldSubmitted: (value) {
                                        filterController.category.value = null;
                                        filterController.isFilterLoading.value =
                                            true;
                                        filterController.filterMapPassed = {
                                          "title":
                                              filterController.searchText.value,
                                        };
                                        filterController.clearAddress();
                                        filterController.applyFilter();
                                        Get.to(
                                          const FilterResultsView(),
                                          transition: Transition.rightToLeft,
                                        );
                                      },
                                      onChanged: (value) {
                                        filterController.searchText.value =
                                            value;
                                      },
                                      style: TextStyle(
                                        // Input text style
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          CupertinoIcons.search,
                                          size: 18.sp,
                                          color: Get.theme.disabledColor
                                              .withOpacity(0.7),
                                        ),
                                        suffixIcon: Obx(() {
                                          return filterController
                                                  .searchText.value.isEmpty
                                              ? const SizedBox()
                                              : InkWell(
                                                  onTap: () {
                                                    filterController
                                                        .searchText.value = '';
                                                    filterController
                                                        .searchController
                                                        .clear();
                                                  },
                                                  child: Icon(
                                                    CupertinoIcons.xmark,
                                                    size: 18.sp,
                                                    color:
                                                        Get.theme.disabledColor,
                                                  ),
                                                );
                                        }),
                                        hintText: localLanguage.search_here,
                                        hintStyle: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500,
                                          color: Get.theme.disabledColor
                                              .withOpacity(0.5),
                                        ),
                                        isDense: true,
                                        filled: true,
                                        fillColor: Colors.white,
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 12.h),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Get.theme.disabledColor
                                                .withOpacity(0.1),
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Get.theme.disabledColor
                                                .withOpacity(0.1),
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Get.theme.primaryColor
                                                .withOpacity(0.4),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Obx(() {
                                    return filterController
                                            .searchText.value.isEmpty
                                        ? const Center()
                                        : InkWell(
                                            onTap: () {
                                              filterController.category.value =
                                                  null;
                                              filterController
                                                  .isFilterLoading.value = true;
                                              filterController.filterMapPassed =
                                                  {
                                                "title": filterController
                                                    .searchText.value,
                                              };
                                              filterController.applyFilter();
                                              filterController.clearAddress();
                                              Get.to(
                                                const FilterResultsView(),
                                                transition:
                                                    Transition.rightToLeft,
                                              );
                                            },
                                            child: Padding(
                                              padding:
                                                  EdgeInsets.only(left: 15.w),
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
                        child: PageView(
                          physics: const NeverScrollableScrollPhysics(),
                          controller: homeController.homePageController,
                          onPageChanged: (value) {
                            homeController.homeBottomIndex.value = value;
                          },
                          children: [
                            const HomeContent(),
                            const CategoryContent(),
                            const Center(),
                            const ChatContent(),
                            const ProfileContent()
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
