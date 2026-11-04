import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/riwayat_controller.dart';
import '../theme/app_colors.dart';
import '../widgets/quick_add_button.dart';
import '../widgets/top_nav_bar.dart';
import '../widgets/transaction_history_section.dart';

class RiwayatView extends GetView<RiwayatController> {
  const RiwayatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: Column(
          children: [
            // Top Navigation Bar (Fixed at top)
            Obx(
              () => TopNavBar(
                selectedIndex: controller.selectedNavIndex.value,
                onNavTap: controller.changeNavIndex,
              ),
            ),
            const SizedBox(height: 8),

            // Main White Sheet (Scrollable)
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppColors.sheetWhite,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Obx(
                        () => TransactionHistorySection(
                          transaction: controller.transactions.toList(),
                          onViewAll: () {},
                          )
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: QuickAddButton(
        onPressed: controller.onQuickAddClick,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
