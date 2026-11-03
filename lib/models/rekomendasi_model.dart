

import 'package:moneta/models/kategori_model.dart';

class RekomendasiModel {
  String nama;
  List<KategoriModel> daftarAlokasi;

  RekomendasiModel({required this.nama, required this.daftarAlokasi});
}

extension RekomendasiModelX on RekomendasiModel {
  int get total => daftarAlokasi.fold(0, (sum, item) => sum + item.nominal);

  Map<KategoriPengeluaran, int> get nominalPerKategori {
    final hasil = {for (final k in KategoriPengeluaran.values) k: 0};
    for (final item in daftarAlokasi) {
      hasil[item.kategori] = hasil[item.kategori]! + item.nominal;
    }
    return hasil;
  }

  Map<KategoriPengeluaran, double> get persenPerKategori {
    final t = total;
    return nominalPerKategori.map(
      (kategori, nominal) =>
          MapEntry(kategori, t == 0 ? 0.0 : nominal / t * 100),
    );
  }
}