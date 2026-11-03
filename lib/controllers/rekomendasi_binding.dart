import 'package:get/get.dart';
import 'package:moneta/controllers/rekomendasi_controller.dart';

class RekomendasiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RekomendasiController>(() => RekomendasiController());
  }
}