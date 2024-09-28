import 'package:alsat/app/common/const/image_path.dart';
import 'package:alsat/app/modules/app_home/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../components/category_tile.dart';

class CategoryContent extends StatelessWidget {
  const CategoryContent({super.key});

  @override
  Widget build(BuildContext context) {
    HomeController homeController = Get.find();
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: 10.w,
        ),
        child: Obx(() {
          return ExpansionPanelList(
            expansionCallback: (panelIndex, isExpanded) {
              if (homeController.categoryExpandedIndex.value == panelIndex) {
                homeController.categoryExpandedIndex.value = -1;
              } else {
                homeController.categoryExpandedIndex.value = panelIndex;
              }
            },
            elevation: 0,
            expandedHeaderPadding: EdgeInsets.zero,
            materialGapSize: 0.h,
            children: [
              ...List.generate(
                10,
                (index) => ExpansionPanel(
                  isExpanded:
                      homeController.categoryExpandedIndex.value == index,
                  backgroundColor: Colors.transparent,
                  headerBuilder: (context, isExpanded) {
                    return GestureDetector(
                      onTap: () {
                        if (homeController.categoryExpandedIndex.value ==
                            index) {
                          homeController.categoryExpandedIndex.value = -1;
                        } else {
                          homeController.categoryExpandedIndex.value = index;
                        }
                      },
                      child: Row(
                        children: [
                          4.horizontalSpace,
                          Image.asset(
                            'assets/icons/real-estate-01.png',
                            width: 35.w,
                            height: 22.w,
                          ),
                          Text(
                            'Real Estate',
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Sell of apartments & houses",
                          style: TextStyle(
                            fontSize: 15.sp,
                          ),
                        ),
                        8.verticalSpace,
                        Text(
                          "Sell of commercial & private estate",
                          style: TextStyle(
                            fontSize: 15.sp,
                          ),
                        ),
                        8.verticalSpace,
                        Text(
                          "Rent of apartment, room, house",
                          style: TextStyle(
                            fontSize: 15.sp,
                          ),
                        ),
                        8.verticalSpace,
                        Text(
                          "Rent of office",
                          style: TextStyle(
                            fontSize: 15.sp,
                          ),
                        ),
                        8.verticalSpace,
                        Text(
                          "Rent of commercial & private estate",
                          style: TextStyle(
                            fontSize: 15.sp,
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
    );
  }
}
