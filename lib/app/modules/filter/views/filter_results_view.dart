import 'package:alsat/config/theme/app_text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/state_manager.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../controllers/filter_controller.dart';
import '../widgets/item_widget.dart';

class FilterResultsView extends GetView<FilterController> {
  const FilterResultsView({super.key});

  @override
  Widget build(BuildContext context) {
    void onRefresh() async {
      controller.applyFilter(
        refresh: true,
        paginate: false,
      );
    }

    void onLoading() async {
      controller.applyFilter(
        paginate: true,
        nextValue: controller.itemList.last.createdAt,
      );
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Obx(() => Text(
              "Results Found : ${controller.itemList.length}",
              style: bold.copyWith(
                fontSize: 16.sp,
                color: Colors.grey,
              ),
            )),
      ),
      body: Obx(
        () {
          if (controller.itemList.isEmpty) {
            return Center(
              child: Text(
                "No matching results found!",
                style: medium.copyWith(color: Colors.grey),
              ),
            );
          }
          return SmartRefresher(
            enablePullDown: true,
            enablePullUp: true,
            header: const WaterDropHeader(),
            controller: controller.refreshController,
            onRefresh: onRefresh,
            onLoading: onLoading,
            child: ListView.builder(
              padding: EdgeInsets.only(top: 10.h),
              itemCount: controller.itemList.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int index) {
                return ItemWidget(
                  itemModel: controller.itemList[index],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
