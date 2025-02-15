import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../modules/product/controller/product_details_controller.dart';
import '../modules/product/view/product_details_view.dart';
import 'custom_snackbar.dart';

class PrePostLoading extends StatefulWidget {
  final String postId;
  const PrePostLoading({super.key, required this.postId});

  @override
  State<PrePostLoading> createState() => _PrePostLoadingState();
}

class _PrePostLoadingState extends State<PrePostLoading> {
  @override
  void initState() {
    init();
    super.initState();
  }

  init() {
    final ProductDetailsController controller =
        Get.put(ProductDetailsController(), tag: widget.postId);
    controller.getSingleProductDetails(widget.postId).then((value) {
      if (controller.selectPostProductModel.value?.id == null) {
        CustomSnackBar.showCustomToast(message: 'Product Not Found');
        Get.back();
      } else {
        Get.off(() => ProductDetailsView(
              productModel: controller.selectPostProductModel.value,
            ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CupertinoActivityIndicator(),
      ),
    );
  }
}
