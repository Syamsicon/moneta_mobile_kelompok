import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moneta/controllers/rekomendasi_controller.dart';
import 'package:moneta/models/kelompok_alokasi.dart';
import 'package:moneta/models/rekomendasi_model.dart';
import 'package:moneta/routes/app_routes.dart';
import 'package:moneta/theme/app_colors.dart';

// ============================================================================
// PAGE
// ============================================================================

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
            Get.offAllNamed(AppRoutes.alokasi);
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
                    onPakai: () => controller.pakai(item),
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
              // Keeps pull-to-refresh working even when the content is short.
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

// ============================================================================
// COMPONENTS (private to this page)
// ============================================================================

/// Gray bar that titles each section.
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

/// One recommendation: pie chart, legend with percentages, and the Pakai button.
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
    final persen = rekomendasi.persenPerKelompok;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Column(
        children: [
          Container(
            child: Row(
              children: [
                _AlokasiPieChart(data: persen, size: 96),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    children: [
                      for (final kelompok in KelompokAlokasi.values)
                        _LegendRow(
                          kelompok: kelompok,
                          persen: persen[kelompok] ?? 0,
                        ),
                    ],
                  ),
                ),
              ],
            ),
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

/// Dot + label + percentage row in the legend.
class _LegendRow extends StatelessWidget {
  const _LegendRow({required this.kelompok, required this.persen});

  final KelompokAlokasi kelompok;
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
              color: _warnaKelompok(kelompok),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black12, width: 0.5),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(kelompok.label, style: const TextStyle(fontSize: 11)),
          ),
          Text(
            '${persen.round()}%',
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

/// Small black pill button.
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

/// Grayscale pie chart, drawn without any extra package.
class _AlokasiPieChart extends StatelessWidget {
  const _AlokasiPieChart({required this.data, this.size = 96});

  /// Percentage (or any positive weight) per group.
  final Map<KelompokAlokasi, double> data;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _PiePainter(data)),
    );
  }
}

class _PiePainter extends CustomPainter {
  _PiePainter(this.data);

  final Map<KelompokAlokasi, double> data;

  @override
  void paint(Canvas canvas, Size size) {
    final total = data.values.fold<double>(0, (a, b) => a + b);
    if (total <= 0) return;

    final rect = Offset.zero & size;
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    var start = -math.pi / 2; // start at 12 o'clock
    for (final entry in data.entries) {
      if (entry.value <= 0) continue;
      final sweep = entry.value / total * 2 * math.pi;
      paint.color = _warnaKelompok(entry.key);
      canvas.drawArc(rect, start, sweep, true, paint);
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _PiePainter oldDelegate) =>
      !mapEquals(oldDelegate.data, data);
}

/// Slice and legend colors, matching the grayscale design.
/// TODO: move these into AppColors if you want them in the theme.
Color _warnaKelompok(KelompokAlokasi kelompok) => switch (kelompok) {
  KelompokAlokasi.kebutuhan => const Color(0xFF000000),
  KelompokAlokasi.keinginan => const Color(0xFF8A8A8A),
  KelompokAlokasi.tabungan => const Color(0xFFD3D3D3),
};
