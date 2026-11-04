import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../models/kategori_catalog.dart';
import '../models/kategori_model.dart';
import '../models/transaction_model.dart';
import 'dashboard_controller.dart';

class PencatatanController extends GetxController {
  final selectedNavIndex = 1.obs; 

  final judulController = TextEditingController();
  final nominalController = TextEditingController();
  final deskripsiController = TextEditingController();
  final lokasiController = TextEditingController();

  final selectedDate = Rxn<DateTime>();
  final selectedKategori = Rxn<KategoriModel>();
  final isAdvancedOpen = false.obs;
  final buktiPath = RxnString();

  List<KategoriModel> get daftarKategori => KategoriCatalog.all;

  static const List<String> _namaBulan = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'Mei',
    'Jun',
    'Jul',
    'Agu',
    'Sep',
    'Okt',
    'Nov',
    'Des',
  ];

  String get formattedDate {
    final date = selectedDate.value;
    if (date == null) return 'belum dipilih...';
    return '${date.day} ${_namaBulan[date.month - 1]} ${date.year}';
  }

  String get shortDate {
    final date = selectedDate.value ?? DateTime.now();
    return '${date.day} ${_namaBulan[date.month - 1]}';
  }

  void changeNavIndex(int index) {
    selectedNavIndex.value = index;
  }

  void toggleAdvanced() {
    isAdvancedOpen.value = !isAdvancedOpen.value;
  }

  Future<void> pilihTanggal(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value ?? now,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.black,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      selectedDate.value = picked;
    }
  }

  void pilihKategori(KategoriModel? kategori) {
    selectedKategori.value = kategori;
  }

  final ImagePicker _picker = ImagePicker();

  Future<void> ambilFoto(ImageSource source) async {
    try {
      final XFile? foto = await _picker.pickImage(
        source: source,
        imageQuality: 70, 
        maxWidth: 1080, 
      );
      if (foto != null) {
        buktiPath.value = foto.path;
      }
    } catch (e) {
      Get.snackbar(
        'Gagal',
        'Gagal mengambil foto',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    }
  }

  void hapusFoto() {
    buktiPath.value = null;
  }

  void pilihLokasiDummy() {
    if (lokasiController.text.trim().isEmpty) {
      lokasiController.text = 'Telkom University, Bandung';
    }
    Get.snackbar(
      'Lokasi Dipilih',
      'Titik lokasi: ${lokasiController.text}',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }

  void simpanTransaksi() {
    final judul = judulController.text.trim();
    final nominalText =
        nominalController.text.replaceAll(RegExp(r'[^0-9]'), '');
    final nominal = double.tryParse(nominalText) ?? 0;

    if (judul.isEmpty) {
      Get.snackbar(
        'Peringatan',
        'Judul Transaksi wajib diisi',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    if (nominal <= 0) {
      Get.snackbar(
        'Peringatan',
        'Nominal Wajib Diisi',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    final lokasi = lokasiController.text.trim().isEmpty
        ? (selectedKategori.value?.name ?? 'Lokasi')
        : lokasiController.text.trim();

    final transaksiBaru = TransactionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      merchantName: judul,
      date: shortDate,
      location: lokasi,
      amount: -nominal,
      iconUrl: buktiPath.value,
      description: deskripsiController.text.trim(),
      kategoriId: selectedKategori.value?.id,
    );

    if (Get.isRegistered<DashboardController>()) {
      Get.find<DashboardController>().transactions.insert(0, transaksiBaru);
    }

    Get.back();
    Get.snackbar(
      'Berhasil',
      'Transaksi "$judul" berhasil disimpan',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }

  @override
  void onClose() {
    judulController.dispose();
    nominalController.dispose();
    deskripsiController.dispose();
    lokasiController.dispose();
    super.onClose();
  }
}
