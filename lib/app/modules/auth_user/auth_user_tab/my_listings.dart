import 'package:alsat/app/components/product_grid_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../components/custom_footer_widget.dart';
import '../../../components/custom_header_widget.dart';
import '../../../components/no_data_widget.dart';
import '../../app_home/controller/home_controller.dart';

class MyListings extends StatelessWidget {
  const MyListings({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    HomeController homeController = Get.find();

    return Obx(
      () {
        return SmartRefresher(
          enablePullDown: true,
          enablePullUp: true,
          header: CustomHeaderWidget(),
          footer: CustomFooterWidget(),
          controller: homeController.myListingRefreshController,
          onRefresh: homeController.myListingRefresh,
          onLoading: homeController.myListingLoading,
          child: !homeController.isFetchMyProduct.value &&
                  homeController.myProductList.isEmpty
              ? const NoDataWidget()
              : GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.w,
                    vertical: 20.h,
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10.h,
                    crossAxisSpacing: 10.w,
                    mainAxisExtent: 200.h,
                  ),
                  itemBuilder: (context, index) {
                    return ProductGridTile(
                      loading: homeController.isFetchMyProduct.value,
                      productModel: homeController.isFetchMyProduct.value
                          ? null
                          : homeController.myProductList[index],
                    );
                  },
                  itemCount: homeController.isFetchMyProduct.value
                      ? 10
                      : homeController.myProductList.length,
                ),
        );
      },
    );
  }
}
