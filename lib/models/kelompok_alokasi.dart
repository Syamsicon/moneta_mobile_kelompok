import 'package:moneta/models/kategori_model.dart';
import 'package:moneta/models/rekomendasi_model.dart';

/// The three groups shown in the pie chart / legend.
enum KelompokAlokasi { kebutuhan, keinginan, tabungan }

extension KelompokAlokasiX on KelompokAlokasi {
  String get label => switch (this) {
        KelompokAlokasi.kebutuhan => 'Kebutuhan',
        KelompokAlokasi.keinginan => 'Keinginan',
        KelompokAlokasi.tabungan => 'Tabungan',
      };
}

/// Decides which group every category belongs to.
/// Adjust this mapping to match your own definition of need / want / saving.
extension KategoriPengeluaranX on KategoriPengeluaran {
  KelompokAlokasi get kelompok => switch (this) {
        KategoriPengeluaran.makanMinum ||
        KategoriPengeluaran.transportasi ||
        KategoriPengeluaran.utilitas ||
        KategoriPengeluaran.kesehatan ||
        KategoriPengeluaran.pendidikan ||
        KategoriPengeluaran.kebersihan ||
        KategoriPengeluaran.tempatTinggal ||
        KategoriPengeluaran.cicilan =>
          KelompokAlokasi.kebutuhan,
        KategoriPengeluaran.langganan ||
        KategoriPengeluaran.donasi ||
        KategoriPengeluaran.hiburan ||
        KategoriPengeluaran.lainnya =>
          KelompokAlokasi.keinginan,
        KategoriPengeluaran.tabungan ||
        KategoriPengeluaran.investasi =>
          KelompokAlokasi.tabungan,
      };
}

extension RekomendasiModelX on RekomendasiModel {
  int get total => daftarAlokasi.fold(0, (sum, item) => sum + item.nominal);

  Map<KelompokAlokasi, int> get nominalPerKelompok {
    final hasil = {for (final k in KelompokAlokasi.values) k: 0};
    for (final item in daftarAlokasi) {
      final key = item.kategori.kelompok;
      hasil[key] = hasil[key]! + item.nominal;
    }
    return hasil;
  }

  /// Percentage (0..100) for each group, in enum order.
  Map<KelompokAlokasi, double> get persenPerKelompok {
    final t = total;
    return nominalPerKelompok.map(
      (kelompok, nominal) => MapEntry(kelompok, t == 0 ? 0.0 : nominal / t * 100),
    );
  }
}