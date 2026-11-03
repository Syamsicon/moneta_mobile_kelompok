import 'package:get/get.dart';
import 'package:moneta/models/alokasi_model.dart';
import 'package:moneta/models/kategori_catalog.dart';
import 'package:moneta/models/rekomendasi_model.dart';
import 'package:moneta/routes/app_routes.dart';
import 'package:moneta/services/alokasi_service.dart';

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
}