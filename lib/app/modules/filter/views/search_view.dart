// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:glassmorphism/glassmorphism.dart';

// import '../../app_home/controller/home_controller.dart';

// class SearchView extends StatefulWidget {
//   const SearchView({super.key});

//   @override
//   State<SearchView> createState() => _SearchViewState();
// }

// class _SearchViewState extends State<SearchView> {
//   @override
//   Widget build(BuildContext context) {
//     HomeController homeController = Get.find<HomeController>();
//     return Obx(() {
//       return homeController.isShowSearch.value
//           ? GlassmorphicContainer(
//               width: Get.width,
//               height: double.infinity,
//               borderRadius: 2,
//               blur: 4,
//               alignment: Alignment.bottomCenter,
//               border: 0,
//               linearGradient: LinearGradient(
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                   colors: [
//                     const Color(0xFFffffff).withOpacity(0.1),
//                     const Color(0xFFFFFFFF).withOpacity(0.8),
//                   ],
//                   stops: const [
//                     0.1,
//                     1,
//                   ]),
//               borderGradient: LinearGradient(
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 colors: [
//                   const Color(0xFFffffff).withOpacity(0.5),
//                   const Color((0xFFFFFFFF)).withOpacity(0.8),
//                 ],
//               ),
//               child: ListView(
//                 children: [
//                   Padding(
//                     padding: EdgeInsets.symmetric(
//                       horizontal: 10.w,
//                       vertical: 20.h,
//                     ).copyWith(
//                       bottom: 0,
//                     ),
//                     child: Column(
//                       children: [
//                         TextField(
//                           decoration: InputDecoration(
//                             hintText: "Search Box",
//                             prefixIcon: const Icon(Icons.search),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10.r),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 15.w),
//                     child: Row(
//                       children: [
//                         Chip(
//                           labelStyle: TextStyle(
//                             fontSize: 13.sp,
//                             color: Get.theme.scaffoldBackgroundColor,
//                           ),
//                           color: WidgetStatePropertyAll(Get.theme.primaryColor),
//                           avatar: Icon(
//                             CupertinoIcons.xmark,
//                             size: 20.r,
//                             color: Get.theme.scaffoldBackgroundColor,
//                           ),
//                           label: const Text("Car History"),
//                           backgroundColor: Get.theme.primaryColor,
//                         ),
//                         10.horizontalSpace,
//                         Chip(
//                           labelStyle: TextStyle(
//                             fontSize: 13.sp,
//                             color: Get.theme.scaffoldBackgroundColor,
//                           ),
//                           color: WidgetStatePropertyAll(Get.theme.primaryColor),
//                           avatar: Icon(
//                             CupertinoIcons.xmark,
//                             size: 20.r,
//                             color: Get.theme.scaffoldBackgroundColor,
//                           ),
//                           label: const Text("Phone"),
//                           backgroundColor: Get.theme.primaryColor,
//                         ),
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//             )
//           : const Center();
//     });
//   }
// }
