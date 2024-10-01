import 'package:alsat/app/common/const/image_path.dart';
import 'package:alsat/app/data/local/my_shared_pref.dart';
import 'package:alsat/app/modules/auth_user/auth_user_tab/my_listings.dart';
import 'package:alsat/app/modules/authentication/controller/auth_controller.dart';
import 'package:alsat/config/theme/app_text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../auth_user/controller/user_controller.dart';

class ProfileContent extends StatelessWidget {
  const ProfileContent({super.key});

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find();
    final AuthController authController = Get.find();
    return DefaultTabController(
      length: userController.profileTab.length,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 12.w,
          vertical: 3.h,
        ).copyWith(
          top: 3.h,
        ),
        child: Column(
          children: [
            //profile tile
            ListTile(
              leading: CircleAvatar(
                radius: 28.r,
                child: Image.asset(carImage),
              ),
              title: Obx(() => Text(
                    authController.userDataModel.value.userName ?? 'Guest User',
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
                          authController.userDataModel.value.phone ?? ' 01211312342',
                          style: regular.copyWith(
                            fontSize: 10.sp,
                          ),
                        )),
                    if (MySharedPref.isLoggedIn())
                      Obx(
                        () => RatingBar.builder(
                          itemSize: 15.h,
                          initialRating: MySharedPref.isLoggedIn()
                              ? double.parse(authController.userDataModel.value.rating.toString())
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
                  Container(
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
                  const Icon(Icons.more_vert_outlined),
                ],
              ),
            ),
            10.verticalSpace,
            SizedBox(
              height: 32.h,
              child: TabBar(
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
                    return Tab(
                      text: e,
                    );
                  },
                ).toList(),
              ),
            ),
            5.verticalSpace,
            const Expanded(
              child: TabBarView(
                children: [
                  MyListings(),
                  Center(),
                  Center(),
                  Center(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
