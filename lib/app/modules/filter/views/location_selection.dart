import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_text_theme.dart';
import '../../filter/controllers/filter_controller.dart';
import '../../filter/models/location_model.dart';

class LocationSelection extends StatelessWidget {
  final bool canSelectMultiple;
  const LocationSelection({
    super.key,
    this.canSelectMultiple = false,
  });

  @override
  Widget build(BuildContext context) {
    final FilterController filterController = Get.find();

    return Material(
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text(
            'Select Location',
            style: bold.copyWith(fontSize: 16.sp),
          ),
          trailing: IconButton(
            icon: const Icon(
              Icons.check,
              color: Colors.black,
            ),
            onPressed: () {
              Get.back(
                  result:
                      Get.find<FilterController>().getSelectedLocationText());
            },
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w),
              child: Obx(() {
                return Column(
                  children: [
                    ...List.generate(
                      provinces.length,
                      (provinceIndex) {
                        final province = provinces[provinceIndex];
                        return ExpansionTile(
                          title: Row(
                            children: [
                              Text(
                                province.name,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  // Toggle province selection
                                  filterController.toggleProvince(
                                      province.name, canSelectMultiple);
                                },
                                child: CircleAvatar(
                                  radius: 10.r,
                                  backgroundColor: AppColors.liteGray,
                                  child: Icon(
                                    filterController
                                            .isProvinceSelected(province.name)
                                        ? Icons.check_circle
                                        : Icons.circle_outlined,
                                    color: AppColors.primary,
                                    size: 20.r,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          expandedAlignment: Alignment.centerLeft,
                          expandedCrossAxisAlignment: CrossAxisAlignment.start,
                          childrenPadding: EdgeInsets.symmetric(
                              horizontal: Get.width * .06, vertical: 10.h),
                          children: [
                            ...province.cities.map(
                              (city) {
                                return InkWell(
                                  onTap: () {
                                    filterController.toggleCity(
                                      province.name,
                                      city,
                                      canSelectMultiple,
                                    );
                                  },
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 14.h),
                                    child: Row(
                                      children: [
                                        Text(
                                          city,
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const Spacer(),
                                        if (filterController
                                            .isProvinceSelected(province.name))
                                          GestureDetector(
                                            onTap: () {
                                              // Toggle city selection
                                              filterController.toggleCity(
                                                province.name,
                                                city,
                                                canSelectMultiple,
                                              );
                                            },
                                            child: CircleAvatar(
                                              radius: 8.r,
                                              backgroundColor:
                                                  AppColors.liteGray,
                                              child: Icon(
                                                filterController.isCitySelected(
                                                        province.name, city)
                                                    ? Icons.check_circle
                                                    : Icons.circle_outlined,
                                                color: AppColors.primary,
                                                size: 14.r,
                                              ),
                                            ),
                                          ),
                                        20.horizontalSpace,
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )
                          ],
                        );
                      },
                    ),
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
