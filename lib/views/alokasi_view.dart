import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moneta/controllers/alokasi_controller.dart';
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
                      const SizedBox(height: 8),
                      // Konten utama
                      SizedBox(
                        height: 220,
                        child: Obx(() {
                          if (controller.selectedKategori.isEmpty) {
                            return Center(
                              child: Text('Belum ada kategori yang dipilih'),
                            );
                          }
                          return PieChart(
                            PieChartData(
                              sectionsSpace: 2,
                              centerSpaceRadius: 40,
                              sections: controller.selectedKategori
                                  .asMap()
                                  .entries
                                  .map((entry) {
                                    final index = entry.key;
                                    final item = entry.value;
                                    final colors = [
                                      Colors.blue,
                                      Colors.green,
                                      Colors.orange,
                                      Colors.purple,
                                      Colors.red,
                                      Colors.teal,
                                    ];
                                    final color = colors[index % colors.length];

                                    double percentage =
                                        controller.monthlyIncome.value > 0
                                        ? (item.amount /
                                                  controller
                                                      .monthlyIncome
                                                      .value) *
                                              100
                                        : 0;

                                    return PieChartSectionData(
                                      color: color,
                                      value: item.amount > 0 ? item.amount : 1,
                                      title:
                                          '${percentage.toStringAsFixed(1)}%',
                                      radius: 50,
                                      titleStyle: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    );
                                  })
                                  .toList(),
                            ),
                          );
                        }),
                      ),
                      SizedBox(height: 20),
                      Row(
                        spacing: 8.0,
                        children: [
                          IconButton.filled(
                            onPressed: () => _showCategoryOverlay(context),
                            tooltip: "Tambah kategori",
                            icon: Icon(Icons.add),
                          ),
                          Expanded(
                            child: TextField(
                              controller: controller.incomeController,
                              keyboardType: .number,
                              decoration: InputDecoration(
                                labelText: "Pendapatan (Rp)",
                                border: OutlineInputBorder(),
                                isDense: true,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => {
                              // pindah halaman ke rekomendasi
                            },
                            icon: Icon(Icons.lightbulb_outline),
                            tooltip: "Rekomendasi",
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Alokasi per kategori",
                        style: TextStyle(fontSize: 18, fontWeight: .bold),
                      ),
                      Obx(() {
                        final selected = controller.selectedKategori;
                        if (selected.isEmpty) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Center(
                              child: Text(
                                'Belum ada kategori aktif. Klik tombol "Kategori" di atas.',
                              ),
                            ),
                          );
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: selected.length,
                          itemBuilder: (context, index) {
                            final item = selected[index];
                            return Card(
                              margin: EdgeInsets.symmetric(vertical: 4),
                              elevation: 2.0,
                              child: Padding(
                                padding: EdgeInsetsGeometry.all(8.0),
                                child: Row(
                                  spacing: 8.0,
                                  crossAxisAlignment: .start,
                                  children: [
                                    Icon(item.icon, color: Colors.blue),
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        crossAxisAlignment: .start,
                                        spacing: 8.0,
                                        children: [
                                          Text(item.name),
                                          TextFormField(
                                            initialValue: item.amount
                                                .toInt()
                                                .toString(),
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              isDense: true,
                                              border: OutlineInputBorder(),
                                              prefixText: 'Rp ',
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
            Obx(() {
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.kategoriList.length,
                itemBuilder: (context, index) {
                  final kat = controller.kategoriList[index];
                  return CheckboxListTile(
                    secondary: Icon(kat.icon),
                    title: Text(kat.name),
                    value: kat.isSelected,
                    onChanged: (bool? value) {
                      controller.toggleSelection(kat.id, value);
                    },
                  );
                },
              );
            }),
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
