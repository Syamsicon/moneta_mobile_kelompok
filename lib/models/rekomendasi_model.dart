import 'package:moneta/models/alokasi_model.dart';

class RekomendasiModel {
  final String nama;

  //Keseluruhan akan dibandingkan dengan pendapatan atau pengeluaran
  final double basis;
  final List<AlokasiModel> daftarAlokasi;

  RekomendasiModel({
    required this.nama,
    required this.basis,
    required this.daftarAlokasi,
  });

  double get total => daftarAlokasi.fold(0.0, (s, a) => s + a.amount);

  double persenDari(AlokasiModel a) => total == 0 ? 0 : a.amount / total * 100;

  //Rekomendasi berdasarkan pendapatan
  List<AlokasiModel> skalakan(double income) {
    final f = basis == 0 ? 0.0 : income / basis;
    return [
      for (final a in daftarAlokasi)
        a.copyWith(amount: (a.amount * f).roundToDouble()),
    ];
  }
}
