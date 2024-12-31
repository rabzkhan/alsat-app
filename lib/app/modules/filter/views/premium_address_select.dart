import 'package:alsat/app/modules/app_home/controller/home_controller.dart';
import 'package:alsat/config/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../models/location_model.dart';

class PremiumAddressSelection extends StatelessWidget {
  final bool reverse;

  const PremiumAddressSelection({super.key, this.reverse = false});

  @override
  Widget build(BuildContext context) {
    HomeController homeController = Get.find<HomeController>();
    return Material(
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          // leading: Container(),
          middle: Text(
            'Select Province',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14.sp,
              color: Colors.black,
            ),
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: ListView(
            reverse: reverse,
            shrinkWrap: true,
            controller: ModalScrollController.of(context),
            physics: const ClampingScrollPhysics(),
            children: ListTile.divideTiles(
              context: context,
              tiles: List.generate(
                provinces.length,
                (index) => Material(
                  child: ListTile(
                    leading: (homeController.selectedLocation.any((element) =>
                            element['province'] == provinces[index].name))
                        ? const Icon(
                            Icons.check,
                            color: AppColors.primary,
                          )
                        : null,
                    title: Text(provinces[index].name),
                    onTap: () => showCupertinoModalBottomSheet(
                      expand: true,
                      isDismissible: false,
                      context: context,
                      backgroundColor: Colors.transparent,
                      builder: (context) => Material(
                        child: CupertinoPageScaffold(
                          navigationBar: CupertinoNavigationBar(
                            // leading: Container(),
                            middle: Text(
                              'Select City',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14.sp,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          child: SafeArea(
                            bottom: false,
                            child: ListView(
                              reverse: reverse,
                              shrinkWrap: true,
                              controller: ModalScrollController.of(context),
                              physics: const ClampingScrollPhysics(),
                              children: ListTile.divideTiles(
                                context: context,
                                tiles: List.generate(
                                  provinces[index].cities.length,
                                  (i) => Material(
                                    child: ListTile(
                                      title: Text(provinces[index].cities[i]),
                                      leading: (homeController.selectedLocation
                                              .any((element) =>
                                                  element['province'] ==
                                                      provinces[index].name &&
                                                  element['city'].contains(
                                                      provinces[index]
                                                          .cities[i])))
                                          ? const Icon(
                                              Icons.check,
                                              color: AppColors.primary,
                                            )
                                          : null,
                                      onTap: () {
                                        if (homeController.selectedLocation.any(
                                            (element) =>
                                                element['province'] ==
                                                    provinces[index].name &&
                                                element['city'].contains(
                                                    provinces[index]
                                                        .cities[i]))) {
                                          homeController.selectedLocation
                                              .removeWhere((element) =>
                                                  element['province'] ==
                                                  provinces[index].name);
                                        } else {
                                          if (homeController.selectedLocation
                                              .any((element) =>
                                                  element['province'] ==
                                                  provinces[index].name)) {
                                            // need to add city under province
                                            homeController.selectedLocation
                                                .forEach((element) {
                                              if (element['province'] ==
                                                  provinces[index].name) {
                                                // Check if the city is already in the list
                                                if (!element['city'].contains(
                                                    provinces[index]
                                                        .cities[i])) {
                                                  element['city'].add(
                                                      provinces[index]
                                                          .cities[i]);
                                                }
                                              }
                                            });
                                          } else {
                                            homeController.selectedLocation
                                                .add({
                                              'province': provinces[index].name,
                                              'city': [
                                                provinces[index].cities[i]
                                              ],
                                            });
                                          }
                                        }

                                        homeController.selectedLocation
                                            .refresh();
                                        Get.back();
                                        Get.back();
                                      },
                                    ),
                                  ),
                                ),
                              ).toList(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ).toList(),
          ),
        ),
      ),
    );
  }
}
