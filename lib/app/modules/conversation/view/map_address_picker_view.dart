import 'dart:async';
import 'dart:developer';

import 'package:alsat/app/modules/conversation/controller/conversation_controller.dart';
import 'package:alsat/app/modules/product/controller/product_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../components/custom_appbar.dart';

class LocationFromMapView extends StatefulWidget {
  const LocationFromMapView({super.key});

  @override
  State<LocationFromMapView> createState() => _LocationFromMapViewState();
}

class _LocationFromMapViewState extends State<LocationFromMapView> {
  Timer? _debounceTimer;
  final ProductController productController = Get.find();
  final ConversationController conversationController = Get.find();
  void _onCameraMove(CameraPosition position) {
    log('_debounceTimer ${productController.selectPosition}');
    if (_debounceTimer != null && _debounceTimer!.isActive) {
      _debounceTimer!.cancel();
    }

    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      productController.selectPosition = position.target;

      productController.getLatLngToAddress(productController.selectPosition);
    });
  }

  @override
  void initState() {
    intitLocation();
    super.initState();
  }

  intitLocation() {
    if (productController.currentLocation.value == null) {
      productController.getCurrentLocation().then((value) {
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(
              isShowBackButton: true,
              isShowFilter: false,
              isShowSearch: false,
            ),
            Expanded(
              child: Stack(
                children: [
                  productController.currentLocation.value == null
                      ? const Center(
                          child: CupertinoActivityIndicator(
                            color: AppColors.primary,
                          ),
                        )
                      : GoogleMap(
                          zoomControlsEnabled: false,
                          initialCameraPosition: CameraPosition(
                            target: LatLng(
                                productController
                                    .currentLocation.value!.latitude!,
                                productController
                                    .currentLocation.value!.longitude!),
                            zoom: 13.5,
                          ),
                          onMapCreated: (mapController) {
                            productController.mapController
                                .complete(mapController);
                          },
                          onCameraMove: _onCameraMove,
                          myLocationButtonEnabled: true,
                        ),
                  Positioned(
                    bottom: 0,
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(left: 12, right: 12),
                          height: 90.h,
                          width: Get.width,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(.8),
                          ),
                          child: Row(
                            children: [
                              const BackButton(color: Colors.white),
                              Expanded(
                                child: ListTile(
                                  title: Obx(() {
                                    return Text(
                                      productController.placemarks.isEmpty
                                          ? "Location Not Selection"
                                          : "Address:${productController.placemarks.last.street}  ${productController.placemarks.first.subLocality}",
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        color: Colors.white,
                                      ),
                                    );
                                  }),
                                  trailing: Obx(() {
                                    return GestureDetector(
                                      onTap:
                                          productController.placemarks.isEmpty
                                              ? () {
                                                  intitLocation();
                                                }
                                              : () {
                                                  log('${productController.selectPosition}');
                                                  conversationController
                                                      .sendMessage(
                                                    location: productController
                                                        .selectLatLon,
                                                  );
                                                  Get.back();
                                                },
                                      child: Text(
                                        'Send Location',
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          color: Colors.white,
                                        ),
                                      ),
                                    );
                                  }),
                                  subtitle: Obx(() {
                                    return Text(
                                      productController.placemarks.isEmpty
                                          ? "No City"
                                          : "City : ${productController.placemarks.first.administrativeArea}",
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        color: Colors.white,
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                      child: Center(
                    child: Image.asset(
                      "assets/icons/markLogo.png",
                      width: 40,
                      height: 60,
                    ),
                  ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
