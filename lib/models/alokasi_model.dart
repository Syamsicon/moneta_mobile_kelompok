import 'package:flutter/widgets.dart';
import 'package:moneta/models/kategori_catalog.dart';
import 'package:moneta/models/kategori_model.dart';

class AlokasiModel {
  final KategoriModel kategori;
  bool isSelected;
  double amount;

  AlokasiModel({
    required this.kategori,
    this.isSelected = false,
    this.amount = 0.0,
  });

  // Delegates, so existing views keep using item.id / name / icon / color.
  String get id => kategori.id;
  String get name => kategori.name;
  IconData get icon => kategori.icon;
  Color get color => kategori.color;

  AlokasiModel copyWith({bool? isSelected, double? amount}) => AlokasiModel(
        kategori: kategori,
        isSelected: isSelected ?? this.isSelected,
        amount: amount ?? this.amount,
      );

  // Icon atau warna tidak termasuk
  factory AlokasiModel.fromJson(Map<String, dynamic> json) => AlokasiModel(
        kategori: KategoriCatalog.byId(json['kategoriId'] ?? ''),
        isSelected: json['isSelected'] ?? false,
        amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      );

  Map<String, dynamic> toJson() => {
        'kategoriId': kategori.id,
        'isSelected': isSelected,
        'amount': amount,
      };
}