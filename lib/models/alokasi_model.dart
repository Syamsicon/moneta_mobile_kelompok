import 'package:flutter/widgets.dart';

class AlokasiModel {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  bool isSelected;
  double amount;

  AlokasiModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    this.isSelected = false,
    this.amount = 0.0,
  });

  factory AlokasiModel.fromJson(Map<String, dynamic> json) {
    return AlokasiModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      icon: IconData(json['icon'] ?? 0, fontFamily: 'MaterialIcons'),
      color: json['color'] ?? '',
      isSelected: json['isSelected'] ?? false,
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon.codePoint,
      'color': color,
      'isSelected': isSelected,
      'amount': amount,
    };
  }
}
