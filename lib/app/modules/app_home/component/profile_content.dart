import 'package:alsat/app/common/const/image_path.dart';
import 'package:alsat/app/components/network_image_preview.dart';
import 'package:alsat/app/data/local/my_shared_pref.dart';
import 'package:alsat/app/modules/auth_user/auth_user_tab/my_listings.dart';
import 'package:alsat/app/modules/authentication/controller/auth_controller.dart';
import 'package:alsat/app/modules/product/controller/product_controller.dart';
import 'package:alsat/config/theme/app_text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../auth_user/auth_user_tab/my_followers.dart';
import '../../auth_user/auth_user_tab/my_following.dart';
import '../../auth_user/auth_user_tab/my_like_post.dart';
import '../../auth_user/auth_user_tab/my_settings.dart';
import '../../auth_user/controller/user_controller.dart';
import '../controller/home_controller.dart';

class ProfileContent extends StatefulWidget {
  const ProfileContent({super.key});

  @override
  State<ProfileContent> createState() => _ProfileContentState();
}

class _ProfileContentState extends State<ProfileContent>
    with TickerProviderStateMixin {
  final UserController userController = Get.find();
  final AuthController authController = Get.find();
  final ProductController productController = Get.find();
  HomeController homeController = Get.find();
  late TabController mainTabController;
  late TabController tabController;

  @override
  void initState() {
    mainTabController = TabController(
      length: userController.profileTab.length,
      vsync: this,
      initialIndex: homeController.profileTabCurrentPage.value,
    );

    mainTabController.addListener(() {
      if (homeController.profileTabCurrentPage.value !=
          mainTabController.index) {
        homeController.profileTabCurrentPage.value = mainTabController.index;
      }
    });

    tabController =
        TabController(length: homeController.categories.length, vsync: this);
    if (productController.myProductList.isEmpty) {
      productController.fetchMyProducts();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 12.w,
        vertical: 3.h,
      ).copyWith(
        top: 3.h,
      ),
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverToBoxAdapter(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: CircleAvatar(
                    radius: 28.r,
                    child: NetworkImagePreview(
                      height: 56.h,
                      width: 56.w,
                      fit: BoxFit.cover,
                      radius: 28.r,
                      url: authController.userDataModel.value.picture ?? '',
                      error: Image.asset(userDefaultIcon),
                    ),
                  ),
                  title: Obx(() => Text(
                        authController.userDataModel.value.userName ??
                            'Guest User',
                        style: bold.copyWith(
                          fontSize: 18.sp,
                        ),
                      )),
                  subtitle: Padding(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() => Text(
                              authController.userDataModel.value.phone ??
                                  ' 01211312342',
                              style: regular.copyWith(
                                fontSize: 10.sp,
                              ),
                            )),
                        if (MySharedPref.isLoggedIn())
                          Obx(
                            () => RatingBar.builder(
                              itemSize: 15.h,
                              initialRating: MySharedPref.isLoggedIn()
                                  ? double.parse((authController
                                              .userDataModel.value.rating ??
                                          "0")
                                      .toString())
                                  : 0,
                              minRating: 0,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Get.theme.primaryColor,
                              ),
                              onRatingUpdate: (rating) {},
                            ),
                          ),
                      ],
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          Get.to(() => const MySettings());
                        },
                        icon: Container(
                          width: 30.w,
                          padding: EdgeInsets.symmetric(
                            horizontal: 5.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: Get.theme.primaryColor.withOpacity(.15),
                            borderRadius: BorderRadius.circular(5.r),
                          ),
                          child: Image.asset(
                            settingIcon,
                          ),
                        ),
                      ),
                      //const Icon(Icons.more_vert_outlined),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SliverAppBar(
            pinned: true,
            elevation: 0,
            backgroundColor: Get.theme.scaffoldBackgroundColor,
            toolbarHeight: 0,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(35),
              child: TabBar(
                controller: mainTabController,
                indicatorWeight: 0,
                indicatorPadding: EdgeInsets.zero,
                indicatorSize: TabBarIndicatorSize.tab,
                labelStyle: regular.copyWith(
                  fontSize: 14.sp,
                ),
                padding: EdgeInsets.zero,
                unselectedLabelColor: Get.theme.disabledColor,
                labelColor: Get.theme.scaffoldBackgroundColor,
                indicator: BoxDecoration(
                  color: Get.theme.primaryColor,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                isScrollable: true,
                tabs: userController.profileTab.map(
                  (e) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        e,
                      ),
                    );
                  },
                ).toList(),
              ),
            ),
          ),
          Obx(() {
            return homeController.profileTabCurrentPage.value == 0
                ? SliverAppBar(
                    pinned: true,
                    elevation: 0,
                    backgroundColor: Get.theme.scaffoldBackgroundColor,
                    toolbarHeight: 0,
                    bottom: PreferredSize(
                      preferredSize: const Size.fromHeight(38),
                      child: TabBar(
                        controller: tabController,
                        onTap: (value) {
                          productController.myListingSelectCategory.value =
                              homeController.categories[value];
                          productController.myListingRefresh();
                        },
                        isScrollable: true,
                        unselectedLabelColor: Colors.black87,
                        indicatorWeight: 1,
                        indicator: BoxDecoration(
                          color: Colors.transparent,
                          border: Border(
                            bottom: BorderSide(
                              color: context.theme.primaryColor,
                              width: 1,
                            ),
                          ),
                        ),
                        tabs: homeController.categories
                            .map(
                              (e) => Padding(
                                padding: EdgeInsets.symmetric(vertical: 6.h),
                                child: Text(
                                  e.name ?? '',
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  )
                : const SliverAppBar(
                    toolbarHeight: 0,
                  );
          }),
        ],
        body: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: TabBarView(
            controller: mainTabController,
            children: [
              MyListings(
                tabController: tabController,
              ),
              const MyLikePost(),
              const MyFollowers(),
              const MyFollowing(),
            ],
          ),
        ),
      ),
    );
  }
}
