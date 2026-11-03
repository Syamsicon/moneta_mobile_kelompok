import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moneta/models/alokasi_model.dart';
import 'package:moneta/services/alokasi_service.dart';

class AlokasiController extends GetxController {
  final _service = Get.find<AlokasiService>();

  final incomeController = TextEditingController();
  final selectedNavIndex = 2.obs; // 0 = Riwayat, 1 = Dashboard, 2 = Alokasi

  RxDouble get monthlyIncome => _service.monthlyIncome;
  RxList<AlokasiModel> get kategoriList => _service.kategoriList;
  RxInt get applyVersion => _service.version;

  List<AlokasiModel> get selectedKategori =>
      kategoriList.where((c) => c.isSelected).toList();

  double get totalAlokasi =>
      selectedKategori.fold(0.0, (sum, c) => sum + c.amount);

  @override
  void onInit() {
    super.onInit();
    _syncText(monthlyIncome.value);
    incomeController.addListener(
      () => _service.setIncome(double.tryParse(incomeController.text) ?? 0.0),
    );
    // Income changed from outside (recommendation applied) -> update the field.
    ever<double>(monthlyIncome, _syncText);
  }

  void _syncText(double v) {
    if ((double.tryParse(incomeController.text) ?? 0.0) == v) return; // avoid loop
    incomeController.text = v > 0 ? v.toInt().toString() : '';
  }

  void changeNavIndex(int index) => selectedNavIndex.value = index;

  void updateAlokasi(String id, double nominal) {
    if (nominal > monthlyIncome.value) {
      final name = kategoriList.firstWhereOrNull((c) => c.id == id)?.name ?? '';
      Get.snackbar('Peringatan', 'Alokasi untuk $name melebihi total pendapatan!');
      return;
    }
    _service.updateAmount(id, nominal);
  }

  void toggleSelection(String id, bool? value) =>
      _service.toggle(id, value ?? false);

  void hideKategori(String id) => toggleSelection(id, false);
  void showKategori(String id) => toggleSelection(id, true);

  @override
  void onClose() {
    incomeController.dispose();
    super.onClose();
  }
}