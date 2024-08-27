import 'package:alsat/app/common/const/image_path.dart';
import 'package:alsat/app/components/custom_appbar.dart';
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
            CustomAppbar(
              isShowFilter: false,
              isShowSearch: false,
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(
                  horizontal: 15.w,
                  vertical: 10.h,
                ),
                children: [
                  SizedBox(
                    height: 200.h,
                    width: Get.width,
                    child: Stack(
                      alignment: Alignment.center,
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          'assets/images/car_demo2.png',
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
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
