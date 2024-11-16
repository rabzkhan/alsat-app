import 'package:alsat/app/components/product_grid_tile.dart';
import 'package:alsat/app/modules/product/controller/product_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MyListings extends StatelessWidget {
  const MyListings({super.key});

  @override
  Widget build(BuildContext context) {
    ProductController productController = Get.find();
    return Obx(
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
          child: GridView.builder(
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
    );
  }
}
