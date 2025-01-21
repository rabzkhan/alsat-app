import 'package:alsat/app/components/no_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../common/const/image_path.dart';
import '../../../components/all_user_tile.dart';
import '../../../components/custom_appbar.dart';
import '../../app_home/controller/home_controller.dart';
import '../../authentication/model/user_data_model.dart';
import 'user_filter_view.dart';

class UserFilterResultView extends StatelessWidget {
  final bool isBackFilter;
  const UserFilterResultView({super.key, this.isBackFilter = true});

  @override
  Widget build(BuildContext context) {
    HomeController homeController = Get.find();
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: SafeArea(
          child: CustomAppBar(
            isShowLogo: false,
            isShowBackButton: true,
            isShowFilter: false,
            isShowSearch: false,
            isShowNotification: false,
            action: IconButton(
              onPressed: () {
                if (isBackFilter) {
                  Get.back();
                } else {
                  Get.off(() => const UserFilterView());
                }
              },
              icon: Image.asset(
                filterIcon,
                height: 23.h,
                width: 23.w,
              ),
            ),
          ),
        ),
      ),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: WaterDropHeader(
          waterDropColor: context.theme.primaryColor,
        ),
        controller: homeController.userFilterRefreshController,
        onRefresh: homeController.onUserFilterRefresh,
        onLoading: homeController.onUserFilterLoading,
        child: Obx(() {
          return Skeletonizer(
            enabled: homeController.isFilterLoading.value,
            effect: ShimmerEffect(
              baseColor: Get.theme.disabledColor.withOpacity(.2),
              highlightColor: Colors.white,
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            child: !homeController.isFilterLoading.value &&
                    homeController.filterUserList.isEmpty
                ? const NoDataWidget()
                : ListView.builder(
                    itemCount: homeController.isFilterLoading.value
                        ? 10
                        : homeController.filterUserList.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      UserDataModel premiumUserModel =
                          homeController.isFilterLoading.value
                              ? UserDataModel()
                              : homeController.filterUserList[index];
                      return AllUserTile(premiumUserModel: premiumUserModel);
                    },
                  ),
          );
        }),
      ),
    );
  }
}
