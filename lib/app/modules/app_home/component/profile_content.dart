import 'package:alsat/app/common/const/image_path.dart';
import 'package:alsat/app/modules/auth_user/auth_user_tab/my_lidtings.dart';
import 'package:alsat/config/theme/app_text_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../auth_user/controller/user_controller.dart';

class ProfileContent extends StatelessWidget {
  const ProfileContent({super.key});

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find();
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
              title: Text(
                'John Coltrane',
                style: bold.copyWith(
                  fontSize: 18.sp,
                ),
              ),
              subtitle: Padding(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'info@gmail.com',
                      style: regular.copyWith(
                        fontSize: 10.sp,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: 13.r,
                          color: Get.theme.primaryColor,
                        ),
                        Icon(
                          Icons.star,
                          size: 13.r,
                          color: Get.theme.primaryColor,
                        ),
                        Icon(
                          Icons.star,
                          size: 13.r,
                          color: Get.theme.primaryColor,
                        ),
                        Icon(
                          Icons.star,
                          size: 13.r,
                        ),
                        Icon(
                          Icons.star,
                          size: 13.r,
                        ),
                      ],
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
                  MyLidtings(),
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
