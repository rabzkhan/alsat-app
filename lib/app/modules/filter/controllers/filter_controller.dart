import 'dart:convert';
import 'dart:developer';

import 'package:alsat/app/modules/filter/models/item_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:logger/logger.dart';
import '../../../../utils/constants.dart';
import '../../../services/base_client.dart';

class FilterController extends GetxController {
  RxBool isFilterLoading = false.obs;

  RxString category = "Automobile".obs;
  RxString condition = "All".obs;

  RxString location = "Not Chosen Yet".obs;
  RxString brand = "Not Chosen Yet".obs;
  RxString model = "Not Chosen Yet".obs;
  RxString bodyType = "Not Chosen Yet".obs;
  RxString driveType = "Not Chosen Yet".obs;
  RxString engineType = "Not Chosen Yet".obs;
  RxString transmission = "Not Chosen Yet".obs;
  RxString color = "Not Chosen Yet".obs;

  RxList<String> dlocation = <String>["New York", "Texas"].obs;
  RxList<String> dbrand = <String>["Toyota", "Honda", "Bmw", "Volvo", "Audi", "Mercedes Benz"].obs;
  RxList<String> dmodel = <String>["Camry", "Corolla", "X3", "XC60", "A6", "C-Class"].obs;
  RxList<String> dbodyType = <String>["Coupe", "Sedam", "Suv", "Hatchback", "Crossover", "Van"].obs;
  RxList<String> ddriveType = <String>['RWD', 'FWD', 'AWD', '4WD'].obs;
  RxList<String> dengineType = <String>["1.0", "1.3", "1.5", "1.7", "2.0"].obs;
  RxList<String> dtransmission = <String>["Manual", "Auto", "Triptonik"].obs;
  RxList<String> dcolor = <String>["Red", "Blac", "Silver", "Blue", "White", "Marron"].obs;

  // RxInt priceFrom = 0.obs;
  // RxInt priceTo = 100000.obs;
  Rx<TextEditingController> priceFrom = TextEditingController(text: "").obs;
  Rx<TextEditingController> priceTo = TextEditingController(text: "").obs;

  RxInt yearFrom = 1995.obs;
  RxInt yearTo = 2020.obs;

  RxInt mileageFrom = 5000.obs;
  RxInt mileageTo = 100000.obs;

  RxBool credit = false.obs;
  RxBool exchange = false.obs;
  RxBool hasVinCode = false.obs;

  RxList<ItemModel> itemList = <ItemModel>[].obs;
  Rx<ItemModel> itemModel = ItemModel().obs;

  applyFilter() async {
    Map filterData = {
      // "category": "Automobile",
      // "location": "New York",
      // "condition": "Used",
      "price_from": 2900,
      "price_to": 3000,
      // "brand": "Toyota",
      // "model": "Camry",
      // "body_type": "Sedan",
      // "drive_type": "FWD",
      // "engine_type": "Hybrid",
      // "transmission": "Automatic",
      // "year_from": 2010,
      // "year_to": 2020,
      // "color": "Blue",
      // "mileage_from": 10000,
      // "mileage_to": 100000,
      // "credit": true,
      // "exchange": false,
      // "has_vin_code": true
    };
    Logger().d(jsonEncode(filterData));
    await BaseClient.safeApiCall(
      Constants.baseUrl + Constants.filter,
      RequestType.get,
      headers: {},
      queryParameters: {
        "limit": 2,
        // "next": "",
      },
      data: json.encode(filterData),
      onLoading: () {
        isFilterLoading.value = true;
      },
      onSuccess: (response) {
        itemModel.value = ItemModel.fromJson(response.data);
        itemList.add(itemModel.value);
        isFilterLoading.value = false;
      },
      onError: (error) {
        isFilterLoading.value = false;
      },
    );
  }
}
