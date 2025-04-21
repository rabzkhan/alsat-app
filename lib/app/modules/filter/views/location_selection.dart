import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/translations/localization_controller.dart';
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
    LocalizationController localizationService = Get.put(LocalizationController());

    // Get the current language code
    final String localLang = localizationService.locale.value.languageCode;

    // Choose the right list of provinces based on the selected language
    List<Province> provincesList = [];
    if (localLang == 'en') {
      provincesList = provinces;
    } else if (localLang == 'tr') {
      provincesList = provinces_tr;
    } else if (localLang == 'ru') {
      provincesList = provinces_ru;
    }

    return Material(
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          // middle: Text(
          //   localLanguage.select_location,
          //   style: bold.copyWith(fontSize: 16.sp),
          // ),
          trailing: IconButton(
            icon: Icon(
              Icons.check,
              size: 30.sp,
              color: Colors.grey.shade700,
            ),
            onPressed: () {
              Get.back(result: Get.find<FilterController>().getSelectedLocationText());
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
                LocalizationController localizationService = Get.put(LocalizationController());
                String localLang = localizationService.locale.value.languageCode;

                return Column(
                  children: [
                    ...List.generate(
                      provincesList.length, // Use the filtered provinces list
                      (provinceIndex) {
                        final province = provincesList[provinceIndex];
                        return Padding(
                          padding: EdgeInsets.only(bottom: 6.h),
                          child: ExpansionTile(
                            collapsedShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              side: BorderSide.none,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              side: BorderSide.none,
                            ),
                            dense: true,
                            initiallyExpanded: false,
                            showTrailingIcon: false,
                            onExpansionChanged: (value) {
                              if (value) {
                                filterController.toggleProvince(province.name, canSelectMultiple);
                              }
                            },
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
                                InkWell(
                                  onTap: () {
                                    filterController.toggleProvince(province.name, canSelectMultiple);
                                  },
                                  child: CircleAvatar(
                                    radius: 12.r,
                                    backgroundColor: AppColors.liteGray,
                                    child: Icon(
                                      filterController.isProvinceSelected(province.name)
                                          ? Icons.check_circle
                                          : Icons.circle_outlined,
                                      color: AppColors.primary,
                                      size: 24.r,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            expandedAlignment: Alignment.centerLeft,
                            expandedCrossAxisAlignment: CrossAxisAlignment.start,
                            childrenPadding:
                                EdgeInsets.symmetric(horizontal: Get.width * .06, vertical: 10.h).copyWith(right: 0),
                            backgroundColor: Theme.of(context).disabledColor.withOpacity(.03),
                            collapsedBackgroundColor: Theme.of(context).disabledColor.withOpacity(.03),
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
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            width: .5,
                                            color: Theme.of(context).disabledColor.withOpacity(.1),
                                          ),
                                        ),
                                      ),
                                      padding: EdgeInsets.symmetric(vertical: 10.h),
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
                                          if (filterController.isProvinceSelected(province.name))
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
                                                radius: 9.r,
                                                backgroundColor: AppColors.liteGray,
                                                child: Icon(
                                                  filterController.isCitySelected(province.name, city)
                                                      ? Icons.check_circle
                                                      : Icons.circle_outlined,
                                                  color: AppColors.primary,
                                                  size: 18.r,
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
                          ),
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
