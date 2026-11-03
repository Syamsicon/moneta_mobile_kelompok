import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moneta/models/alokasi_model.dart';

class AlokasiController extends GetxController {
  final incomeController = TextEditingController();
  var monthlyIncome = 0.0.obs;

  var kategoriList = <AlokasiModel>[].obs;

  final selectedNavIndex = 2.obs; // 0 = Riwayat, 1 = Dashboard, 2 = Alokasi

  List<AlokasiModel> get selectedKategori =>
      kategoriList.where((category) => category.isSelected).toList();

  double get totalAlokasi => selectedKategori.fold(
    0.0,
    (sum, category) => sum + (category.isSelected ? category.amount : 0),
  );

  @override
  void onInit() {
    super.onInit();
    kategoriList.addAll([
      AlokasiModel(
        id: '1',
        name: 'Kebutuhan Pokok (Makan/Transport)',
        icon: Icons.fastfood,
        color: Colors.blue,
        isSelected: true,
        amount: 0,
      ),
      AlokasiModel(
        id: '2',
        name: 'Tabungan & Investasi',
        icon: Icons.savings,
        color: Colors.green,
        isSelected: true,
        amount: 0,
      ),
      AlokasiModel(
        id: '3',
        name: 'Hiburan & Hobi',
        icon: Icons.sports_esports,
        color: Colors.orange,
        isSelected: false,
        amount: 0,
      ),
      AlokasiModel(
        id: '4',
        name: 'Tagihan & Cicilan',
        icon: Icons.receipt_long,
        color: Colors.purple,
        isSelected: false,
        amount: 0,
      ),
      AlokasiModel(
        id: '5',
        name: 'Dana Darurat',
        icon: Icons.security,
        color: Colors.red,
        isSelected: false,
        amount: 0,
      ),
    ]);
    incomeController.addListener(() {
      double val = double.tryParse(incomeController.text) ?? 0.0;
      monthlyIncome.value = val;
    });
  }

  void changeNavIndex(int index) {
    selectedNavIndex.value = index;
  }

  void updateAlokasi(String id, double nominal) {
    final idx = kategoriList.indexWhere((category) => category.id == id);
    if (idx != -1) {
      if (nominal > monthlyIncome.value) {
        Get.snackbar(
          "Peringatan",
          "Alokasi untuk ${kategoriList[idx].name} melebihi total pendapatan!",
        );
      } else {
        kategoriList[idx].amount = nominal;
        kategoriList.refresh();
      }
    }
  }

  void toggleSelection(String id, bool? value) {
    final idx = kategoriList.indexWhere((category) => category.id == id);
    if (idx != -1) {
      kategoriList[idx].isSelected = value ?? false;
      if (!kategoriList[idx].isSelected) {
        kategoriList[idx].amount = 0.0; // Reset kalau di unselect
      }
      kategoriList.refresh();
    }
  }

  void hideKategori(String id) {
    toggleSelection(id, false);
  }

  void showKategori(String id) {
    toggleSelection(id, true);
  }

  void goToRecommendation() {
    Get.snackbar('Rekomendasi', 'Fitur rekomendasi segera hadir');
  }

  @override
  void onClose() {
    incomeController.dispose();
    super.onClose();
  }
}
