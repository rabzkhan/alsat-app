import 'package:alsat/app/components/no_data_widget.dart';
import 'package:alsat/app/modules/filter/views/filter_view.dart';
import 'package:alsat/config/theme/app_text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_popup/flutter_popup.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../common/const/image_path.dart';
import '../../../components/custom_footer_widget.dart';
import '../../../components/custom_header_widget.dart';
import '../../../components/product_list_tile.dart';
import '../../product/model/product_post_list_res.dart';
import '../controllers/filter_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FilterResultsView extends GetView<FilterController> {
  const FilterResultsView({super.key});

  @override
  Widget build(BuildContext context) {
    final localLanguage = AppLocalizations.of(Get.context!)!;

    return WillPopScope(
      onWillPop: () async {
        controller.itemList.clear();
        controller.userProductPostListRes = ProductPostListRes();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                Get.to(
                    FilterView(
                      isBack: true,
                      preData: controller.filterMapPassed,
                    ),
                    transition: Transition.fadeIn);
              },
              icon: Image.asset(
                filterIcon,
                height: 23.h,
                width: 23.w,
              ),
            ),
            CustomPopup(
              backgroundColor: Colors.black12,
              showArrow: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              barrierColor: Colors.transparent,
              arrowColor: Colors.black,
              contentDecoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(.4),
                    blurRadius: 10,
                    spreadRadius: .5,
                  ),
                ],
              ),
              content: SizedBox(
                width: MediaQuery.of(context).size.width * .5,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _shortTile(title: localLanguage.default_),
                    _shortTile(title: localLanguage.the_newest),
                    _shortTile(title: localLanguage.the_cheaper_price_first),
                    _shortTile(title: localLanguage.the_highest_price_first),
                  ],
                ),
              ),
              child: Obx(() {
                return Padding(
                  padding: EdgeInsets.only(right: 15.w, left: 5.w),
                  child: Image.asset(
                    controller.sortDownToUp.value ? sortDown : sortUp,
                    height: 23.h,
                    width: 23.w,
                  ),
                );
              }),
            ),
          ],
          elevation: 0,
          title: Text(
            (controller.category.value?.name ?? controller.searchText.value),
            style: regular,
          ),
        ),
        body: Obx(
          () {
            return SmartRefresher(
              enablePullDown: true,
              enablePullUp: true,
              header: CustomHeaderWidget(),
              footer: CustomFooterWidget(),
              controller: controller.refreshController,
              onRefresh: controller.onRefresh,
              onLoading: controller.onLoading,
              child: !controller.isFilterLoading.value && controller.itemList.isEmpty
                  ? NoDataWidget()
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.only(top: 10.h),
                      itemCount: controller.isFilterLoading.value ? 10 : controller.itemList.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, int index) {
                        ProductModel? productModel =
                            controller.isFilterLoading.value ? null : controller.itemList[index];
                        return Skeletonizer(
                          enabled: controller.isFilterLoading.value,
                          // effect: ShimmerEffect(
                          //   baseColor:
                          //       Get.theme.disabledColor.withOpacity(.2),
                          //   highlightColor: Colors.white,
                          //   begin: Alignment.centerLeft,
                          //   end: Alignment.centerRight,
                          // ),
                          child: ProductListTile(
                            productModel: productModel,
                          ),
                        );
                      },
                    ),
            );
          },
        ),
      ),
    );
  }

  InkWell _shortTile({required String title}) {
    return InkWell(
      onTap: () {
        controller.sortValue.value = title;
        controller.sortDownToUp.value = title.contains('Cheaper');
        controller.isFilterLoading.value = true;
        controller.applyFilter();
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 5.w,
          vertical: 6.h,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: regular.copyWith(
                  fontSize: 14.sp,
                  color: Colors.white,
                ),
              ),
            ),
            Obx(() {
              return CircleAvatar(
                radius: 10.r,
                backgroundColor:
                    controller.sortValue.value == title ? Colors.transparent : AppColors.liteGray.withOpacity(.4),
                child: controller.sortValue.value == title
                    ? Icon(
                        Icons.check_circle,
                        color: AppColors.primary,
                        size: 22.r,
                      )
                    : const Center(),
              );
            }),
          ],
        ),
      ),
    );
  }
}
