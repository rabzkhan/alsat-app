import 'package:alsat/app/common/const/image_path.dart';
import 'package:alsat/app/components/custom_appbar.dart';
import 'package:alsat/config/theme/app_text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ProductDetailsView extends StatefulWidget {
  const ProductDetailsView({super.key});

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppbar(
              isShowFilter: false,
              isShowSearch: false,
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(
                  horizontal: 20  .w,
                  vertical: 10.h,
                ),
                children: [
                  //product Image
                  SizedBox(
                    height: 200.h,
                    width: Get.width,
                    child: Stack(
                      alignment: Alignment.center,
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          'assets/images/car_demo2.png',
                          fit: BoxFit.fill,
                          width: Get.width,
                        ),
                        Column(
                          children: [
                            Container(
                              padding: EdgeInsets.only(
                                top: 8.h,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Image.asset(
                                    shareIcon,
                                    height: 30.h,
                                  ),
                                  8.horizontalSpace,
                                  Image.asset(
                                    favoriteIcon,
                                    height: 30.h,
                                  ),
                                  8.horizontalSpace,
                                  Image.asset(
                                    moreIcon,
                                    height: 20.h,
                                  ),
                                  30.horizontalSpace,
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  //price and name
                  8.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hyundai Santa Fe',
                            style: bold.copyWith(
                              fontSize: 14.sp,
                            ),
                          ),
                          3.verticalSpace,
                          Text(
                            '232\$',
                            style: semiBold.copyWith(
                              fontSize: 14.sp,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          // padding: EdgeInsets.all(value),
                          side: BorderSide(
                            color: Get.theme.primaryColor,
                          ),
                          backgroundColor:
                              Get.theme.primaryColor.withOpacity(.1),
                          elevation: 0,
                        ),
                        onPressed: () {},
                        label: Text(
                          '3 Days Ago',
                          style: regular.copyWith(
                            fontSize: 12.sp,
                            color: Get.theme.primaryColor,
                          ),
                        ),
                        icon: Icon(
                          Icons.calendar_month,
                          size: 20.r,
                          color: Get.theme.primaryColor,
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
