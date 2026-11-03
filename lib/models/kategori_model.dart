enum KategoriPengeluaran {
  makanMinum,
  transportasi,
  tagihan,
  donasi,
  kesehatan,
  pendidikan,
  kebersihan,
  tempatTinggal,
  hiburan,
  tabungan,
  lainnya,
}

extension KategoriPengeluaranX on KategoriPengeluaran {
  String get label => switch (this) {
        KategoriPengeluaran.makanMinum => 'Makan & Minum',
        KategoriPengeluaran.transportasi => 'Transportasi',
        KategoriPengeluaran.tagihan => 'Tagihan',
        KategoriPengeluaran.donasi => 'Donasi',
        KategoriPengeluaran.kesehatan => 'Kesehatan',
        KategoriPengeluaran.pendidikan => 'Pendidikan',
        KategoriPengeluaran.kebersihan => 'Kebersihan',
        KategoriPengeluaran.tempatTinggal => 'Tempat Tinggal',
        KategoriPengeluaran.hiburan => 'Hiburan',
        KategoriPengeluaran.tabungan => 'Tabungan',
        KategoriPengeluaran.lainnya => 'Lainnya',
      };
}

class KategoriModel {
  KategoriPengeluaran kategori;
  int nominal;

  KategoriModel({required this.kategori, required this.nominal});
}