import 'package:alsat/app/common/const/image_path.dart';
import 'package:alsat/app/components/custom_appbar.dart';
import 'package:alsat/app/components/product_grid_tile.dart';
import 'package:alsat/app/modules/product/view/product_insights_view.dart';
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
              isShowBackButton: true,
              isShowFilter: false,
              isShowSearch: false,
            ),
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: 20.w,
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
                            style: semiBold.copyWith(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          6.verticalSpace,
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
                              width: 1.5,
                            ),
                            backgroundColor:
                                Get.theme.primaryColor.withOpacity(.1),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            )),
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
                  ),
                  10.verticalSpace,
                  //  information
                  Text(
                    'Information',
                    style: bold.copyWith(
                      fontSize: 18.sp,
                    ),
                  ),
                  10.verticalSpace,
                  Container(
                    padding: REdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: Get.theme.disabledColor.withOpacity(.06),
                      ),
                      color: Get.theme.disabledColor.withOpacity(.03),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        infoTile(name: 'Brand', value: 'Test'),
                        infoTile(name: 'Body Type', value: 'Test'),
                        infoTile(name: 'Model Type', value: '  Bmw'),
                        infoTile(name: 'Year', value: '2014'),
                        infoTile(name: 'Engine', value: '2025'),

                        ///more
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'More',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Get.theme.primaryColor,
                              ),
                            ),
                            Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Get.theme.primaryColor,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  20.verticalSpace,
                  //  discription
                  Text(
                    'Discription',
                    style: bold.copyWith(
                      fontSize: 18.sp,
                    ),
                  ),
                  6.verticalSpace,
                  Text(
                    'Lorem ipsum is placeholder text commonly used in the graphic, print, and publishing ',
                    style: regular.copyWith(
                      fontSize: 14.sp,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    child: Row(
                      children: [
                        Image.asset(
                          eyeIcon,
                          width: 25.w,
                        ),
                        5.horizontalSpace,
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'views',
                              style: regular.copyWith(
                                fontSize: 14.sp,
                              ),
                            ),
                            Text(
                              '152',
                              style: regular.copyWith(
                                fontSize: 10.sp,
                              ),
                            ),
                          ],
                        ),
                        10.horizontalSpace,
                        Container(
                          color: Get.theme.disabledColor,
                          width: 1.w,
                          height: 15.h,
                        ),
                        10.horizontalSpace,
                        Image.asset(
                          heartIcon,
                          width: 25.w,
                        ),
                        5.horizontalSpace,
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Like',
                              style: regular.copyWith(
                                fontSize: 14.sp,
                              ),
                            ),
                            Text(
                              '152',
                              style: regular.copyWith(
                                fontSize: 10.sp,
                              ),
                            ),
                          ],
                        ),
                        10.horizontalSpace,
                        Container(
                          color: Get.theme.disabledColor,
                          width: 1.w,
                          height: 15.h,
                        ),
                        10.horizontalSpace,
                        Image.asset(
                          messageIcon,
                          width: 25.w,
                        ),
                        5.horizontalSpace,
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'comment',
                              style: regular.copyWith(
                                fontSize: 14.sp,
                              ),
                            ),
                            Text(
                              '152',
                              style: regular.copyWith(
                                fontSize: 10.sp,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  ///user information
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(),
                    title: Text(
                      'John Coltrane',
                      style: bold.copyWith(
                        fontSize: 16.sp,
                      ),
                    ),
                    subtitle: Text(
                      'info@gmail.com',
                      style: regular.copyWith(
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                  5.verticalSpace,
                  // more product
                  Text(
                    'More Items From Saravanan B',
                    style: semiBold.copyWith(
                      fontSize: 14.sp,
                    ),
                  ),
                  10.verticalSpace,
                  SizedBox(
                    height: 200.h,
                    child: ListView.separated(
                      separatorBuilder: (context, index) => 10.horizontalSpace,
                      scrollDirection: Axis.horizontal,
                      itemCount: 6,
                      itemBuilder: (context, index) => SizedBox(
                          width: (Get.width * .5) - 20.w,
                          child: const ProductGridTile()),
                    ),
                  ),
                  20.verticalSpace,
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: MaterialButton(
                          padding: EdgeInsets.symmetric(
                            vertical: 14.h,
                            horizontal: 20.w,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            side: BorderSide(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          onPressed: () {
                            Get.to(const ProductInsightsView(),
                                transition: Transition.fadeIn);
                          },
                          child: Text(
                            'Insights',
                            style: regular.copyWith(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ),
                      10.horizontalSpace,
                      Expanded(
                        flex: 3,
                        child: MaterialButton(
                          padding: EdgeInsets.symmetric(
                            vertical: 14.h,
                            horizontal: 20.w,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          elevation: 0,
                          color: Theme.of(context).primaryColor,
                          onPressed: () {},
                          child: Text(
                            'Boost Your Ad',
                            style: regular.copyWith(
                              color: Get.theme.scaffoldBackgroundColor,
                            ),
                          ),
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

Padding infoTile({required String name, required String value}) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 8.h),
    child: Row(
      children: [
        Text(
          name,
          style: regular.copyWith(
            fontSize: 14.sp,
            color: Get.theme.disabledColor,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: regular.copyWith(
            fontSize: 14.sp,
          ),
        ),
      ],
    ),
  );
}
