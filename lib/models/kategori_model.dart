
enum KategoriPengeluaran{
  makanMinum,
  transportasi,
  utilitas,
  langganan,
  donasi,
  kesehatan,
  pendidikan,
  kebersihan,
  tempatTinggal,
  cicilan,
  hiburan,
  tabungan,
  investasi,
  lainnya
}


class KategoriModel {
  KategoriPengeluaran kategori;
  int nominal;

  KategoriModel({required this.kategori, required this.nominal});
}