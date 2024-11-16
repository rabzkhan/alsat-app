import 'dart:convert';
import 'dart:math';
import 'package:alsat/app/modules/filter/models/item_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:logger/logger.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../../utils/constants.dart';
import '../../../services/base_client.dart';
import '../views/filter_results_view.dart';

class FilterController extends GetxController {
  RxList<String> dummyImage = <String>[
    "https://imgd.aeplcdn.com/664x374/n/cw/ec/110233/camry-exterior-right-front-three-quarter-3.jpeg?isig=0&q=80",
    "https://imgd.aeplcdn.com/1200x900/cw/ec/37333/Toyota-Corolla-Altis-Exterior-142776.jpg?wm=0",
    "https://www.team-bhp.com/sites/default/files/pictures2021/0%20Initial.JPG",
    "https://cdn.motor1.com/images/mgl/bgg7xl/s1/2022-bmw-m3-touring.jpg",
    "https://imgd.aeplcdn.com/664x374/n/cw/ec/178535/c-class-exterior-right-front-three-quarter.jpeg?isig=0&q=80",
    "https://stimg.cardekho.com/images/carexteriorimages/930x620/Tesla/Model-X/5253/1611841733029/front-left-side-47.jpg",
    "https://s3-prod.autonews.com/s3fs-public/CYBERTRUCK-MAIN_i_5.jpg",
    "https://cdn.motor1.com/images/mgl/WRMx1/s3/mercedes-amg-g-class-with-v12-engine-from-brabus.jpg"
  ].obs;

  String getRandomImageUrl() {
    final random = Random();
    int index = random.nextInt(dummyImage.length);
    return dummyImage[index];
  }

  RxBool isFilterLoading = false.obs;

  RxString category = "Automobile".obs;
  RxString condition = "Used".obs;

  RxString location = "Not Chosen Yet".obs;
  RxString brand = "Not Chosen Yet".obs;
  RxString model = "Not Chosen Yet".obs;
  RxString bodyType = "Not Chosen Yet".obs;
  RxString driveType = "Not Chosen Yet".obs;
  RxString engineType = "Not Chosen Yet".obs;
  RxString transmission = "Not Chosen Yet".obs;
  RxString color = "Not Chosen Yet".obs;

  RxList<String> dlocation = <String>["New York", "Texas"].obs;
  RxList<String> dbrand =
      <String>["Toyota", "Honda", "Bmw", "Volvo", "Audi", "Mercedes Benz"].obs;
  RxList<String> dmodel =
      <String>["Camry", "Corolla", "X3", "XC60", "A6", "C-Class"].obs;
  RxList<String> dbodyType =
      <String>["Coupe", "Sedan", "Suv", "Hatchback", "Crossover", "Van"].obs;
  RxList<String> ddriveType = <String>['RWD', 'FWD', 'AWD', '4WD'].obs;
  RxList<String> dengineType = <String>["1.0", "1.3", "1.5", "1.7", "2.0"].obs;
  RxList<String> dtransmission = <String>["Manual", "Auto", "Tiptronic"].obs;
  RxList<String> dcolor =
      <String>["Red", "Black", "Silver", "Blue", "White", "Maroon"].obs;

  Rx<TextEditingController> priceFrom = TextEditingController(text: "0").obs;
  Rx<TextEditingController> priceTo = TextEditingController(text: "300000").obs;

  RxInt yearFrom = 1995.obs;
  RxInt yearTo = 2020.obs;

  RxInt mileageFrom = 5000.obs;
  RxInt mileageTo = 100000.obs;

  RxBool credit = false.obs;
  RxBool exchange = false.obs;
  RxBool hasVinCode = false.obs;

  RxList<ItemModel> itemList = <ItemModel>[].obs;
  Rx<ItemModel> itemModel = ItemModel().obs;

  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  applyFilter(
      {bool refresh = false, bool paginate = false, String? nextValue}) async {
    var filterData = {
      "location": location.value != "Not Chosen Yet" ? location.value : '',
      "condition": condition.value,
      "price_from": int.parse(priceFrom.value.text),
      "price_to": int.parse(priceTo.value.text),
      "brand": brand.value != "Not Chosen Yet" ? brand.value : '',
      "model": model.value != "Not Chosen Yet" ? model.value : '',
      "body_type": bodyType.value != "Not Chosen Yet" ? bodyType.value : '',
      //"drive_type": driveType.value != "Not Chosen Yet" ? driveType.value : '',
      //"engine_type": engineType.value != "Not Chosen Yet" ? engineType.value : '',
      "transmission":
          transmission.value != "Not Chosen Yet" ? transmission.value : '',
      // "year_from": 2000,
      // "year_to": 2024,
      //"color": color.value != "Not Chosen Yet" ? color.value : '',
      // "mileage_from": 0,
      // "mileage_to": 100000,
      "credit": credit.value,
      // "exchange": exchange.value,
      // "has_vin_code": hasVinCode.value
    };

    await BaseClient.safeApiCall(
      Constants.baseUrl + Constants.filter,
      DioRequestType.get,
      queryParameters: {
        "limit": 30,
        if (!refresh && paginate && nextValue != null) "next": nextValue,
      },
      data: json.encode(filterData),
      onLoading: () {
        isFilterLoading.value = true;
      },
      onSuccess: (response) {
        List<dynamic> jsonResponse = response.data;

        List<ItemModel> newItems =
            jsonResponse.map((item) => ItemModel.fromJson(item)).toList();

        if (newItems.isEmpty) {
          Logger().d("came here");
          refreshController.loadComplete();
        }

        if (!refresh) {
          if (paginate) {
            itemList.addAll(newItems);
            refreshController.loadComplete();
          } else {
            itemList.value = newItems;
            Get.to(() => const FilterResultsView());
          }
        } else {
          itemList.clear();
          itemList.value = newItems;
          refreshController.refreshCompleted();
        }
        isFilterLoading.value = false;
      },
      onError: (error) {
        Logger().d("$error <- error");
        isFilterLoading.value = false;
      },
    );
  }
}
