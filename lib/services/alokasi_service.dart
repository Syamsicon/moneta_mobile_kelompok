import 'package:get/get.dart';
import 'package:moneta/models/alokasi_model.dart';
import 'package:moneta/models/kategori_catalog.dart';
import 'package:moneta/models/rekomendasi_model.dart';

class AlokasiService extends GetxService {
  final monthlyIncome = 0.0.obs;
  final kategoriList = <AlokasiModel>[].obs;

  /// Bumped when values are changed from outside the form (e.g. a recommendation),
  /// so text fields with `initialValue` know to rebuild.
  final version = 0.obs;

  @override
  void onInit() {
    super.onInit();
    const defaultSelected = {'makan_minum', 'tabungan'};
    kategoriList.assignAll([
      for (final k in KategoriCatalog.all)
        AlokasiModel(kategori: k, isSelected: defaultSelected.contains(k.id)),
    ]);
  }

  void setIncome(double v) => monthlyIncome.value = v;

  void updateAmount(String id, double nominal) {
    final a = _find(id);
    if (a == null) return;
    a.amount = nominal;
    kategoriList.refresh();
  }

  void toggle(String id, bool selected) {
    final a = _find(id);
    if (a == null) return;
    a.isSelected = selected;
    if (!selected) a.amount = 0;
    kategoriList.refresh();
  }

//Berskala berdasarkan pendapatan
  void terapkan(RekomendasiModel r) {
    final income = monthlyIncome.value > 0 ? monthlyIncome.value : r.basis;
    final byId = {for (final a in r.skalakan(income)) a.id: a};

    for (final a in kategoriList) {
      final rec = byId[a.id];
      a.amount = rec?.amount ?? 0;
      a.isSelected = rec != null && rec.amount > 0;
    }
    monthlyIncome.value = income;
    kategoriList.refresh();
    version.value++;
  }

  AlokasiModel? _find(String id) =>
      kategoriList.firstWhereOrNull((a) => a.id == id);
}