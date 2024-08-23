import 'package:alsat/app/modules/app_home/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:glassmorphism/glassmorphism.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    HomeController homeController = Get.find<HomeController>();
    return Obx(() {
      return (homeController.isShowDrawer.value)
          ? GlassmorphicContainer(
              width: Get.width * .6,
              height: double.infinity,
              borderRadius: 2,
              blur: 10,
              alignment: Alignment.bottomCenter,
              border: 0,
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
              child: const Column(
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
                begin: -2,
                curve: Curves.fastOutSlowIn,
              )
          : const Center();
    });
  }
}
