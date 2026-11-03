import 'package:get/get.dart';
import 'package:moneta/models/kategori_model.dart';
import 'package:moneta/models/rekomendasi_model.dart';

class RekomendasiController extends GetxController {
  // TODO: take these from the real income / expense totals (e.g. DashboardController).
  static const _pendapatan = 5000000;
  static const _pengeluaran = 4200000;

  // Data for the two sections on the screen
  final berdasarkanPendapatan = <RekomendasiModel>[].obs;
  final berdasarkanPengeluaran = <RekomendasiModel>[].obs;

  /// The recommendation currently being applied (null = idle).
  final sedangDipakai = Rxn<RekomendasiModel>();

  final isLoading = false.obs;
  final errorMessage = RxnString();

  @override
  void onInit() {
    super.onInit();
    load();
  }

  /// Temporary: builds local dummy data.
  /// TODO: when the backend is ready, fetch here instead and fill the same two lists.
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

  /// Called by the "Pakai" button. Closes the page and returns the chosen
  /// recommendation to whoever opened it:
  /// `final r = await Get.toNamed(AppRoutes.rekomendasi);`
  /// TODO: send the choice to the backend before closing, once it exists.
  void pakai(RekomendasiModel rekomendasi) {
    Get.back(result: rekomendasi);
  }

  /// Splits [total] into the three groups, then spreads each group over
  /// a few categories so the model looks like real data.
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

    return RekomendasiModel(
      nama: nama,
      daftarAlokasi: [
        KategoriModel(kategori: KategoriPengeluaran.makanMinum, nominal: k * 40 ~/ 100),
        KategoriModel(kategori: KategoriPengeluaran.tempatTinggal, nominal: k * 30 ~/ 100),
        KategoriModel(kategori: KategoriPengeluaran.transportasi, nominal: k * 15 ~/ 100),
        KategoriModel(kategori: KategoriPengeluaran.utilitas, nominal: k * 15 ~/ 100),
        KategoriModel(kategori: KategoriPengeluaran.hiburan, nominal: w * 60 ~/ 100),
        KategoriModel(kategori: KategoriPengeluaran.langganan, nominal: w * 40 ~/ 100),
        KategoriModel(kategori: KategoriPengeluaran.tabungan, nominal: s * 60 ~/ 100),
        KategoriModel(kategori: KategoriPengeluaran.investasi, nominal: s * 40 ~/ 100),
      ],
    );
  }
}