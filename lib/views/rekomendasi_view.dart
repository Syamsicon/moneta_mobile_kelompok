import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moneta/controllers/rekomendasi_controller.dart';
import 'package:moneta/models/alokasi_model.dart';
import 'package:moneta/models/rekomendasi_model.dart';
import 'package:moneta/theme/app_colors.dart';


class RekomendasiView extends GetView<RekomendasiController> {
  const RekomendasiView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.black, size: 28),
          onPressed: () {
            Get.back();
          },
        ),
        title: const Text(
          'Rekomendasi',
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(color: AppColors.background),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.errorMessage.value != null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(controller.errorMessage.value!),
                  TextButton(
                    onPressed: controller.load,
                    child: const Text('Coba lagi'),
                  ),
                ],
              ),
            );
          }

          final dipakai = controller.sedangDipakai.value;

          Widget section(String judul, List<RekomendasiModel> items) {
            if (items.isEmpty) return const SizedBox.shrink();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _SectionHeader(judul),
                for (final item in items) ...[
                  _RekomendasiCard(
                    rekomendasi: item,
                    isLoading: identical(dipakai, item),
                    enabled: dipakai == null,
                    onPakai: () => controller.konfirmasiPakai(item),
                  ),
                  const Divider(
                    height: 1,
                    thickness: 1,
                    color: Color(0xFFE6E6E6),
                  ),
                ],
              ],
            );
          }

          return RefreshIndicator(
            onRefresh: controller.load,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                section(
                  'Berdasarkan Pendapatan',
                  controller.berdasarkanPendapatan,
                ),
                section(
                  'Berdasarkan Pengeluaran',
                  controller.berdasarkanPengeluaran,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.judul);

  final String judul;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFD3D3D3),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Text(
        judul,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _RekomendasiCard extends StatelessWidget {
  const _RekomendasiCard({
    required this.rekomendasi,
    required this.onPakai,
    this.isLoading = false,
    this.enabled = true,
  });

  final RekomendasiModel rekomendasi;
  final VoidCallback onPakai;
  final bool isLoading;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final entries = rekomendasi.daftarAlokasi.where((e) => e.amount > 0).toList()
      ..sort((a, b) => b.amount.compareTo(a.amount));
    final warna = [for(final kategori in entries) kategori.color];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Column(
        children: [
          Row(
            children: [
              _AlokasiPieChart(data: entries, colors: warna, size: 96),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  children: [
                    for (var i = 0; i < entries.length; i++)
                      _LegendRow(
                        nama: entries[i].name,
                        warna: warna[i],
                        persen: rekomendasi.persenDari(entries[i]),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: _PakaiButton(
              onPressed: enabled ? onPakai : null,
              isLoading: isLoading,
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendRow extends StatelessWidget {
  const _LegendRow({required this.nama, required this.warna, required this.persen});

  final String nama;
  final Color warna;
  final double persen;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: warna,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black12, width: 0.5),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(nama, style: const TextStyle(fontSize: 11))),
          Text(
            '${persen.round()}%',
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _AlokasiPieChart extends StatelessWidget {
  const _AlokasiPieChart({required this.data, required this.colors, this.size = 96});

  final List<AlokasiModel> data;
  final List<Color> colors;
  final double size;

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return SizedBox(width: size, height: size);

    return SizedBox(
      width: size,
      height: size,
      child: PieChart(
        PieChartData(
          startDegreeOffset: 90,
          sectionsSpace: 2,
          borderData: FlBorderData(show: true),
          pieTouchData: PieTouchData(enabled: false),
          sections: [
            for (var i = 0; i < data.length; i++)
              PieChartSectionData(
                value: data[i].amount,
                color: colors[i],
                radius: size / 2,
                showTitle: false,
              ),
          ],
        ),
      ),
    );
  }
}


Color _shade(int i, int n) => Color.lerp(
      const Color(0xFF000000),
      const Color(0xFFEBEBEB),
      n <= 1 ? 0 : i / (n - 1),
    )!;

class _PakaiButton extends StatelessWidget {
  const _PakaiButton({required this.onPressed, required this.isLoading});

  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 26,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.black54,
          disabledForegroundColor: Colors.white70,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 28),
          shape: const StadiumBorder(),
          textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
        ),
        child: isLoading
            ? const SizedBox(
                width: 12,
                height: 12,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Text('Pakai'),
      ),
    );
  }
}
