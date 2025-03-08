import 'package:alsat/app/components/no_data_widget.dart';
import 'package:alsat/app/components/product_grid_tile.dart';
import 'package:alsat/app/modules/product/controller/product_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../components/custom_footer_widget.dart';
import '../../../components/custom_header_widget.dart';

class MyLikePost extends StatelessWidget {
  const MyLikePost({super.key});

  @override
  Widget build(BuildContext context) {
    ProductController productController = Get.find();
    if (productController.myLikeProductList.isEmpty) {
      productController.fetchMyLikeProducts();
    }
    return Obx(
      () {
        return SmartRefresher(
          enablePullDown: true,
          enablePullUp: true,
          header: CusomHeaderWidget(),
          footer: CustomFooterWidget(),
          controller: productController.myLikePostRefreshController,
          onRefresh: productController.myLikePostRefresh,
          onLoading: productController.myLikePostLoading,
          child: !productController.isFetchLikeProduct.value && productController.myLikeProductList.isEmpty
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
                      isShowFavoriteButton: true,
                      loading: productController.isFetchLikeProduct.value,
                      productModel: productController.isFetchLikeProduct.value
                          ? null
                          : productController.myLikeProductList[index],
                    );
                  },
                  itemCount:
                      productController.isFetchLikeProduct.value ? 10 : productController.myLikeProductList.length,
                ),
        );
      },
    );
  }
}
