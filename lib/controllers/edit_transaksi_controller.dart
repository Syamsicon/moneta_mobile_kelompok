import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/kategori_catalog.dart';
import '../models/transaction_model.dart';
import 'dashboard_controller.dart';
import 'pencatatan_controller.dart';
import 'riwayat_controller.dart';

/// Turunan dari PencatatanController, jadi semua fungsi form
/// (pilih tanggal, kategori, foto, lokasi) tinggal dipakai ulang.
class EditTransaksiController extends PencatatanController {
  late TransactionModel transaksiLama;

  @override
  void onInit() {
    super.onInit();
    // Data transaksi yang dikirim dari halaman Riwayat
    transaksiLama = Get.arguments as TransactionModel;

    // Isi form dengan data lama
    judulController.text = transaksiLama.merchantName;
    nominalController.text = transaksiLama.amount.abs().toInt().toString();
    lokasiController.text = transaksiLama.location;
    deskripsiController.text = transaksiLama.description ?? '';
    selectedDate.value = transaksiLama.parsedDate;
    buktiPath.value = transaksiLama.iconUrl;
    if (transaksiLama.kategoriId != null) {
      selectedKategori.value = KategoriCatalog.byId(transaksiLama.kategoriId!);
    }

    // Mode edit langsung buka semua field
    isAdvancedOpen.value = true;
  }

  @override
  void simpanTransaksi() {
    final judul = judulController.text.trim();
    final nominal = double.tryParse(
          nominalController.text.replaceAll(RegExp(r'[^0-9]'), ''),
        ) ??
        0;

    if (judul.isEmpty || nominal <= 0) {
      Get.snackbar(
        'Peringatan',
        'Judul dan Nominal wajib diisi',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    final transaksiBaru = TransactionModel(
      id: transaksiLama.id, // id tetap sama
      merchantName: judul,
      date: (selectedDate.value ?? DateTime.now()).toIso8601String(),
      location: lokasiController.text.trim(),
      amount: -nominal,
      iconUrl: buktiPath.value,
      description: deskripsiController.text.trim(),
      kategoriId: selectedKategori.value?.id,
    );

    // Ganti data lama di list Riwayat & Dashboard (kalau halamannya ada)
    if (Get.isRegistered<RiwayatController>()) {
      _ganti(Get.find<RiwayatController>().transactions, transaksiBaru);
    }
    if (Get.isRegistered<DashboardController>()) {
      _ganti(Get.find<DashboardController>().transactions, transaksiBaru);
    }

    Get.back();
    Get.snackbar(
      'Berhasil',
      'Transaksi "$judul" berhasil diperbarui',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }

  void _ganti(RxList<TransactionModel> list, TransactionModel baru) {
    final index = list.indexWhere((t) => t.id == baru.id);
    if (index != -1) list[index] = baru;
  }
}
