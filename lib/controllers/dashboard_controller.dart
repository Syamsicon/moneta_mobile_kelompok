import 'package:get/get.dart';
import '../models/transaction_model.dart';
import '../routes/app_routes.dart';

class DashboardController extends GetxController {
  final userName = 'Sutarman, T'.obs;
  final currentDate = 'Kamis, 13 November 2026'.obs;
  final userInitial = 'T'.obs;

  final selectedNavIndex = 1.obs; // 0 = Riwayat, 1 = Dashboard, 2 = Alokasi
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
          date: '30 Okt',
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
    Get.toNamed(AppRoutes.pencatatan);
  }
}
