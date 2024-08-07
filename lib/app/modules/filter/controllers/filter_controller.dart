import 'dart:convert';
import 'dart:developer';

import 'package:alsat/app/modules/filter/models/item_model.dart';
import 'package:alsat/app/modules/filter/views/filter_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:logger/logger.dart';
import '../../../../utils/constants.dart';
import '../../../services/base_client.dart';
import '../views/filter_results_view.dart';

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
  RxList<String> dcolor = <String>["Red", "Black", "Silver", "Blue", "White", "Marron"].obs;

  // RxInt priceFrom = 0.obs;
  // RxInt priceTo = 100000.obs;
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

  applyFilter() async {
    var filterData = {
      // "location": location.value != "Not Chosen Yet" ? location.value : '',
      // "condition": condition.value,
      "price_from": int.parse(priceFrom.value.text),
      "price_to": int.parse(priceTo.value.text)
      // "brand": brand.value != "Not Chosen Yet" ? brand.value : '',
      // "model": model.value != "Not Chosen Yet" ? model.value : '',
      // "body_type": bodyType.value != "Not Chosen Yet" ? bodyType.value : '',
      // "drive_type": driveType.value != "Not Chosen Yet" ? driveType.value : '',
      // "engine_type": engineType.value != "Not Chosen Yet" ? engineType.value : '',
      // "transmission": transmission.value != "Not Chosen Yet" ? transmission.value : '',
      // "year_from": 2000,
      // "year_to": 2024,
      // "color": color.value != "Not Chosen Yet" ? color.value : '',
      // "mileage_from": 0,
      // "mileage_to": 100000,
      // "credit": credit.value,
      // "exchange": exchange.value,
      // "has_vin_code": hasVinCode.value
    };
    Logger().d(json.encode(filterData).toString());
    await BaseClient.safeApiCall(
      Constants.baseUrl + Constants.filter,
      RequestType.get,
      queryParameters: {
        "limit": 20,
        // "next": "",
      },
      data: json.encode(filterData),
      onLoading: () {
        isFilterLoading.value = true;
      },
      onSuccess: (response) {
        List<dynamic> jsonResponse = response.data;
        // Map the JSON response to a list of ItemModel
        itemList.value = jsonResponse.map((item) => ItemModel.fromJson(item)).toList();
        isFilterLoading.value = false;
        Get.to(() => const FilterResultsView());
      },
      onError: (error) {
        Logger().d("$error <- error");
        isFilterLoading.value = false;
      },
    );
  }
}
