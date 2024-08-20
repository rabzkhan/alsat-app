import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:glassmorphism/glassmorphism.dart';

class AppHomeView extends StatefulWidget {
  const AppHomeView({super.key});

  @override
  State<AppHomeView> createState() => _AppHomeViewState();
}

class _AppHomeViewState extends State<AppHomeView> {
  bool isShowDrawer = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.gy,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              height: 66.h,
              padding: EdgeInsets.symmetric(
                vertical: 10.h,
                horizontal: 20.w,
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        isShowDrawer = !isShowDrawer;
                      });
                    },
                    icon: const Icon(Icons.menu),
                  ),
                  IconButton.outlined(
                    style: IconButton.styleFrom(
                      side: BorderSide(
                        color: Get.theme.disabledColor.withOpacity(.12),
                      ),
                    ),
                    onPressed: () {},
                    icon: Icon(
                      CupertinoIcons.bell,
                      size: 22.r,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(CupertinoIcons.search),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.filter_alt_outlined),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  Container(
                    color: Colors.grey.shade200,
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 80.h,
                          color: Colors.blue,
                        ),
                      ],
                    ),
                  ),
                  if (isShowDrawer)
                    GlassmorphicContainer(
                      width: Get.width * .6,
                      height: double.infinity,
                      borderRadius: 0,
                      blur: 30,
                      alignment: Alignment.bottomCenter,
                      border: 2,
                      linearGradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color(0xFFffffff).withOpacity(0.1),
                            const Color(0xFFFFFFFF).withOpacity(0.5),
                          ],
                          stops: const [
                            0.1,
                            1,
                          ]),
                      borderGradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFFffffff).withOpacity(0.5),
                          Color((0xFFFFFFFF)).withOpacity(0.5),
                        ],
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            leading: CircleAvatar(),
                            title: Text('Alexander Davis'),
                            subtitle: Text('+12548514'),
                          )
                        ],
                      ),
                    ).animate().slideX(
                          duration: 600.ms,
                          curve: Curves.fastOutSlowIn,
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
