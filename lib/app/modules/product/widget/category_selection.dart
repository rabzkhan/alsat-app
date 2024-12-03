import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../config/theme/app_text_theme.dart';
import '../../app_home/controller/home_controller.dart';
import '../controller/product_controller.dart';

class CategorySelection extends StatelessWidget {
  final bool valueReturn;
  const CategorySelection({super.key, this.valueReturn = false});

  @override
  Widget build(BuildContext context) {
    HomeController homeController = Get.find();
    ProductController productController = Get.find();
    return Material(
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text(
            'Select Ctaegory',
            style: bold.copyWith(
              fontSize: 16.sp,
            ),
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w),
              child: Obx(() {
                if (homeController.isCategoryLoading.value) {
                  return SizedBox(
                    height: Get.height * .8,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                return Column(
                  children: [
                    ...List.generate(
                      homeController.categories.length,
                      (index) => ListTile(
                        title: GestureDetector(
                          onTap: () {
                            if (!valueReturn) {
                              productController.selectCategory.value = homeController.categories[index];
                            }
                            Get.back(result: homeController.categories[index]);
                          },
                          child: Row(
                            children: [
                              6.horizontalSpace,
                              SvgPicture.network(
                                homeController.categories[index].icon.toString(),
                                width: 35.w,
                                height: 22.w,
                              ),
                              10.horizontalSpace,
                              Text(
                                homeController.categories[index].name ?? "",
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
