import 'package:alsat/app/modules/filter/views/filter_view.dart';
import 'package:alsat/config/theme/app_text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart' as animate;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../common/const/image_path.dart';
import '../../../components/product_list_tile.dart';
import '../../product/model/product_post_list_res.dart';
import '../controllers/filter_controller.dart';

class FilterResultsView extends GetView<FilterController> {
  const FilterResultsView({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        controller.itemList.clear();
        controller.userProductPostListRes = ProudctPostListRes();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                Get.to(const FilterView(), transition: Transition.fadeIn);
              },
              icon: Image.asset(
                filterIcon,
                height: 23.h,
                width: 23.w,
              ),
            ),
            IconButton(
              icon: Obx(() {
                return Image.asset(
                  controller.sortDonwnToUp.value ? sortDown : sortUp,
                  height: 23.h,
                  width: 23.w,
                );
              }),
              onPressed: () {
                controller.sortDonwnToUp.value =
                    !controller.sortDonwnToUp.value;
                controller.isFilterLoading.value = true;
                controller.applyFilter();
              },
            ),
          ],
          elevation: 0,
          title: Text(
            "Search Your Product",
            style: regular,
          ),
        ),
        body: Obx(
          () {
            return SmartRefresher(
              enablePullDown: true,
              enablePullUp: true,
              header: const WaterDropHeader(),
              controller: controller.refreshController,
              onRefresh: controller.onRefresh,
              onLoading: controller.onLoading,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(top: 10.h),
                itemCount: controller.isFilterLoading.value
                    ? 10
                    : controller.itemList.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  ProductModel? productModel = controller.isFilterLoading.value
                      ? null
                      : controller.itemList[index];
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: 10.h,
                    ),
                    child: Skeletonizer(
                      enabled: controller.isFilterLoading.value,
                      effect: ShimmerEffect(
                        baseColor: Get.theme.disabledColor.withOpacity(.2),
                        highlightColor: Colors.white,
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      child: ProductListTile(
                        productModel: productModel,
                      ),
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
}
