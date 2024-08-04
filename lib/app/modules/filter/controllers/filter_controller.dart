import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import '../../../../utils/constants.dart';
import '../../../services/base_client.dart';

class FilterController extends GetxController {
  // getData() async {
  //   await BaseClient.safeApiCall(
  //     Constants.todosApiUrl,
  //     RequestType.get,
  //     onLoading: () {},
  //     onSuccess: (response) {},
  //     onError: (error) {},
  //   );
  // }

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  RxString category = "Automobile".obs;
  RxString condition = "All".obs;

  RxString location = "".obs;
  RxString brand = "".obs;
  RxString model = "".obs;
  RxString bodyType = "".obs;
  RxString driveType = "".obs;
  RxString engineType = "".obs;
  RxString transmission = "".obs;
  RxString color = "".obs;

  RxList<String> dlocation = <String>["New York", "Texas"].obs;
  RxList<String> dbrand = <String>["Toyota", "Honda", "Bmw", "Volvo", "Audi", "Mercedes Benz"].obs;
  RxList<String> dmodel = <String>["Camry", "Corolla", "X3", "XC60", "A6", "C-Class"].obs;
  RxList<String> dbodyType = <String>["Coupe", "Sedam", "Suv", "Hatchback", "Crossover", "Van"].obs;
  RxList<String> ddriveType = <String>['RWD', 'FWD', 'AWD', '4WD'].obs;
  RxList<String> dengineType = <String>["1.0", "1.3", "1.5", "1.7", "2.0"].obs;
  RxList<String> dtransmission = <String>["Manual", "Auto", "Triptonik"].obs;
  RxList<String> dcolor = <String>["Red", "Blac", "Silver", "Blue", "White", "Marron"].obs;

  RxInt priceFrom = 0.obs;
  RxInt priceTo = 100000.obs;

  RxInt yearFrom = 1995.obs;
  RxInt yearTo = 2020.obs;

  RxInt mileageFrom = 5000.obs;
  RxInt mileageTo = 100000.obs;

  RxBool credit = false.obs;
  RxBool exchange = false.obs;
  RxBool hasVinCode = false.obs;
}
