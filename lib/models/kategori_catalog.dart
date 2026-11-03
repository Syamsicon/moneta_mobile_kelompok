import 'package:flutter/material.dart';
import 'package:moneta/models/kategori_model.dart';

class KategoriCatalog {
  KategoriCatalog._();

  static const makanMinum = KategoriModel(
      id: 'makan_minum', name: 'Makan & Minum', icon: Icons.fastfood, color: Colors.blue);
  static const tempatTinggal = KategoriModel(
      id: 'tempat_tinggal', name: 'Tempat Tinggal', icon: Icons.home, color: Colors.brown);
  static const transportasi = KategoriModel(
      id: 'transportasi', name: 'Transportasi', icon: Icons.directions_car, color: Colors.teal);
  static const tagihan = KategoriModel(
      id: 'tagihan', name: 'Tagihan', icon: Icons.receipt_long, color: Colors.purple);
  static const kesehatan = KategoriModel(
      id: 'kesehatan', name: 'Kesehatan', icon: Icons.favorite, color: Colors.pink);
  static const pendidikan = KategoriModel(
      id: 'pendidikan', name: 'Pendidikan', icon: Icons.school, color: Colors.indigo);
  static const kebersihan = KategoriModel(
      id: 'kebersihan', name: 'Kebersihan', icon: Icons.cleaning_services, color: Colors.cyan);
  static const hiburan = KategoriModel(
      id: 'hiburan', name: 'Hiburan', icon: Icons.sports_esports, color: Colors.orange);
  static const donasi = KategoriModel(
      id: 'donasi', name: 'Donasi', icon: Icons.volunteer_activism, color: Colors.red);
  static const tabungan = KategoriModel(
      id: 'tabungan', name: 'Tabungan', icon: Icons.savings, color: Colors.green);
  static const lainnya = KategoriModel(
      id: 'lainnya', name: 'Lainnya', icon: Icons.more_horiz, color: Colors.grey);

  static const all = <KategoriModel>[
    makanMinum, tempatTinggal, transportasi, tagihan, kesehatan,
    pendidikan, kebersihan, hiburan, donasi, tabungan, lainnya,
  ];

  static KategoriModel byId(String id) =>
      all.firstWhere((k) => k.id == id, orElse: () => lainnya);
}