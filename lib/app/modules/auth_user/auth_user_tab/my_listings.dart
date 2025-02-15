import 'package:alsat/app/components/product_grid_tile.dart';
import 'package:alsat/app/modules/product/controller/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../components/no_data_widget.dart';
import '../../app_home/controller/home_controller.dart';

class MyListings extends StatelessWidget {
  final TabController tabController;
  const MyListings({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    ProductController productController = Get.find();
    HomeController homeController = Get.find();

    return Obx(() {
      return DefaultTabController(
        initialIndex: productController.myListingSelectCategory.value == null
            ? 0
            : (homeController.categories
                .indexOf(productController.myListingSelectCategory.value)),
        length: homeController.categories.length,
        child: Obx(
          () {
            return SmartRefresher(
              enablePullDown: true,
              enablePullUp: true,
              header: WaterDropHeader(
                waterDropColor: context.theme.primaryColor,
              ),
              controller: productController.myListingRefreshController,
              onRefresh: productController.myListingRefresh,
              onLoading: productController.myListingLoading,
              child: !productController.isFetchMyProduct.value &&
                      productController.myProductList.isEmpty
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
                          loading: productController.isFetchMyProduct.value,
                          productModel: productController.isFetchMyProduct.value
                              ? null
                              : productController.myProductList[index],
                        );
                      },
                      itemCount: productController.isFetchMyProduct.value
                          ? 10
                          : productController.myProductList.length,
                    ),
            );
          },
        ),
      );
    });
  }
}
