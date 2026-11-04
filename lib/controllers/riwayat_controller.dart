import 'package:get/get.dart';
import '../models/transaction_model.dart';

class RiwayatController extends GetxController {

  final selectedNavIndex = 0.obs; // 0 = Riwayat, 1 = Dashboard, 2 = Alokasi
  final transactions = <TransactionModel>[].obs;

  @override
  void onInit(){
    super.onInit();
    transactions.addAll(
      List.generate(
        6, 
        (i) => TransactionModel(
          id: '${i + 1}',
          merchantName: 'KopKen', 
          date: DateTime.parse("2026-10-30").subtract(Duration(days: i)).toIso8601String(),
          location: 'Lokasi',
          amount: -28000
        ),  
      ),
    );
  }

  void changeNavIndex(int index) {
    selectedNavIndex.value = index;
  }

  void onSettingsClick() {
    Get.snackbar('Pengaturan', 'Fitur pengaturan segera hadir');
  }

  void onQuickAddClick() {
    Get.snackbar('Quick Add', 'Fitur Quick Add segera hadir');
  }
}
