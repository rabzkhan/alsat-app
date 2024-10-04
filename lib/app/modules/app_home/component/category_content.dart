import 'package:alsat/app/modules/app_home/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class CategoryContent extends StatelessWidget {
  const CategoryContent({super.key});

  @override
  Widget build(BuildContext context) {
    HomeController homeController = Get.find();
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        child: Obx(() {
          if (homeController.isCategoryLoading.value) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ExpansionPanelList(
            expansionCallback: (panelIndex, isExpanded) {
              if (homeController.categoryExpandedIndex.value == panelIndex) {
                homeController.categoryExpandedIndex.value = -1;
              } else {
                homeController.categoryExpandedIndex.value = panelIndex;
              }
            },
            dividerColor: Get.theme.primaryColor.withOpacity(0.2),
            elevation: 0,
            expandedHeaderPadding: EdgeInsets.zero,
            materialGapSize: 0.h,
            expandIconColor: Get.theme.primaryColor.withOpacity(0.6),
            children: [
              ...List.generate(
                homeController.categories.length,
                (index) => ExpansionPanel(
                  isExpanded: homeController.categoryExpandedIndex.value == index,
                  backgroundColor: Colors.transparent,
                  headerBuilder: (context, isExpanded) {
                    return GestureDetector(
                      onTap: () {
                        if (homeController.categoryExpandedIndex.value == index) {
                          homeController.categoryExpandedIndex.value = -1;
                        } else {
                          homeController.categoryExpandedIndex.value = index;
                        }
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
                    );
                  },
                  body: Container(
                    width: Get.width,
                    margin: EdgeInsets.symmetric(horizontal: Get.width * .12),
                    child: ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        ...homeController.categories[index].subCategories!.map((subCategory) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
                            child: Text(
                              subCategory.name.toString(),
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          );
                        })
                      ],
                    ),
                  ),
                ),
              )
            ],
          );
        }),
      ),
    );
  }
}
