import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moneta/models/alokasi_model.dart';
import 'package:moneta/models/kategori_catalog.dart';
import 'package:moneta/models/rekomendasi_model.dart';
import 'package:moneta/services/alokasi_service.dart';
import 'package:moneta/theme/app_colors.dart';

class RekomendasiController extends GetxController {
  static const _pendapatan = 5000000;
  static const _pengeluaran = 4200000;

  final _alokasi = Get.find<AlokasiService>();

  final berdasarkanPendapatan = <RekomendasiModel>[].obs;
  final berdasarkanPengeluaran = <RekomendasiModel>[].obs;
  final sedangDipakai = Rxn<RekomendasiModel>();
  final isLoading = false.obs;
  final errorMessage = RxnString();

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      berdasarkanPendapatan.assignAll([
        _dariPersen('50/30/20', _pendapatan, 50, 30, 20),
        _dariPersen('60/30/10', _pendapatan, 60, 30, 10),
        _dariPersen('70/20/10', _pendapatan, 70, 20, 10),
      ]);
      berdasarkanPengeluaran.assignAll([
        _dariPersen('Dari pola pengeluaranmu', _pengeluaran, 55, 25, 20),
      ]);
    } catch (_) {
      errorMessage.value = 'Gagal memuat rekomendasi';
    } finally {
      isLoading.value = false;
    }
  }

  void pakai(RekomendasiModel rekomendasi) {
    sedangDipakai.value = rekomendasi;
    try {
      _alokasi.terapkan(rekomendasi); 
      Get.back();
    } finally {
      sedangDipakai.value = null;
    }
  }

  Future<void> konfirmasiPakai(RekomendasiModel rekomendasi) async {
  if (sedangDipakai.value != null) return; // ignore double taps

    final income = _alokasi.monthlyIncome.value;
    final catatan = income > 0
        ? 'Nominal akan disesuaikan dengan pendapatanmu saat ini.'
        : 'Pendapatan akan diisi otomatis sesuai rekomendasi.';

    final ok = await Get.dialog<bool>(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: .circular(8.0)
        ),
        backgroundColor: AppColors.background,
        title: const Text('OverWrite', style: TextStyle(fontWeight: .w500),),
        content: Text(
          'Apakah anda yakin ingin mengganti keseluruhan alokasi anda?'
        ),
        actions: [
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.error
            ),
            onPressed: () => Get.back(result: false),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.grey
            ),
            onPressed: () => Get.back(result: true),
            child: const Text('Ya, pakai'),
          ),
        ],
      ));

    if (ok != true) return;
    
     pakai(rekomendasi);
  }

}

  RekomendasiModel _dariPersen(
    String nama,
    int total,
    int kebutuhan,
    int keinginan,
    int tabungan,
  ) {
    int bagian(int persen) => total * persen ~/ 100;
    final k = bagian(kebutuhan);
    final w = bagian(keinginan);
    final s = bagian(tabungan);

    final nominal = [
      (KategoriCatalog.makanMinum, k * 40 ~/ 100),
      (KategoriCatalog.tempatTinggal, k * 30 ~/ 100),
      (KategoriCatalog.transportasi, k * 15 ~/ 100),
      (KategoriCatalog.tagihan, k * 15 ~/ 100),
      (KategoriCatalog.hiburan, w * 60 ~/ 100),
      (KategoriCatalog.tabungan, s * 60 ~/ 100),
    ];

    return RekomendasiModel(
      nama: nama,
      basis: total.toDouble(),
      daftarAlokasi: [
        for (final (kategori, nom) in nominal)
          AlokasiModel(kategori: kategori, amount: nom.toDouble(), isSelected: true),
      ],
    );
  }