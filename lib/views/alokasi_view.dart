

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moneta/controllers/alokasi_controller.dart';
import 'package:moneta/routes/app_routes.dart';
import 'package:moneta/theme/app_colors.dart';
import 'package:moneta/widgets/top_nav_bar.dart';

class AlokasiView extends GetView<AlokasiController> {
  const AlokasiView({super.key});

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
            SizedBox(height: 8),

            // main content
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppColors.sheetWhite,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 200,
                        child: Obx(() {
                          final selected = controller.selectedKategori;
                          final income = controller.monthlyIncome.value;

                          if (income <= 0) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.pie_chart_outline,
                                    size: 48,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Masukkan pendapatan terlebih dahulu',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          double totalAllocated = selected.fold(
                            0,
                            (sum, item) => sum + item.amount,
                          );
                          double remaining = income - totalAllocated;

                          List<PieChartSectionData> sections = [];

                          for (int i = 0; i < selected.length; i++) {
                            final item = selected[i];
                            double percentage = (item.amount / income) * 100;

                            sections.add(
                              PieChartSectionData(
                                color: item.color,
                                value: item.amount,
                                title: item.amount > 0
                                    ? '${percentage.toStringAsFixed(0)}%'
                                    : '',
                                radius: 45,
                                titleStyle: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          }

                          if (remaining > 0) {
                            double remainingPercentage =
                                (remaining / income) * 100;
                            sections.add(
                              PieChartSectionData(
                                color: Colors.grey.shade300,
                                value: remaining,
                                title:
                                    '${remainingPercentage.toStringAsFixed(0)}%',
                                radius: 40,
                                titleStyle: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            );
                          }

                          return PieChart(
                            PieChartData(
                              sectionsSpace: 2,
                              centerSpaceRadius: 45,
                              sections: sections,
                            ),
                          );
                        }),
                      ),

                      const SizedBox(height: 12),

                      Obx(() {
                        final selected = controller.selectedKategori;
                        if (selected.isEmpty) return const SizedBox.shrink();

                        return Wrap(
                          spacing: 12,
                          runSpacing: 6,
                          alignment: WrapAlignment.start,
                          children: [
                            ...List.generate(selected.length, (index) {
                              final item = selected[index];
                              return Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      color: item.color,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    item.name,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              );
                            }),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Text(
                                  'Sisa Belum Dialokasikan',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.blueGrey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      }),

                      const SizedBox(height: 20),

                      Row(
                        spacing: 8.0,
                        children: [
                          IconButton.filled(
                            onPressed: () => _showCategoryOverlay(context),
                            tooltip: "Tambah kategori",
                            icon: const Icon(Icons.add),
                          ),
                          Expanded(
                            child: TextField(
                              controller: controller.incomeController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: "Pendapatan (Rp)",
                                border: OutlineInputBorder(),
                                isDense: true,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Get.toNamed(AppRoutes.rekomendasi);
                            },
                            icon: const Icon(Icons.lightbulb_outline),
                            tooltip: "Rekomendasi",
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        "Alokasi per kategori",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),

                      Obx(() {
                        final selected = controller.selectedKategori;
                        if (selected.isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Center(
                              child: Text(
                                'Belum ada kategori aktif. Klik tombol "Kategori" di atas.',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                            ),
                          );
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: selected.length,
                          itemBuilder: (context, index) {
                            final item = selected[index];

                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              elevation: 1.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  spacing: 8.0,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(item.icon, color: item.color),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        spacing: 4.0,
                                        children: [
                                          Text(
                                            item.name,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          TextFormField(
                                            key: ValueKey(
                                              '${item.id}_${controller.applyVersion.value}',
                                            ),
                                            initialValue: item.amount
                                                .toInt()
                                                .toString(),
                                            keyboardType: TextInputType.number,
                                            decoration: const InputDecoration(
                                              isDense: true,
                                              border: OutlineInputBorder(),
                                              prefixText: 'Rp ',
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 8,
                                                  ),
                                            ),
                                            onChanged: (val) {
                                              double amount =
                                                  double.tryParse(val) ?? 0.0;
                                              controller.updateAlokasi(
                                                item.id,
                                                amount,
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete_outline,
                                        color: Colors.red,
                                      ),
                                      onPressed: () =>
                                          controller.hideKategori(item.id),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCategoryOverlay(BuildContext context) {
    
    Get.bottomSheet(
      Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: Wrap(
          children: [
            const Text(
              'Pilih Kategori Alokasi',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            SizedBox(
              height: 300,
              child: Obx(() {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: controller.kategoriList.length,
                  itemBuilder: (context, index) {
                    final kat = controller.kategoriList[index];
                    return CheckboxListTile(
                      secondary: Icon(kat.icon, color: kat.color),
                      title: Text(kat.name),
                      value: kat.isSelected,
                      onChanged: (bool? value) {
                        controller.toggleSelection(kat.id, value);
                      },
                    );
                  },
                );
              }),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () => Get.back(),
                child: const Text('Selesai'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
