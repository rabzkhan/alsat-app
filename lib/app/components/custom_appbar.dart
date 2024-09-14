import 'package:alsat/app/data/local/my_shared_pref.dart';
import 'package:alsat/app/modules/app_home/controller/home_controller.dart';
import 'package:alsat/app/modules/filter/views/filter_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../common/const/image_path.dart';

class CustomAppbar extends StatelessWidget {
  final bool isShowSearch;
  final bool isShowFilter;
  const CustomAppbar({super.key, this.isShowSearch = true, this.isShowFilter = true});

  @override
  Widget build(BuildContext context) {
    HomeController homeController = Get.find<HomeController>();
    return Container(
      alignment: Alignment.center,
      height: 55.h,
      padding: EdgeInsets.symmetric(
        vertical: 10.h,
        horizontal: 20.w,
      ).copyWith(
        left: 12.w,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              homeController.isShowDrawer.value = !homeController.isShowDrawer.value;
            },
            icon: const Icon(Icons.menu),
          ),
          4.horizontalSpace,
          InkWell(
            onTap: () {},
            child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 6.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Get.theme.shadowColor.withOpacity(.1),
                    ),
                  ),
                  child: Image.asset(
                    notificationBell,
                    height: 22.h,
                    width: 22.w,
                  ),
                ),
                Positioned(
                  right: 0,
                  child: CircleAvatar(
                    backgroundColor: Colors.red,
                    radius: 5.r,
                  ),
                )
              ],
            ),
          ),

          const Spacer(),
          Image.asset(logo),
          const Spacer(),

          ///ll
          if (isShowSearch)
            InkWell(
              onTap: () {
                MySharedPref.clear();
              },
              child: Image.asset(
                searchIcon,
                height: 23.h,
                width: 23.w,
              ),
            ),
          12.horizontalSpace,

          ///ll
          if (isShowFilter)
            InkWell(
              onTap: () {
                Get.to(const FilterView(), transition: Transition.fadeIn);
              },
              child: Image.asset(
                filterIcon,
                height: 23.h,
                width: 23.w,
              ),
            ),
          if (!isShowFilter && !isShowSearch) const Spacer()
        ],
      ),
    );
  }
}
