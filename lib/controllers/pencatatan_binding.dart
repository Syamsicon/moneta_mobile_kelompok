import 'package:get/get.dart';
import 'pencatatan_controller.dart';

class PencatatanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PencatatanController>(() => PencatatanController());
  }
}
